#' @title Drop OMOP CDM Tables.
#'
#' @description This function drops CDM tables, excluding Vocabulary tables. 
#'
#' @usage DropCDMTables(connectionDetails,cdmDatabaseSchema)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmDatabaseSchema  The name of the database schema that contains the OMOP CDM
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#'
#'@export


DropEventTables <- function (connectionDetails, cdmDatabaseSchema)
{


    pathToSql <- base::system.file("sql/sql_server", package = "ETLSyntheaBuilder")

    sqlFile <- base::paste0(pathToSql, "/", "drop_event_tables.sql")

    sqlQuery <- base::readChar(sqlFile, base::file.info(sqlFile)$size)

    renderedSql <- SqlRender::render(sqlQuery, cdm_schema = cdmDatabaseSchema)

    translatedSql <- SqlRender::translate(renderedSql, targetDialect = connectionDetails$dbms)

    writeLines("Running drop_event_tables.sql")
	
	conn <- DatabaseConnector::connect(connectionDetails) 
	
    DatabaseConnector::dbExecute(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE)

    on.exit(DatabaseConnector::disconnect(conn)) 
	
}