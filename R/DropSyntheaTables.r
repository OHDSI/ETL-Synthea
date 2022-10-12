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


DropSyntheaTables <- function (connectionDetails, syntheaSchema)
{

	syntheaTables <- c(
		"ALLERGIES","CAREPLANS","CONDITIONS","DEVICES","ENCOUNTERS","IMAGING_STUDIES","IMMUNIZATIONS",
		"MEDICATIONS","OBSERVATIONS","ORGANIZATIONS","PATIENTS","PROCEDURES","PROVIDERS")

	conn <- DatabaseConnector::connect(connectionDetails)
	allTables <- DatabaseConnector::getTableNames(conn,syntheaSchema)
	writeLines("Dropping Synthea tables...")
	tablesToDrop <- allTables[which(allTables %in% syntheaTables)]
	sql <- paste("drop table @synthea_schema.",tablesToDrop,";",collapse = "\n", sep = "")
	sql <- SqlRender::render(sql, synthea_schema = syntheaSchema)
	sql <- SqlRender::translate(sql, targetDialect = connectionDetails$dbms)
	DatabaseConnector::executeSql(conn, sql)
	on.exit(DatabaseConnector::disconnect(conn))
}
