#' @title Load Vocabulary Tables.
#'
#' @description This function populates all Vocabulary tables. 
#'
#' @usage LoadVocabTables(connectionDetails, cdmDatabaseSchema, vocabFileLoc)
#'
#' @details This function assumes \cr\code{createCDMTables()} has already been run.  
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmDatabaseSchema  The name of the database schema that will contain the Vocabulary 
#'                                     tables.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param vocabFileLoc     The location of the vocabulary csv files.
#'
#'@export


LoadVocabTables <- function (connectionDetails, cdmDatabaseSchema, vocabFileLoc)
{

    csvList <- c("concept.csv","vocabulary.csv","concept_ancestor.csv","concept_relationship.csv","relationship.csv","concept_synonym.csv","domain.csv","concept_class.csv")
	
	conn <- DatabaseConnector::connect(connectionDetails) 
	
    for (csv in csvList) {
	
	    vocabTable <- data.table::fread(file = paste0(vocabFileLoc, "/", csv), stringsAsFactors = FALSE, header = TRUE, sep = "\t")    

	    # Format Dates for tables that need it
        if (base::identical(csv,"concept.csv") || base::identical(csv,"concept_relationship.csv")) {
       
	        vocabTable$valid_start_date <- as.Date(as.character(vocabTable$valid_start_date),"%Y%m%d")
            vocabTable$valid_end_date   <- as.Date(as.character(vocabTable$valid_end_date),"%Y%m%d")
        }
	
			
        writeLines(paste0("Loading: ",csv))

	    DatabaseConnector::insertTable(conn,paste0(cdmDatabaseSchema,".",strsplit(csv,"[.]")[[1]][1]), data=as.data.frame(vocabTable), dropTableIfExists = FALSE, createTable = FALSE, progressBar = TRUE)
	}
	
    on.exit(DatabaseConnector::disconnect(conn)) 
	
}
