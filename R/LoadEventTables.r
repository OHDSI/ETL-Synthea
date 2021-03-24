#' @title Load CDM Non-Vocabulary Tables.
#'
#' @description This function loads the CDM Event tables with Synthea data.
#'
#' @usage LoadEventTables (connectionDetails, cdmSchema, syntheaSchema, cdmVersion, sqlOnly)
#'
#' @details This function assumes \cr\code{createCDMTables()}, \cr\code{createSyntheaTables()}, \cr\code{LoadSyntheaTables()},
#'              and \cr\code{LoadVocabTables()} have all been run.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the database schema that will contain the different VISIT
#'                                     tables.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param syntheaSchema  The name of the database schema that contain the Synthea
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param cdmVersion The version of your CDM.  Currently "5.3.1" and "6.0.0".
#' @param syntheaVersion The version of Synthea used to generate the csv files.  
#'                       Currently "master" and "2.7.0" are supported.  The default is "2.7.0".
#' @param sqlOnly A boolean that determines whether or not to perform the load or generate SQL scripts. Default is FALSE.
#'
#'@export


LoadEventTables <- function (connectionDetails,
                             cdmSchema,
							 syntheaSchema,
							 cdmVersion,
							 syntheaVersion = "2.7.0",
							 sqlOnly = FALSE)
{

	# Determine which sql scripts to run based on the given version.
	# The path is relative to inst/sql/sql_server.
	if (cdmVersion == "5.3.1") {
		sqlFilePath <- "cdm_version/v531"
	} else if (cdmVersion == "6.0.0") {
		sqlFilePath <- "cdm_version/v600"
	} else {
		stop("Unsupported CDM specified. Supported CDM versions are \"5.3.1\" and \"6.0.0\"")
	}

    supportedSyntheaVersions <- c("2.7.0","master")

	if (!(syntheaVersion %in% supportedSyntheaVersions))
		stop("Invalid synthea version specified.  Currently \"master\" and \"2.7.0\" are supported")

	# Create Vocabulary mapping tables
	CreateVocabMapTables(connectionDetails, cdmSchema, cdmVersion, sqlOnly)

	# Perform visit rollup logic and create auxiliary tables
	CreateVisitRollupTables(connectionDetails,cdmSchema,syntheaSchema,cdmVersion,sqlOnly)


	if (!sqlOnly) {
		conn <- DatabaseConnector::connect(connectionDetails)
	} else {
		if (!dir.exists("output")) {
			dir.create("output")
		}
	}

	runStep <- function(sql, fileQuery) {
		if (sqlOnly) {
			writeLines(paste0("Saving to output/", sql))
			SqlRender::writeSql(sql, paste0("output/", fileQuery))
		} else {
			writeLines(paste0("Running: ", fileQuery))
			DatabaseConnector::executeSql(conn, sql)
		}
	}

	# person
	fileQuery <- "insert_person.sql"
	sql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = file.path(sqlFilePath, fileQuery),
		packageName = "ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmSchema,
		synthea_schema = syntheaSchema
	)
	runStep(sql,fileQuery)

	# observation period
	fileQuery <- "insert_observation_period.sql"
	sql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = file.path(sqlFilePath, fileQuery),
		packageName = "ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmSchema,
		synthea_schema = syntheaSchema
	)
	runStep(sql,fileQuery)

	# visit occurrence
	fileQuery <- "insert_visit_occurrence.sql"
	sql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = file.path(sqlFilePath, fileQuery),
		packageName = "ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmSchema
	)
	runStep(sql,fileQuery)

	# condition occurrence
	fileQuery <- "insert_condition_occurrence.sql"
	sql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = file.path(sqlFilePath, fileQuery),
		packageName = "ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmSchema,
		synthea_schema = syntheaSchema
	)
	runStep(sql,fileQuery)

	# observation
	fileQuery <- "insert_observation.sql"
	sql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = file.path(sqlFilePath, fileQuery),
		packageName = "ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmSchema,
		synthea_schema = syntheaSchema
	)
	runStep(sql,fileQuery)

	# measurement
	fileQuery <- "insert_measurement.sql"
	sql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = file.path(sqlFilePath, fileQuery),
		packageName = "ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmSchema,
		synthea_schema = syntheaSchema,
		synthea_version = syntheaVersion
	)
	runStep(sql,fileQuery)

	# procedure occurrence
	fileQuery <- "insert_procedure_occurrence.sql"
	sql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = file.path(sqlFilePath, fileQuery),
		packageName = "ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmSchema,
		synthea_schema = syntheaSchema,
		synthea_version = syntheaVersion
	)
	runStep(sql,fileQuery)

	# drug exposure
	fileQuery <- "insert_drug_exposure.sql"
	sql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = file.path(sqlFilePath, fileQuery),
		packageName = "ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmSchema,
		synthea_schema = syntheaSchema
	)
	runStep(sql,fileQuery)

	# condition era
	fileQuery <- "insert_condition_era.sql"
	sql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = file.path(sqlFilePath, fileQuery),
		packageName = "ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmSchema
	)
	runStep(sql,fileQuery)

	# drug era
	fileQuery <- "insert_drug_era.sql"
	sql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = file.path(sqlFilePath, fileQuery),
		packageName = "ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmSchema
	)
	runStep(sql,fileQuery)

	# cdm source
	fileQuery <- "insert_cdm_source.sql"
	sql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = file.path(sqlFilePath, fileQuery),
		packageName = "ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmSchema
	)
	runStep(sql,fileQuery)

	# visit detail
	fileQuery <- "insert_visit_detail.sql"
	sql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = file.path(sqlFilePath, fileQuery),
		packageName = "ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmSchema
	)
	runStep(sql,fileQuery)

	# device exposure
	fileQuery <- "insert_device_exposure.sql"
	sql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = file.path(sqlFilePath, fileQuery),
		packageName = "ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmSchema,
		synthea_schema = syntheaSchema
	)
	runStep(sql,fileQuery)

	# death
	fileQuery <- "insert_death.sql"
	sql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = file.path(sqlFilePath, fileQuery),
		packageName = "ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmSchema,
		synthea_schema = syntheaSchema
	)
	runStep(sql,fileQuery)

	if (!sqlOnly) {
		DatabaseConnector::disconnect(conn)
	}
}
