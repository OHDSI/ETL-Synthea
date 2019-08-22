library(SqlRender)
library(DatabaseConnector)
library(CohortMethod)
library(RSQLite) # must install from devtools::install_github("r-dbi/RSQLite")
library(ETLSyntheaBuilder)

options(fftempdir = "D:/fftemp")
options(connectionObserver = NULL)

countPeopleToSimulate <- 5000

cdmSchema <- "cdm_synthea_v897.dbo"
vocabSourceSchema <- "Vocabulary_20190123.dbo"
vocabTargetSchema <- cdmSchema
executeOnSqlite <- FALSE
cdmVersion <- "5"

connectionDetails <- DatabaseConnector::createConnectionDetails(
	dbms="pdw",
	server="JRDUSAPSCTL01",
	port=17001
)
connection <- DatabaseConnector::connect(connectionDetails)

startTime <- Sys.time()

# simulate data
syntheaLocation <- "D:\\git\\synthea\\output\\csv"
setwd("D:\\git\\synthea\\")
syntheaCommand <- paste("run_synthea \"New Jersey\" -P", countPeopleToSimulate, "--generate.log_patients.detail=none")
system(syntheaCommand,
       intern = FALSE,
       ignore.stdout = FALSE,
       ignore.stderr = FALSE,
       wait = TRUE,
       input = NULL,
       show.output.on.console = TRUE,
       minimized = FALSE,
       invisible = FALSE)

# this is a bulk data load utility from Microsoft for the Parallel Data Warehouse appliance
# this will not apply to most environments however a bulk load utility, similar to the copy command from other
# database platforms should be used for the loading of data instead of attempting to perform individual insert statements.
Sys.setenv(DWLOADER_PATH = "C:\\Program Files\\Microsoft SQL Server Parallel Data Warehouse\\100\\DWLoader.exe")

bulkLoadPdw <- function(connection, qname, data) {
  start <- Sys.time()
  eol <- "\r\n"
  fileName <- file.path(tempdir(), sprintf("pdw_insert_%s", uuid::UUIDgenerate(use.time = TRUE)))
  write.table(x = data, na = "", file = sprintf("%s.csv", fileName), row.names = FALSE, quote = FALSE, col.names = TRUE, sep = "~*~")
  R.utils::gzip(filename = sprintf("%s.csv",fileName), destname = sprintf("%s.gz", fileName), remove = TRUE)

  auth <- sprintf("-U %1s -P %2s", attr(connection, "user"), attr(connection, "password"))
  if (is.null(attr(connection, "user")) && is.null(attr(connection, "password"))) {
    auth <- "-W"
  }

  databaseMetaData <- rJava::.jcall(connection@jConnection, "Ljava/sql/DatabaseMetaData;","getMetaData")
  url <- rJava::.jcall(databaseMetaData, "Ljava/lang/String;", "getURL")
  pdwServer <- urltools::url_parse(url)$domain

  if (pdwServer == "" | is.null(pdwServer)) {
    stop("PDW Server name cannot be parsed from JDBC URL string")
  }

  command <- sprintf("%1s -M append -e UTF8 -i %2s -T %3s -R dwloader.txt -fh 1 -t %4s -r %5s -D ymd -E -se -rv 1 -S %6s %7s",
                     shQuote(Sys.getenv("DWLOADER_PATH")),
                     shQuote(sprintf("%s.gz", fileName)),
                     qname,
                     shQuote("~*~"),
                     shQuote(eol),
                     pdwServer,
                     auth)

  tryCatch({
    system(command,
           intern = FALSE,
           ignore.stdout = FALSE,
           ignore.stderr = FALSE,
           wait = TRUE,
           input = NULL,
           show.output.on.console = TRUE,
           minimized = FALSE,
           invisible = FALSE)
    delta <- Sys.time() - start
    writeLines(paste("Bulk load to PDW took", signif(delta, 3), attr(delta, "units")))
  }, error = function(e) {
    stop("Error in PDW bulk upload. Please check dwloader.txt and dwloader.txt.reason.")
  }, finally = {
    try(file.remove(sprintf("%s.gz", fileName)), silent = TRUE)
  })
}

