#' @title Truncate Non-Vocabulary CDM Tables.
#'
#' @description This function truncates CDM tables, excluding Vocabulary tables.
#'
#' @usage TruncateCDMTables(connectionDetails,cdmSchema,cdmVersion)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the database schema that contains the OMOP CDM
#'                   instance.  Requires read and write permissions to this database. On SQL
#'                   Server, this should specifiy both the database and the schema,
#'                   so for example 'cdm_instance.dbo'.
#' @param cdmVersion The version of your CDM.  Currently "5.3.1" and "6.0.0" are supported.
#'
#'@export


TruncateEventTables <- function (connectionDetails, cdmSchema, cdmVersion)
{
	if (cdmVersion == "5.3.1")
		sqlFilePath <- "cdm_version/v531"
	else if (cdmVersion == "6.0.0")
		sqlFilePath <- "cdm_version/v600"
	else
		stop("Unsupported CDM specified. Supported CDM versions are \"5.3.1\" and \"6.0.0\"")

	if (connectionDetails$dbms == "postgresql")	{
	
		conn <- DatabaseConnector::connect(connectionDetails)
		allTables <- DatabaseConnector::getTableNames(conn,cdmSchema)
		eventTables <- c(
			"CARE_SITE","CDM_SOURCE","COHORT","COHORT_ATTRIBUTE","CONDITION_ERA","CONDITION_OCCURRENCE","COST","DEATH","DEVICE_EXPOSURE",
			"DOSE_ERA","DRUG_ERA","DRUG_EXPOSURE","FACT_RELATIONSHIP","LOCATION","MEASUREMENT","METADATA","NOTE","NOTE_NLP","OBSERVATION",
			"OBSERVATION_PERIOD","PAYER_PLAN_PERIOD","PERSON","PROCEDURE_OCCURRENCE","PROVIDER","SPECIMEN","VISIT_DETAIL","VISIT_OCCURRENCE")
		tablesToTruncate <- allTables[which(allTables %in% eventTables)]
		sql <- paste0("truncate table @cdm_schema.",tablesToTruncate,";")
		sql <- SqlRender::render(sql, cdm_schema = cdmSchema)
		sql <- SqlRender::translate(sql, targetDialect = connectionDetails$dbms)
		DatabaseConnector::executeSql(conn, sql)
		on.exit(DatabaseConnector::disconnect(conn))
		
	} else {
	
		sqlFilename <- paste0(sqlFilePath,"/truncate_event_tables.sql")
	
		sql <- SqlRender::loadRenderTranslateSql(
			sqlFilename = sqlFilename, 
			packageName = "ETLSyntheaBuilder", 
			dbms        = connectionDetails$dbms, 
			cdm_schema  = cdmSchema
			)
			
		conn <- DatabaseConnector::connect(connectionDetails)
		DatabaseConnector::executeSql(conn, sql)
		on.exit(DatabaseConnector::disconnect(conn))
	}
}
