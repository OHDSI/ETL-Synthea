#' @title Drop OMOP CDM Tables.
#'
#' @description This function drops all OMOP CDM tables. 
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


DropCDMTables <- function (connectionDetails, cdmDatabaseSchema)
{


    pathToSql <- base::system.file("sql/sql_server", package = "ETLSyntheaBuilder")

    sqlFile <- base::paste0(pathToSql, "/", "drop_cdm_tables.sql")

    sqlQuery <- base::readChar(sqlFile, base::file.info(sqlFile)$size)

    renderedSql <- SqlRender::renderSql(sqlQuery, cdm_schema = cdmDatabaseSchema)$sql

    translatedSql <- SqlRender::translateSql(renderedSql, targetDialect = connectionDetails$dbms)$sql

    writeLines("Running drop_cdm_tables.sql")
	
	conn <- DatabaseConnector::connect(connectionDetails) 
	
    DatabaseConnector::dbExecute(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE)

    on.exit(DatabaseConnector::disconnect(conn)) 
	
}