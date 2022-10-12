#' @title Truncate Event Tables.
#'
#' @description This function truncates CDM tables, excluding Vocabulary tables.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the database schema that contains the OMOP CDM
#'                   instance.  Requires read and write permissions to this database. On SQL
#'                   Server, this should specifiy both the database and the schema,
#'                   so for example 'cdm_instance.dbo'.
#'
#'@export


TruncateEventTables <- function (connectionDetails, cdmSchema)
{

	eventTables <- c(
		"CARE_SITE","CDM_SOURCE","COHORT","COHORT_ATTRIBUTE","CONDITION_ERA","CONDITION_OCCURRENCE","COST","DEATH","DEVICE_EXPOSURE",
		"DOSE_ERA","DRUG_ERA","DRUG_EXPOSURE","FACT_RELATIONSHIP","LOCATION","MEASUREMENT","METADATA","NOTE","NOTE_NLP","OBSERVATION",
		"OBSERVATION_PERIOD","PAYER_PLAN_PERIOD","PERSON","PROCEDURE_OCCURRENCE","PROVIDER","SPECIMEN","VISIT_DETAIL","VISIT_OCCURRENCE")

	conn <- DatabaseConnector::connect(connectionDetails)
	allTables <- DatabaseConnector::getTableNames(conn,cdmSchema)
	tablesToTruncate <- allTables[which(allTables %in% eventTables)]
	sql <- paste("truncate table @cdm_schema.",tablesToTruncate,";",collapse = "\n", sep = "")
	sql <- SqlRender::render(sql, cdm_schema = cdmSchema)
	sql <- SqlRender::translate(sql, targetDialect = connectionDetails$dbms)
	DatabaseConnector::executeSql(conn, sql)
	on.exit(DatabaseConnector::disconnect(conn))
}
