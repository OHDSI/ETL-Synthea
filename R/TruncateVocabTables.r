#' @title Truncate Vocabulary Tables.
#'
#' @description This function truncates the Vocabulary tables. 
#'
#' @usage TruncateVocabTables(connectionDetails, cdmSchema)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the database schema that contains the Vocabulary (and CDM).
#'                   Requires read and write permissions to this database. On SQL
#'                   Server, this should specifiy both the database and the schema,
#'                   so for example 'cdm_instance.dbo'.
#'
#'@export


TruncateVocabTables <- function (connectionDetails, cdmSchema)
{

  vocabTables <- c( 'attribute_definition', 'cohort_definition', 'concept', 'concept_ancestor', 'concept_class', 'concept_relationship', 
                    'concept_synonym', 'domain', 'drug_strength', 'relationship', 'source_to_concept_map', 'vocabulary' )

  conn <- DatabaseConnector::connect(connectionDetails) 

  writeLines("Truncating vocabulary tables...")
	
    for (tableName in vocabTables) {
	  if (DatabaseConnector::dbExistsTable(conn = conn, name = tableName, schema = vocabDatabaseSchema)) { 
	    writeLines(paste0("Truncating ",tableName))
        DatabaseConnector::executeSql(conn, paste0("truncate table ",cdmSchema,".",tableName,";"))
      }
	}
	
    on.exit(DatabaseConnector::disconnect(conn)) 
	
}