#' @title Create pruned CDM and Vocab tables.
#'
#' @description This function creates the pruned cdm and vocab tables by keeping only those rows from
#'              the original tables for given concept_ids.
#'
#' @usage createPrunedTables(connectionDetails,cdmDatabaseSchema,vocabDatabaseSchema,eventConceptId)
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
#' @param vocabDatabaseSchema  The name of the database schema that contains the Vocabulary
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'vocab_instance.dbo'.
#'
#' @param eventConceptId      A vector of concept_ids returned from \code{getEventConceptId}.
#'
#'@export


createPrunedTables <- function (connectionDetails, cdmDatabaseSchema, vocabDatabaseSchema, eventConceptId)
{
	sql <- SqlRender::loadRenderTranslateSql(
		"create_pruned_tables.sql",
		"ETLSyntheaBuilder",
		dbms = connectionDetails$dbms,
		cdm_schema = cdmDatabaseSchema,
		vocab_schema = vocabDatabaseSchema,
		event_concept_id = eventConceptId
	)

	conn <- DatabaseConnector::connect(connectionDetails)

	DatabaseConnector::dbExecute(conn,
															 sql,
															 progressBar = TRUE,
															 reportOverallTime = TRUE)

	on.exit(DatabaseConnector::disconnect(conn))
}
