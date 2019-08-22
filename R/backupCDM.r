#' @title Backup Vocabulary and Event tables before pruning.
#'
#' @description This function performs a "back up" of the original tables by renaming them.
#'
#' @usage backupCDM(connectionDetails,cdmDatabaseSchema,vocabDatabaseSchema)
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
#'@export


backupCDM <- function (connectionDetails, cdmDatabaseSchema, vocabDatabaseSchema)
{
    sql <- SqlRender::loadRenderTranslateSql("backup_cdm.sql", "ETLSyntheaBuilder", dbms = connectionDetails$dbms, vocab_schema = vocabDatabaseSchema)
		conn <- DatabaseConnector::connect(connectionDetails)
    DatabaseConnector::dbExecute(conn, sql, progressBar = TRUE, reportOverallTime = TRUE)
    on.exit(DatabaseConnector::disconnect(conn))
}

