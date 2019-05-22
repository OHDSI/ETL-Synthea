#' @title Truncate Non-Vocabulary CDM Tables.
#'
#' @description This function truncates CDM tables, excluding Vocabulary tables. 
#'
#' @usage TruncateCDMTables(connectionDetails,cdmDatabaseSchema)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmDatabaseSchema  The name of the database schema that contains the OMOP CDM
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#'
#'@export


TruncateEventTables <- function (connectionDetails, cdmDatabaseSchema)
{

    eventTables <- c( 'care_site', 'cdm_source', 'cohort', 'cohort_attribute', 'condition_era', 'condition_occurrence', 'cost',
                      'death', 'device_exposure', 'dose_era', 'drug_era', 'drug_exposure', 'fact_relationship', 'location',
                      'measurement', 'metadata', 'note', 'note_nlp', 'observation', 'observation_period', 'payer_plan_period',
                      'person', 'procedure_occurrence', 'provider', 'specimen', 'visit_detail', 'visit_occurrence' )

    conn <- DatabaseConnector::connect(connectionDetails) 

    writeLines("Truncating event tables...")
	
    for (tableName in eventTables) {
	  if (DatabaseConnector::dbExistsTable(conn = conn, name = tableName, schema = cdmDatabaseSchema)) { 
	    writeLines(paste0("Truncating ",tableName))
        DatabaseConnector::dbExecute(conn, paste0("truncate table ",cdmDatabaseSchema,".",tableName,";"))
      }
	}
	
    on.exit(DatabaseConnector::disconnect(conn)) 
	
}