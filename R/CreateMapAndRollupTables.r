#' @title Create Vocab Mapping and Visit Rollup Tables.
#'
#' @description This function creates the vocabulary mapping and visit roll-up intermediate tables from created
#'  by the \cr\code{CreateVocabMapTables()} and \cr\code{CreateVisitRollupTables()} scripts.
#'
#' @details This function assumes \cr\code{createCDMTables()}, \cr\code{createSyntheaTables()}, \cr\code{LoadSyntheaTables()},
#'              and \cr\code{LoadVocabTables()} have all been run.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the database schema that will contain the CDM.
#'                                     Requires read and write permissions to this database. On SQL
#'                                     Server, this should specify both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param syntheaSchema  The name of the database schema that contain the Synthea
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specify both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param cdmVersion The version of your CDM.  Currently "5.3" and "5.4".
#' @param syntheaVersion The version of Synthea used to generate the csv files.
#'                       Currently "2.7.0", "3.0.0", "3.1.0", "3.2.0" and "3.3.0" are supported.
#' @param cdmSourceName	The source name to insert into the CDM_SOURCE table.  Default is Synthea synthetic health database.
#' @param cdmSourceAbbreviation The source abbreviation to insert into the CDM_SOURCE table.  Default is Synthea.
#' @param cdmHolder The holder to insert into the CDM_SOURCE table.  Default is OHDSI
#' @param cdmSourceDescription The description of the source data.  Default is generic Synthea description.
#' @param sqlOnly A boolean that determines whether or not to perform the load or generate SQL scripts. Default is FALSE.
#'
#'@export


CreateMapAndRollupTables <- function(connectionDetails,
                                     cdmSchema,
                                     syntheaSchema,
                                     cdmVersion,
                                     syntheaVersion = "2.7.0",
                                     cdmSourceName = "Synthea synthetic health database",
                                     cdmSourceAbbreviation = "Synthea",
                                     cdmHolder = "OHDSI",
                                     cdmSourceDescription = "SyntheaTM is a Synthetic Patient Population Simulator. The goal is to output synthetic, realistic (but not real), patient data and associated health records in a variety of formats.",
                                     sqlOnly = FALSE)
{
  supportedCDMVersions <- c("5.3", "5.4")

  if (!(cdmVersion %in% supportedCDMVersions)) {
    stop("Unsupported CDM specified. Supported CDM versions are \"5.3\" and \"5.4\".")
  }

  supportedSyntheaVersions <- c("2.7.0", "3.0.0", "3.1.0", "3.2.0", "3.3.0")

  if (!(syntheaVersion %in% supportedSyntheaVersions))
    stop(
      "Invalid Synthea version specified. Currently \"2.7.0\", \"3.0.0\",\"3.1.0\", \"3.2.0\", and \"3.3.0\" are supported."
    )

  # Create Vocabulary mapping tables
  CreateVocabMapTables(connectionDetails, cdmSchema, cdmVersion, sqlOnly)

  # Perform visit rollup logic and create auxiliary tables
  CreateVisitRollupTables(connectionDetails,
                          cdmSchema,
                          syntheaSchema,
                          cdmVersion,
                          sqlOnly)

}
