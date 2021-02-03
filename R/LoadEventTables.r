#' @title Load CDM Non-Vocabulary Tables.
#'
#' @description This function loads the CDM Event tables with Synthea data.  
#'
#' @usage LoadEventTables (connectionDetails, cdmSchema, syntheaSchema, cdmVersion)
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
#'
#'@export


LoadEventTables <- function (connectionDetails, cdmSchema, syntheaSchema, cdmVersion)
{

	# Create Vocabulary mapping tables
	CreateVocabMapTables(connectionDetails, cdmSchema, cdmVersion)
	
	# Perform visit rollup logic and create auxiliary tables
	CreateVisitRollupTables(connectionDetails, cdmSchema, syntheaSchema, cdmVersion)
	
	# The sql scripts to insert into each CDM event table rely on the vocab mapping tables and the visit auxiliary tables
    queries <- c("insert_person.sql", "insert_observation_period.sql", "insert_visit_occurrence.sql", "insert_condition_occurrence.sql",
                 "insert_observation.sql", "insert_measurement.sql", "insert_procedure_occurrence.sql", "insert_drug_exposure.sql",
				 "insert_condition_era.sql", "insert_drug_era.sql", "insert_cdm_source.sql")

	conn <- DatabaseConnector::connect(connectionDetails)

	# Determine which sql scripts to run based on the given version.
	# The path is relative to inst/sql/sql_server.
	
	if (cdmVersion == "5.3.1")
		sqlFilePath <- "cdm_version/v531"
	else if (cdmVersion == "6.0.0")
		sqlFilePath <- "cdm_version/v600"
	else
		stop("Unsupported CDM specified. Supported CDM versions are \"5.3.1\" and \"6.0.0\"")
	
	for (query in queries) {

		translatedSql <- SqlRender::loadRenderTranslateSql(
			sqlFilename    = paste0(sqlFilePath,"/",query),
			packageName    = "ETLSyntheaBuilder",
			dbms           = connectionDetails$dbms,
			cdm_schema     = cdmSchema,
			synthea_schema = syntheaSchema 
		)

        writeLines(paste0("Running: ",query))

        DatabaseConnector::executeSql(conn, translatedSql)

    }

    on.exit(DatabaseConnector::disconnect(conn))

}
