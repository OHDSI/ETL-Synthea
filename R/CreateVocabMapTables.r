#' @title Create Vocabulary Mapping Tables.
#'
#' @description This function creates source to source and source to standard vocab mapping tables.
#'
#' @usage CreateVocabMapTables (connectionDetails, cdmDatabaseSchema)
#'
#' @details This function assumes \cr\code{createCDMTables()} and \cr\code{LoadVocabTables()} has already been run.  
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmDatabaseSchema  The name of the database schema that will contain the Vocab mapping 
#'                                     tables.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#'
#'@export


CreateVocabMapTables <- function (connectionDetails, cdmDatabaseSchema)
{

    queries <- c("create_source_to_standard_vocab_map.sql", "create_source_to_source_vocab_map.sql")
    
	conn <- DatabaseConnector::connect(connectionDetails) 
	
	for (query in queries) {
	
        pathToSql <- base::system.file("sql/sql_server", package = "ETLSyntheaBuilder")

        sqlFile <- base::paste0(pathToSql, "/", query)

        sqlQuery <- base::readChar(sqlFile, base::file.info(sqlFile)$size)

        renderedSql <- SqlRender::render(sqlQuery, cdm_schema = cdmDatabaseSchema)

        translatedSql <- SqlRender::translate(renderedSql, targetDialect = connectionDetails$dbms)

        writeLines(paste0("Running: ",query))
	
        DatabaseConnector::executeSql(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE)

    }
	
    on.exit(DatabaseConnector::disconnect(conn)) 
	
}