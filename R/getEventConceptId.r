#' @title Get All Concept_ids In All Event Tables.
#'
#' @description This function gets the unique concept_ids in all event tables.
#'
#' @usage getEventConceptId(connectionDetails,cdmDatabaseSchema)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#'
#' @param cdmDatabaseSchema  The name of the database schema that contains the CDM
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#'
#'@export

getEventConceptId <- function (connectionDetails, cdmDatabaseSchema)
{
	sql <- SqlRender::loadRenderTranslateSql("get_event_concept_id.sql",
																		"ETLSyntheaBuilder",
																		dbms = connectionDetails$dbms,
																		cdm_schema = cdmDatabaseSchema
																		)

	conn <- DatabaseConnector::connect(connectionDetails)

	eventConceptId <- DatabaseConnector::querySql(conn, sql)

	on.exit(DatabaseConnector::disconnect(conn))

	return (eventConceptId)
}
