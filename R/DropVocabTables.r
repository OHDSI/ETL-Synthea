#' @title Drop Vocabulary Tables.
#'
#' @description This function drops Vocabulary tables in a CDM.
#'
#' @usage DropVocabTables(connectionDetails,cdmSchema)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the CDM schema that contains the Vocabulary.  
#'                   Requires read and write permissions to this database. On SQL
#'                   Server, this should specifiy both the database and the schema,
#'                   so for example 'vocab_instance.dbo'.
#'@export


DropVocabTables <- function (connectionDetails, cdmSchema)
{

    translatedSql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = "drop_vocab_tables.sql",
		packageName = "ETLSyntheaBuilder",
		dbms        = connectionDetails$dbms,
		cdm_schema  = cdmSchema
	)

    writeLines("Running drop_vocab_tables.sql")
	
	conn <- DatabaseConnector::connect(connectionDetails) 
	
    DatabaseConnector::dbExecute(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE)

    on.exit(DatabaseConnector::disconnect(conn)) 
	
}