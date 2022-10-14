#' @title Prune a CDM.
#'
#' @description This function is simply a convenience wrapper for the other calls. (Eunomia support)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the database schema that contains the CDM.
#'                   Requires read and write permissions to this database. On SQL
#'                   Server, this should specifiy both the database and the schema,
#'                   so for example 'cdm_instance.dbo'.
#' @param cdmVersion The version of your CDM.  Currently "5.3.1" and "6.0.0".
#'
#'@export


pruneCDM <- function (connectionDetails, cdmSchema, cdmVersion) {

    writeLines("Getting event data...")
    eventData <- getEventConceptId(connectionDetails,cdmSchema,cdmVersion)
    eventConceptId <- eventData$CONCEPT_ID

    writeLines("Backing up cdm...")
    backupCDM(connectionDetails,cdmSchema,cdmVersion)

	writeLines("Pruning cdm...")
    createPrunedTables(connectionDetails,cdmSchema,eventConceptId)
}

