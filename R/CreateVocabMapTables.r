#' @title Create Vocabulary Mapping Tables.
#'
#' @description This function creates source to source and source to standard vocab mapping tables.
#'
#' @usage CreateVocabMapTables (connectionDetails, cdmSchema, cdmVersion)
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
#' @param cdmVersion The version of your CDM.  Currently "5.3.1" and "6.0.0" are supported.
#'
#'@export


CreateVocabMapTables <- function (connectionDetails, cdmSchema, cdmVersion)
{

	if (cdmVersion == "5.3.1")
		sqlFilePath <- "cdm_version/v531"
	else if (cdmVersion == "6.0.0")
		sqlFilePath <- "cdm_version/v600"
	else
		stop("Unsupported CDM specified. Supported CDM versions are \"5.3.1\" and \"6.0.0\"")

    queries <- c("create_source_to_standard_vocab_map.sql", "create_source_to_source_vocab_map.sql")
    
	conn <- DatabaseConnector::connect(connectionDetails) 
	
	for (query in queries) {
	
		translatedSql <- SqlRender::loadRenderTranslateSql(
			sqlFilename    = paste0(sqlFilePath,"/",query),
			packageName    = "ETLSyntheaBuilder",
			dbms           = connectionDetails$dbms,
			cdm_schema     = cdmSchema
		)

        writeLines(paste0("Running: ",query))
	
        DatabaseConnector::executeSql(conn, translatedSql)

    }
	
    on.exit(DatabaseConnector::disconnect(conn)) 
	
}