#' @title Create Vocabulary Mapping Tables.
#'
#' @description This function creates source to source and source to standard vocab mapping tables.
#'
#' @details This function assumes \cr\code{createCDMTables()} has already been run and the Vocabulary tables have been loaded.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the database schema that will contain the Vocab mapping
#'                                     tables.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param cdmVersion The version of your CDM.  Currently "5.3" and "5.4" are supported.
#' @param sqlOnly A boolean that determines whether or not to perform the load or generate SQL scripts. Default is FALSE.
#'
#'@export


CreateVocabMapTables <- function (connectionDetails, cdmSchema, cdmVersion, sqlOnly = FALSE)
{

	if (cdmVersion == "5.3")
		sqlFilePath <- "cdm_version/v531"
	else if (cdmVersion == "5.4")
		sqlFilePath <- "cdm_version/v540"
	else
		stop("Unsupported CDM specified. Supported CDM versions are \"5.3\" and \"5.4\"")

    queries <- c("create_source_to_standard_vocab_map.sql", "create_source_to_source_vocab_map.sql")

	if (!sqlOnly) {
		conn <- DatabaseConnector::connect(connectionDetails)
	}

	for (query in queries) {

		translatedSql <- SqlRender::loadRenderTranslateSql(
			sqlFilename    = paste0(sqlFilePath,"/",query),
			packageName    = "ETLSyntheaBuilder",
			dbms           = connectionDetails$dbms,
			cdm_schema     = cdmSchema)

		if (sqlOnly) {
			if (!dir.exists("output"))
				dir.create("output")

			writeLines(paste0("Saving to output/", query))
			SqlRender::writeSql(translatedSql,paste0("output/",query))

        } else {
			writeLines(paste0("Running: ",query))
			DatabaseConnector::executeSql(conn, translatedSql)
		}
    }
	if (!sqlOnly) {
		DatabaseConnector::disconnect(conn)
	}
}
