#' @title Get All Concept_ids In All Event Tables.
#'
#' @description This function gets the unique concept_ids in all event tables.
#'
#' @usage getEventConceptId(connectionDetails,cdmSchema,cdmVersion)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#'
#' @param cdmSchema  The name of the database schema that contains the CDM.
#'                   Requires read and write permissions to this database. On SQL
#'                   Server, this should specifiy both the database and the schema,
#'                   so for example 'cdm_instance.dbo'.
#' @param cdmVersion The version of your CDM.  Currently "5.3" and "6.0".
#'
#'@export

getEventConceptId <- function (connectionDetails, cdmSchema, cdmVersion)
{

	if (cdmVersion == "5.3")
		sqlFilePath <- "v53"
	else if (cdmVersion == "6.0")
		sqlFilePath <- "v60"

	sql <- SqlRender::loadRenderTranslateSql(
			sqlFileName = paste0(sqlFilePath,"/get_event_concept_id.sql"),
			packageName = "ETLSyntheaBuilder",
			dbms        = connectionDetails$dbms,
			cdm_schema  = cdmSchema
			)

	conn <- DatabaseConnector::connect(connectionDetails)

	eventConceptId <- DatabaseConnector::querySql(conn, sql)

	on.exit(DatabaseConnector::disconnect(conn))

	return (eventConceptId)
}
