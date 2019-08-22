#' @title Truncate Non-Vocabulary CDM Tables.
#'
#' @description This function truncates CDM tables, excluding Vocabulary tables.
#'
#' @usage TruncateCDMTables(connectionDetails,cdmDatabaseSchema)
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


TruncateEventTables <- function (connectionDetails, cdmDatabaseSchema)
{
	sql <- SqlRender::loadRenderTranslateSql("truncate_event_tables.sql", "ETLSyntheaBuilder", dbms = connectionDetails$dbms, cdm_schema = cdmDatabaseSchema)
	conn <- DatabaseConnector::connect(connectionDetails)
	DatabaseConnector::dbExecute(conn, sql, progressBar = TRUE, reportOverallTime = TRUE)
  on.exit(DatabaseConnector::disconnect(conn))
}
