#' @title Drop Synthea Tables.
#'
#' @description This function drops all Synthea tables.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#'
#' @param syntheaSchema  The name of the database schema that contains the Synthea
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'synthea_instance.dbo'.
#'
#'@export


DropSyntheaTables <- function(connectionDetails, syntheaSchema)
{
  syntheaTables <- c(
    "ALLERGIES",
    "CAREPLANS",
	"CLAIMS",
	"CLAIMS_TRANSACTIONS",
    "CONDITIONS",
    "DEVICES",
    "ENCOUNTERS",
    "IMAGING_STUDIES",
    "IMMUNIZATIONS",
    "MEDICATIONS",
    "OBSERVATIONS",
    "ORGANIZATIONS",
    "PATIENTS",
	"PAYERS",
	"PAYER_TRANSITIONS",
    "PROCEDURES",
    "PROVIDERS",
	"SUPPLIES"
  )

  conn <- DatabaseConnector::connect(connectionDetails)
  allTables <- DatabaseConnector::getTableNames(conn, syntheaSchema)
  tablesToDrop <- allTables[which(allTables %in% syntheaTables)]
  
  if (length(tablesToDrop) > 0) {
      writeLines("Dropping Synthea tables...")
	  sql <-
		paste(
		  "drop table @synthea_schema.",
		  tablesToDrop,
		  ";",
		  collapse = "\n",
		  sep = ""
		)
	  sql <- SqlRender::render(sql, synthea_schema = syntheaSchema)
	  sql <- SqlRender::translate(sql, targetDialect = connectionDetails$dbms)
	  DatabaseConnector::executeSql(conn, sql)
  } else {
	print(sprintf("No synthea tables to drop in schema %s",syntheaSchema))
  }
  
  on.exit(DatabaseConnector::disconnect(conn))
}
