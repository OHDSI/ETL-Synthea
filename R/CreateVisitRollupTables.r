#' @title Create Tables for Visit Rollup Logic.
#'
#' @description This function creates tables ALL_VISITS, ASSIGN_ALL_VISIT_IDS, and FINAL_VISIT_IDS.
#'
#' @usage CreateVisitRollupTables (connectionDetails, cdmSchema, syntheaSchema, cdmVersion)
#'
#' @details This function assumes \cr\code{createCDMTables()}, \cr\code{createSyntheaTables()}, \cr\code{LoadSyntheaTables()}, 
#'          have all been run and the Vocabulary has been loaded.  
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the database schema that will contain the different VISIT 
#'                                     tables.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param syntheaSchema  The name of the database schema that contain the Synthea
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'synthea_instance.dbo'.
#' @param cdmVersion The version of your CDM.  Currently "5.3" and "6.0" are supported.
#'
#'@export


CreateVisitRollupTables <- function (connectionDetails, cdmSchema, syntheaSchema, cdmVersion)
{

	if (cdmVersion == "5.3")
		sqlFilePath <- "v53"
	else if (cdmVersion == "6.0")
		sqlFilePath <- "v60"

    queries <- c("AllVisitTable.sql", "AAVITable.sql", "final_visit_ids.sql")
    
	conn <- DatabaseConnector::connect(connectionDetails) 
	
	for (query in queries) {
	
		translatedSql <- SqlRender::loadRenderTranslateSql(
			sqlFilename    = paste0(sqlFilePath,"/",query),
			packageName    = "ETLSyntheaBuilder",
			dbms           = connectionDetails$dbms,
			cdm_schema     = cdmSchema,
			synthea_schema = syntheaSchema
		)

        writeLines(paste0("Running: ",query))
	
        DatabaseConnector::executeSql(conn, translatedSql)

    }
	
    on.exit(DatabaseConnector::disconnect(conn)) 
	
}