ETLSyntheaBuilder::DropSyntheaTables(connectionDetails,cdmSchema)
ETLSyntheaBuilder::CreateSyntheaTables(connectionDetails, cdmSchema)

# bulk load of files
files <- list("allergies","careplans","conditions", "encounters", "imaging_studies", "immunizations", "medications", "observations", "organizations", "patients", "procedures", "providers")
for (f in files) {
	print(paste0('processing file: ',f))
	targetFile <- file.path(syntheaLocation, paste0(f, ".csv"))
	data <- read.table(targetFile, sep=",", header=TRUE, stringsAsFactors = FALSE, quote="", comment.char="")
	qualifiedTableName <- paste0("CDM_Synthea_v897.dbo.",f)
	bulkLoadPdw(connection,qualifiedTableName, data)
}

ETLSyntheaBuilder::DropVocabTables(connectionDetails, vocabTargetSchema)
# ETLSyntheaBuilder::CreateVocabTables(connectionDetails, vocabTargetSchema)
# load now using ctas
ETLSyntheaBuilder::LoadVocabFromSchema(connectionDetails, vocabSourceSchema, vocabTargetSchema)

ETLSyntheaBuilder::TruncateEventTables(connectionDetails,cdmSchema)
ETLSyntheaBuilder::CreateVisitRollupTables(connectionDetails,cdmSchema,cdmSchema)
ETLSyntheaBuilder::LoadCDMTables(connectionDetails,cdmSchema,cdmSchema)

# ETLSyntheaBuilder::restoreCDMTables(connectionDetails,cdmSchema)

# prune tables
eventData <- getEventConceptId(connectionDetails,cdmSchema)
eventConceptId <- eventData$CONCEPT_ID

ETLSyntheaBuilder::backupCDM(connectionDetails,cdmSchema,vocabTargetSchema)
ETLSyntheaBuilder::createPrunedTables(connectionDetails,cdmSchema,vocabTargetSchema,eventConceptId)

# generate cohorts into coxibVsNonselVsGiBleed custom cohort table
sql <- SqlRender::loadRenderTranslateSql("coxibVsNonselVsGiBleed.sql",
                              packageName = "CohortMethod",
                              dbms = connectionDetails$dbms,
                              cdmDatabaseSchema = cdmSchema,
                              resultsDatabaseSchema = cdmSchema)
DatabaseConnector::executeSql(connection, sql)

# Check number of subjects per cohort:
sql <- "SELECT cohort_definition_id, COUNT(*) AS count FROM @resultsDatabaseSchema.coxibVsNonselVsGiBleed GROUP BY cohort_definition_id"
sql <- SqlRender::render(sql, resultsDatabaseSchema = cdmSchema)
sql <- SqlRender::translate(sql, targetDialect = connectionDetails$dbms)
DatabaseConnector::querySql(connection, sql)

# ****************************************
# PAUSE HERE AND RUN SPECIALIZED PRUNE CODE
# ****************************************

