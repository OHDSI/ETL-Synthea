#' @title Drop OMOP CDM Tables.
#'
#' @description This function drops CDM tables, excluding Vocabulary tables. 
#'
#' @usage DropCDMTables(connectionDetails,cdmSchema)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the database schema that contains the OMOP CDM
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#'
#'@export


DropEventTables <- function (connectionDetails, cdmSchema)
{


    translatedSql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = "drop_event_tables.sql",
		packageName = "ETLSyntheaBuilder",
		dbms        = connectionDetails$dbms,
		cdm_schema  = cdmSchema
	)

    writeLines("Running drop_event_tables.sql")
	
	conn <- DatabaseConnector::connect(connectionDetails) 
	
    DatabaseConnector::dbExecute(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE)

    on.exit(DatabaseConnector::disconnect(conn)) 
	
}