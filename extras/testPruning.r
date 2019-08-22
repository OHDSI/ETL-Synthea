
devtools::install_github("OHDSI/DatabaseConnector",dependencies = TRUE, force = TRUE)
library(DatabaseConnector)

install.packages("digest")

# Connection info for pdw
cd <- DatabaseConnector::createConnectionDetails(
  dbms="pdw",
  server="JRDUSAPSCTL01",
  port=17001
)

# Params for prune and export call
cdmSchema    <- "scratch.amolin19" # pdw
vocabSchema  <- "scratch.amolin19" # pdw
pathToSql    <- "D:\\Apps\\Git\\eunomia_tools\\sql"
SQLiteDir    <- "D:\\Apps\\Git\\eunomia_tools\\Data\\SQLite"
SQLiteCDM    <- "cdm.sqlite"
SQLiteDB     <- paste0(SQLiteDir,"\\",SQLiteCDM)

# Prune the code and create a sqlite db
pruneCDM(cd,cdmSchema,vocabSchema,pathToSql)
exportToSQLite(cd,cdmSchema,vocabSchema,SQLiteFileLoc = SQLiteDir)

# Check that sqlite has our cdm data
sqliteCon <- DBI::dbConnect(RSQLite::SQLite(),SQLiteDB)
RSQLite::dbGetQuery(sqliteCon,"SELECT observation_period_start_date, date(observation_period_start_date) FROM observation_period LIMIT 10")
RSQLite::dbListTables(sqliteCon)
RSQLite::dbDisconnect(sqliteCon)


# Try to connect to sqlite using dbconnector
sqliteCD        <- DatabaseConnector::createConnectionDetails(dbms = "sqlite", server = SQLiteDB)
sqliteQuery     <- "select count(*) from PERSON;"
renderedSql     <- SqlRender::render(sqliteQuery)
translatedSql   <- SqlRender::translate(renderedSql,sqliteCD$dbms)

# ERROR BELOW! Need to figure out how to make db connector connect to sqlite
#
sqliteQueryConn <- DatabaseConnector::connect(sqliteCD)
DatabaseConnector::querySql(sqliteQueryConn,translatedSql)


#
# Perform each step in pruneCDM manually:
#
# eventData <- getEventConceptId(cd,cdmSchema,pathToSql)
# length(eventData$CONCEPT_ID)
# backupCDM(cd,cdmSchema,vocabSchema,pathToSql)
# eventConceptId <- eventData$CONCEPT_ID
# createPrunedTables(cd,cdmSchema,vocabSchema,eventConceptId,pathToSql)
# 
# # Undo the pruning with the code below
# restoreCDMTables(cd,cdmSchema,vocabSchema,pathToSql)
#
