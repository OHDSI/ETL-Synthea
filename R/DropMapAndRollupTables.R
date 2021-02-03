#' @title Drop Vocabulary Mapping And Visit Rollup Tables.
#'
#' @description This function cleans up the tables created by the \cr\code{CreateVocabMapTables()} and \cr\code{CreateVisitRollupTables()}
#'
#' @usage DropMapAndRollupTables (connectionDetails, cdmSchema, cdmVersion)
#'
#' @details This function assumes \cr\code{CreateVocabMapTables()} and \cr\code{CreateVisitRollupTables()} have already been run.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the database schema that will contain the Vocab mapping
#'                                     tables.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param cdmVersion The version of your CDM.  Currently "5.3.1" and "6.0.0" are supported.
#'
#'@export
DropMapAndRollupTables <- function (connectionDetails, cdmSchema, cdmVersion) {

	queries <- c("drop_map_and_rollup_tables.sql")
	
	if (cdmVersion == "5.3.1")
		sqlFilePath <- "cdm_version/v531"
	else if (cdmVersion == "6.0.0")
		sqlFilePath <- "cdm_version/v600"
	else
		stop("Unsupported CDM specified. Supported CDM versions are \"5.3.1\" and \"6.0.0\"")

	conn <- DatabaseConnector::connect(connectionDetails)

	for (query in queries) {

		translatedSql <- SqlRender::loadRenderTranslateSql(
			sqlFilename = paste0(sqlFilePath,"/",query),
			packageName = "ETLSyntheaBuilder",
			dbms        = connectionDetails$dbms,
			cdm_schema  = cdmSchema
		)

		writeLines(paste0("Running: ",query))

		DatabaseConnector::executeSql(conn, translatedSql)

	}

	on.exit(DatabaseConnector::disconnect(conn))

}

