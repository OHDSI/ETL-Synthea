#' @title Load Vocabulary Tables From a Preexisting Schema.
#'
#' @description This function populates all Vocabulary tables with data from Vocabulary tables in a specified schema.
#'
#' @usage LoadVocabFromSchema(connectionDetails, fromCdmSchema, toCdmSchema)
#'
#' @details This function assumes \cr\code{createCDMTables()} has already been run and \cr\code{fromCdmSchema} has all required Vocabulary tables.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param vocabSourceSchema  The name of the database schema that already contains the Vocabulary
#'                                     tables to copy.  Requires read permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param vocabTargetSchema  The name of the database schema into which to copy the Vocabulary
#'                                     tables.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#'
#'@export

LoadVocabFromSchema <- function (connectionDetails, vocabSourceSchema, vocabTargetSchema)
{

	#vocabTableList <- c("concept","vocabulary","concept_ancestor","concept_relationship","relationship","concept_synonym","domain","concept_class")
	vocabTableList <- c("concept", "concept_ancestor", "concept_class", "concept_relationship", "concept_synonym", "domain",  "drug_strength", "relationship", "source_to_concept_map", "vocabulary")

	conn <- DatabaseConnector::connect(connectionDetails)

  for (tableName in vocabTableList) {
	  sql <- paste0("create table ",vocabTargetSchema,".",tableName," WITH (DISTRIBUTION = REPLICATE) as select * from ",vocabSourceSchema,".",tableName)
    writeLines(paste0("Copying: ",tableName))
    DatabaseConnector::executeSql(conn, sql, profile = FALSE, progressBar = TRUE, reportOverallTime = TRUE)
	}
    on.exit(DatabaseConnector::disconnect(conn))
}
