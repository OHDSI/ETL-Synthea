#' @title Load CDM Tables.
#'
#' @description This function loads the CDM tables with Synthea data.  The tables that comprise the Vocabulary are
#'               loaded via \cr\code{LoadVocabTables()}.
#'
#' @usage LoadCDMTables (connectionDetails, cdmDatabaseSchema, syntheaDatabaseSchema)
#'
#' @details This function assumes \cr\code{createCDMTables()}, \cr\code{createSyntheaTables()}, \cr\code{LoadSyntheaTables()}, 
#'              and \cr\code{LoadVocabTables()} have all been run.  
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmDatabaseSchema  The name of the database schema that will contain the different VISIT 
#'                                     tables.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param syntheaDatabaseSchema  The name of the database schema that contain the Synthea
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#'
#'@export


LoadCDMTables <- function (connectionDetails, cdmDatabaseSchema, syntheaDatabaseSchema)
{

    queries <- c("insert_person.sql", "insert_observation_period.sql", "insert_visit_occurrence.sql", "insert_condition_occurrence.sql",
                 "insert_observation.sql", "insert_measurement.sql", "insert_procedure_occurrence.sql", "insert_drug_exposure.sql ",
				 "insert_condition_era.sql", "insert_drug_era.sql")
    
	conn <- DatabaseConnector::connect(connectionDetails) 
	
	for (query in queries) {
	
        pathToSql <- base::system.file("sql/sql_server", package = "ETLSyntheaBuilder")

        sqlFile <- base::paste0(pathToSql, "/", query)

        sqlQuery <- base::readChar(sqlFile, base::file.info(sqlFile)$size)

        renderedSql <- SqlRender::renderSql(sqlQuery, cdm_schema = cdmDatabaseSchema, synthea_schema = syntheaDatabaseSchema)$sql

        translatedSql <- SqlRender::translateSql(renderedSql, targetDialect = connectionDetails$dbms)$sql

        writeLines(paste0("Running: ",query))
	
        DatabaseConnector::executeSql(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE)

    }
	
    on.exit(DatabaseConnector::disconnect(conn)) 
	
}
