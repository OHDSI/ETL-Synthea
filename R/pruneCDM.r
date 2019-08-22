#' @title Prune a CDM.
#'
#' @description This function is simply a convenience wrapper for the other calls.
#'
#' @usage pruneCDM(connectionDetails,cdmDatabaseSchema,vocabDatabaseSchema,pathToSql = NULL)
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
#' @param pathToSql           Optional location of the sql files (defaults to inst/sql/sql_server)
#'
#'@export


pruneCDM <- function (connectionDetails, cdmDatabaseSchema, vocabDatabaseSchema) {
    writeLines("Getting event data...")
    eventData <- getEventConceptId(connectionDetails,cdmDatabaseSchema)
    eventConceptId <- eventData$CONCEPT_ID

    writeLines("Backing up cdm...")
    backupCDM(connectionDetails,cdmDatabaseSchema,vocabDatabaseSchema)

	  writeLines("Pruning cdm...")
    createPrunedTables(connectionDetails,cdmDatabaseSchema,vocabDatabaseSchema,eventConceptId)
}

