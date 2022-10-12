#' @title Restore the CDM (undo the pruning).
#'
#' @description This function undoes the pruning by renaming (the *_orig tables are given their names back).
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the database schema that contains the CDM
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param cdmVersion The version of your CDM.  Currently "5.3.1" and "6.0.0" are supported.
#'@export


restoreCDMTables <- function (connectionDetails, cdmSchema, cdmVersion)
{

	if (cdmVersion == "5.3.1")
		sqlFilePath <- "cdm_version/v531"
	else if (cdmVersion == "6.0.0")
		sqlFilePath <- "cdm_version/v600"
	else
		stop("Unsupported CDM specified. Supported CDM versions are \"5.3.1\" and \"6.0.0\"")

	sql <- SqlRender::loadRenderTranslateSql(
			sqlFileName = paste0(sqlFilePath,"/restore_cdm_tables.sql"),
			packageName = "ETLSyntheaBuilder",
			dbms        = connectionDetails$dbms,
			cdm_schema  = cdmSchema
			)
	writeLines("Running restore_cdm_tables.sql")
	conn <- DatabaseConnector::connect(connectionDetails)
	DatabaseConnector::executeSql(conn, sql)
	on.exit(DatabaseConnector::disconnect(conn))
}