if (executeOnSqlite) {
	sqliteFilename <- paste("cdm", format(Sys.time(), "%Y%m%d%H%M%S"), "sqlite", sep = ".")
	ETLSyntheaBuilder::exportToSQLite(connectionDetails,cdmSchema,cdmSchema, SQLiteDbName = sqliteFilename)
	# Change to Sqlite database to run study
	sqliteConnectionDetails  <- DatabaseConnector::createConnectionDetails(dbms = "sqlite", server = sqliteFilename)
	connectionDetails <- sqliteConnectionDetails
	cdmSchema <- "main"

	connection <- DatabaseConnector::connect(connectionDetails)
	# generate cohorts into coxibVsNonselVsGiBleed custom cohort table in sqlite
	sql <- SqlRender::loadRenderTranslateSql("coxibVsNonselVsGiBleed.sql",
																					 packageName = "CohortMethod",
																					 dbms = connectionDetails$dbms,
																					 cdmDatabaseSchema = cdmSchema,
																					 resultsDatabaseSchema = cdmSchema)
	DatabaseConnector::executeSql(connection, sql)

	# Check number of subjects per cohort in sqlite
	sql <- "SELECT cohort_definition_id, COUNT(*) AS count FROM @resultsDatabaseSchema.coxibVsNonselVsGiBleed GROUP BY cohort_definition_id"
	sql <- SqlRender::render(sql, resultsDatabaseSchema = cdmSchema)
	sql <- SqlRender::translate(sql, targetDialect = connectionDetails$dbms)
	DatabaseConnector::querySql(connection, sql)
}

# run study

covSettings <- FeatureExtraction::createDefaultCovariateSettings(
	excludedCovariateConceptIds = c(1124300,1118084),
	addDescendantsToExclude = TRUE)

# Load data:
cohortMethodData <- CohortMethod::getDbCohortMethodData(connectionDetails = connectionDetails,
                                                        cdmDatabaseSchema = cdmSchema,
                                                        targetId = 1,
                                                        comparatorId = 2,
                                                        outcomeIds = 3,
                                                        studyStartDate = "",
                                                        studyEndDate = "",
                                                        exposureDatabaseSchema = cdmSchema,
                                                        exposureTable = "coxibVsNonselVsGiBleed",
                                                        outcomeDatabaseSchema = cdmSchema,
                                                        outcomeTable = "coxibVsNonselVsGiBleed",
                                                        cdmVersion = cdmVersion,
                                                        excludeDrugsFromCovariates = FALSE,
                                                        firstExposureOnly = TRUE,
                                                        removeDuplicateSubjects = "remove all",
                                                        restrictToCommonPeriod = FALSE,
                                                        washoutPeriod = 180,
                                                        covariateSettings = covSettings)


summary(cohortMethodData)
#getAttritionTable(cohortMethodData)

studyPop <- createStudyPopulation(cohortMethodData = cohortMethodData,
                                  outcomeId = 3,
                                  firstExposureOnly = FALSE,
                                  washoutPeriod = 0,
                                  removeDuplicateSubjects = TRUE,
                                  removeSubjectsWithPriorOutcome = TRUE,
                                  minDaysAtRisk = 1,
                                  riskWindowStart = 0,
                                  addExposureDaysToStart = FALSE,
                                  riskWindowEnd = 9999,
                                  addExposureDaysToEnd = TRUE)

ps <- createPs(cohortMethodData = cohortMethodData,
               population = studyPop,
               errorOnHighCorrelation = TRUE,
               prior = createPrior("laplace", exclude = c(0), useCrossValidation = FALSE),
               control = createControl(cvType = "auto",
                                       startingVariance = 0.01,
                                       noiseLevel = "quiet",
                                       tolerance = 2e-07,
                                       cvRepetitions = 1,
                                       threads = 10))

model <- getPsModel(ps, cohortMethodData)
plotPs(ps, scale = "propensity", showCountsLabel = TRUE, showEquiposeLabel = TRUE)

matchedPop <- matchOnPs(ps, caliper = 0.25, caliperScale = "standardized", maxRatio = 1)
balance <- computeCovariateBalance(matchedPop, cohortMethodData)
plotCovariateBalanceScatterPlot(balance, showCovariateCountLabel = TRUE, showMaxLabel = TRUE)

outcomeModel <- fitOutcomeModel(population = studyPop, modelType = "cox")
summary(outcomeModel)

outcomeModel <- fitOutcomeModel(population = matchedPop, modelType = "cox", stratified = TRUE, useCovariates = FALSE)
summary(outcomeModel)

endTime <- Sys.time()
print(endTime-startTime)
