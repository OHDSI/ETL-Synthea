#' @title Create Tables for Visit Rollup Logic.
#'
#' @description This function creates tables ALL_VISITS, ASSIGN_ALL_VISIT_IDS, and FINAL_VISIT_IDS.
#'
#' @usage CreateVisitRollupTables (connectionDetails, cdmDatabaseSchema, syntheaDatabaseSchema)
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


CreateVisitRollupTables <- function (connectionDetails, cdmDatabaseSchema, syntheaDatabaseSchema)
{

    queries <- c("AllVisitTable.sql", "AAVITable.sql", "final_visit_ids.sql")
    
	conn <- DatabaseConnector::connect(connectionDetails) 
	
	for (query in queries) {
	
        pathToSql <- base::system.file("sql/sql_server", package = "ETLSyntheaBuilder")

        sqlFile <- base::paste0(pathToSql, "/", query)

        sqlQuery <- base::readChar(sqlFile, base::file.info(sqlFile)$size)

        renderedSql <- SqlRender::render(sqlQuery, cdm_schema = cdmDatabaseSchema, synthea_schema = syntheaDatabaseSchema)

        translatedSql <- SqlRender::translate(renderedSql, targetDialect = connectionDetails$dbms)

        writeLines(paste0("Running: ",query))
	
        DatabaseConnector::executeSql(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE)

    }
	
    on.exit(DatabaseConnector::disconnect(conn)) 
	
}