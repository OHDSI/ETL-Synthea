#' @title Restore the CDM (undo the pruning).
#'
#' @description This function undoes the pruning by renaming (the *_orig tables are given their names back).
#'
#' @usage restoreCDMTables(connectionDetails,cdmDatabaseSchema,vocabDatabaseSchema)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmDatabaseSchema  The name of the database schema that contains the CDM
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param vocabDatabaseSchema  The name of the database schema that contains the Vocabulary
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'vocab_instance.dbo'.
#'@export


restoreCDMTables <- function (connectionDetails, vocabDatabaseSchema)
{
	sql <- SqlRender::loadRenderTranslateSql("restore_cdm_tables.sql", "ETLSyntheaBuilder", dbms = connectionDetails$dbms, vocab_schema = vocabDatabaseSchema)
  writeLines("Running restore_cdm_tables.sql")
	conn <- DatabaseConnector::connect(connectionDetails)
  DatabaseConnector::dbExecute(conn, sql, progressBar = TRUE, reportOverallTime = TRUE)
  on.exit(DatabaseConnector::disconnect(conn))
}

