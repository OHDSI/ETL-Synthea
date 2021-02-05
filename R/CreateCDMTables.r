#' @title Create Common Data Model Tables.
#'
#' @description This function creates the all the required tables for the CDM.
#'
#' @usage CreateCDMTables(connectionDetails,cdmSchema,cdmVersion)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the CDM database schema.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param cdmVersion Your CDM version.  Currently "5.3.1" and "6.0.0" are supported.
#'
#' @details This function creates all the tables in a CDM by referring to the
#'          correct SQL DDL script in the OHDSI CommonDataModel repo. The database platform is 
#'          determined by \code{connectionDetails$dbms}.  Currently "oracle", "postgresql", "pdw", 
#'          "impala", "netezza", "bigquery", and "redshift" are supported.
#' 
#'@export


CreateCDMTables <- function (connectionDetails,cdmSchema,cdmVersion)
{

	supportedDbs <- c("oracle", "postgresql", "pdw", "impala", "netezza", "bigquery", "redshift")
	supportedVersions <- c("5.3.1","6.0.0")
	rdbms <- tolower(connectionDetails$dbms)
	
	if (!(cdmVersion %in% supportedVersions)) {
		stop("Unsupported CDM specified. Supported CDM versions are \"5.3.1\" and \"6.0.0\"")
	}
	
	if (!(rdbms %in% supportedDbs)) {
		stop("Unsupported RDBMS specified. Supported rdbms are: 
			\"oracle\", \"postgresql\", \"pdw\", \"impala\", \"netezza\",\"bigquery\", and \"redshift\"")
	}

	# Determine which DDL script to use (from https://github.com/OHDSI/CommonDataModel)
	# based on the given db platform and cdm version.
	
	if (rdbms == "oracle") {
		if (cdmVersion == "5.3.1") {
			webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Oracle/OMOP%20CDM%20oracle%20ddl.txt")
		} else if (cdmVersion == "6.0.0") {
			webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Oracle/OMOP%20CDM%20oracle%20ddl.txt")
		}
	} else if (rdbms == "postgresql") {
		if (cdmVersion == "5.3.1") {
			webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/PostgreSQL/OMOP%20CDM%20postgresql%20ddl.txt")
		} else if (cdmVersion == "6.0.0") {
			webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/PostgreSQL/OMOP%20CDM%20postgresql%20ddl.txt")
		}
	} else if (rdbms == "pdw") {
		if (cdmVersion == "5.3.1") {
			webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/ParallelDataWarehouse/OMOP%20CDM%20pdw%20ddl.txt")
		} else if (cdmVersion == "6.0.0") {
			webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/ParallelDataWarehouse/OMOP%20CDM%20pdw%20ddl.txt")
		}
	} else if (rdbms == "impala") {
		if (cdmVersion == "5.3.1") {
			webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Impala/OMOP%20CDM%20impala%20ddl.txt")
		} else if (cdmVersion == "6.0.0") {
			webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Impala/OMOP%20CDM%20impala%20ddl.txt")
		}
	} else if (rdbms == "netezza") {
		if (cdmVersion == "5.3.1") {
			webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Netezza/OMOP%20CDM%20netezza%20ddl.txt")
		} else if (cdmVersion == "6.0.0") {
			webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Netezza/OMOP%20CDM%20netezza%20ddl.txt")
		}
	} else if (rdbms == "bigquery") {
		if (cdmVersion == "5.3.1") {
			webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/BigQuery/OMOP%20CDM%20bigquery%20ddl.txt")
		} else if (cdmVersion == "6.0.0") {
			webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/BigQuery/OMOP%20CDM%20bigquery%20ddl.txt")
		}
		
	} else if (rdbms == "redshift") {
		if (cdmVersion == "5.3.1") {
			webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Redshift/OMOP%20CDM%20redshift%20ddl.txt")
		} else if (cdmVersion == "6.0.0") {
			webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Redshift/OMOP%20CDM%20redshift%20ddl.txt")
		}
	}
	
	# Read the SQL DDL from the correct github repo and apply some string formatting to enable
	# use of parameterized sql to write to the correct schema.
	
	tableDDL <- httr::content(webResponse)
	tableDDL <- toupper(tableDDL)	
	tableDDL <- gsub("CREATE TABLE  \n", "CREATE TABLE ", tableDDL)
	tableDDL <- gsub("CREATE TABLE ", "CREATE TABLE @CDM_SCHEMA.", tableDDL)
	tableDDL <- gsub("CREATE TABLE @CDM_SCHEMA. ", "CREATE TABLE @CDM_SCHEMA.", tableDDL)
	tableDDL <- gsub("INSERT INTO ", "INSERT INTO @CDM_SCHEMA.", tableDDL)
	
	tableDDL <- SqlRender::render(sql = tableDDL, CDM_SCHEMA = cdmSchema)
	tableDDL <- SqlRender::translate(sql = tableDDL, targetDialect = rdbms)
			
	# Save the translated sql ddl for review purposes.
	if (!dir.exists("output")) {
		dir.create("output")
	}
	
    writeLines(paste0("Executing DDL from: ",webResponse$url))
    writeLines(paste0("Saving DDL in: output/",rdbms,"_",cdmVersion,"_ddl.sql"))
	SqlRender::writeSql(tableDDL,paste0("output/",rdbms,"_",cdmVersion,"_ddl.sql"))

	conn <- DatabaseConnector::connect(connectionDetails)

    DatabaseConnector::executeSql(conn, tableDDL)

    on.exit(DatabaseConnector::disconnect(conn))

}
