#' @title Drop Vocabulary Tables.
#'
#' @description This function drops Vocabulary tables in a CDM.
#'
#' @usage DropVocabTables(connectionDetails, cdmSchema, cdmVersion)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the CDM schema that contains the Vocabulary.  
#'                   Requires read and write permissions to this database. On SQL
#'                   Server, this should specifiy both the database and the schema,
#'                   so for example 'cdm_instance.dbo'.
#' @param cdmVersion The version of your CDM.  Currently "5.3" and "6.0" are supported.
#'
#'@export


DropVocabTables <- function (connectionDetails, cdmSchema, cdmVersion)
{

	if (cdmVersion == "5.3")
		sqlFilePath <- "v53"
	else if (cdmVersion == "6.0")
		sqlFilePath <- "v60"
		
    translatedSql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = paste0(sqlFilePath,"/","drop_vocab_tables.sql"),
		packageName = "ETLSyntheaBuilder",
		dbms        = connectionDetails$dbms,
		cdm_schema  = cdmSchema
	)

    writeLines("Running drop_vocab_tables.sql")
	
	conn <- DatabaseConnector::connect(connectionDetails) 
	
    DatabaseConnector::dbExecute(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE)

    on.exit(DatabaseConnector::disconnect(conn)) 
	
}