#' @title Create Index and Constraint DDL SQL scripts for CDM tables on rdbms that support these features.
#'
#' @description This function creates one or more SQL scripts as defined in https://github.com/OHDSI/CommonDataModel.
#'
#' @usage CreateCDMIndexAndConstraintScripts(connectionDetails,cdmSchema,cdmVersion)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the CDM database schema.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param cdmVersion Your CDM version.  Currently "5.3.1" and "6.0.0" are supported.
#'
#' @details This function creates SQL scripts for the indices and constraints on tables in a CDM by referring to the
#'          correct SQL DDL script in the OHDSI CommonDataModel repo. The database platform is 
#'          determined by \code{connectionDetails$dbms}.  Currently "oracle", "postgresql", "pdw", and "netezza" are supported.
#'          The SQL DDL scripts are written to the \code{output} directory.  The SQL scripts can then be run manually in a SQL session
#'          or by using \code{DatabaseConnector::executeSql(connection,DDLscriptName)}
#' 
#'@export


CreateCDMIndexAndConstraintScripts <- function (connectionDetails,cdmSchema,cdmVersion)
{

	supportedDbs <- c("oracle", "postgresql", "pdw", "netezza")
	supportedVersions <- c("5.3.1","6.0.0")
	rdbms <- tolower(connectionDetails$dbms)
	
	if (!(cdmVersion %in% supportedVersions)) {
		stop("Unsupported CDM specified. Supported CDM versions are \"5.3.1\" and \"6.0.0\"")
	}
	
	if (!(rdbms %in% supportedDbs)) {
		stop("Unsupported RDBMS specified. Supported rdbms are: \"oracle\", \"postgresql\", \"pdw\", \"netezza\"")
	}

	# Determine which DDL script to use (from https://github.com/OHDSI/CommonDataModel)
	# based on the given db platform and cdm version.
	
	if (rdbms == "oracle") {
		if (cdmVersion == "5.3.1") {
			webResponseInd <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Oracle/OMOP%20CDM%20oracle%20indexes.txt")
			webResponseCon <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Oracle/OMOP%20CDM%20oracle%20constraints.txt")
		} else if (cdmVersion == "6.0.0") {
			webResponseInd <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Oracle/OMOP%20CDM%20oracle%20indexes.txt")
			webResponseCon <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Oracle/OMOP%20CDM%20oracle%20constraints.txt")
		}
	} else if (rdbms == "postgresql") {
		if (cdmVersion == "5.3.1") {
			webResponseInd <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/PostgreSQL/OMOP%20CDM%20postgresql%20indexes.txt")
			webResponseCon <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/PostgreSQL/OMOP%20CDM%20postgresql%20constraints.txt")
		} else if (cdmVersion == "6.0.0") {
			webResponseInd <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/PostgreSQL/OMOP%20CDM%20postgresql%20indexes.txt")
			webResponseCon <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/PostgreSQL/OMOP%20CDM%20postgresql%20constraints.txt")
		}
	} else if (rdbms == "pdw") {
		if (cdmVersion == "5.3.1") {
			webResponseInd <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/ParallelDataWarehouse/OMOP%20CDM%20pdw%20indexes.txt")
			webResponseCon <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/ParallelDataWarehouse/OMOP%20CDM%20pdw%20constraints.txt")
		} else if (cdmVersion == "6.0.0") {
			webResponseInd <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/ParallelDataWarehouse/OMOP%20CDM%20pdw%20indexes.txt")
			webResponseCon <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/ParallelDataWarehouse/OMOP%20CDM%20pdw%20constraints.txt")
		}
	} else if (rdbms == "netezza") {
		if (cdmVersion == "5.3.1") {
			webResponseCon <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Netezza/OMOP%20CDM%20netezza%20primary%20keys.txt")
		} else if (cdmVersion == "6.0.0") {
			webResponseCon <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Netezza/OMOP%20CDM%20netezza%20primary%20keys.txt")
		}
	}
	
	# Read the SQL DDL from the correct github repo and apply some string formatting to enable
	# use of parameterized sql to write to the correct schema.
	
	indexDDL      <- httr::content(webResponseInd)
	constraintDDL <- httr::content(webResponseCon)
	indexDDL      <- toupper(indexDDL)
	constraintDDL <- toupper(constraintDDL)

	indexDDL <- gsub(" ON ", " ON @CDM_SCHEMA.",indexDDL)
	indexDDL <- gsub("ALTER TABLE", "ALTER TABLE @CDM_SCHEMA.",indexDDL)
	indexDDL <- gsub("@CDM_SCHEMA. ","@CDM_SCHEMA.",indexDDL)
	indexDDL <- SqlRender::render(indexDDL, CDM_SCHEMA = cdmSchema)
	indexDDL <- SqlRender::translate(indexDDL, targetDialect = rdbms)

	constraintDDL <- gsub("ALTER TABLE", "ALTER TABLE @CDM_SCHEMA.",constraintDDL)
	constraintDDL <- gsub("@CDM_SCHEMA. ","@CDM_SCHEMA.",constraintDDL)
	constraintDDL <- SqlRender::render(constraintDDL, CDM_SCHEMA = cdmSchema)
	constraintDDL <- SqlRender::translate(constraintDDL, targetDialect = rdbms)

	# Save the translated sql ddl to be run at a later time
	if (!dir.exists("output")) {
		dir.create("output")
	}
	
	# Constraint DDL
	writeLines(paste0("Pulling constraint DDL from: ",webResponseCon$url))
	writeLines(paste0("Saving constraint DDL in: output/",rdbms,"_",cdmVersion,"_constraint_ddl.sql"))
	SqlRender::writeSql(constraintDDL,paste0("output/",rdbms,"_",cdmVersion,"_constraint_ddl.sql"))
	
	# Index DDL
	# Netezza only has a PK script file
	if (rdbms != "netezza") {
		writeLines(paste0("Pulling index DDL from: ",webResponseInd$url))
		writeLines(paste0("Saving index DDL in: output/",rdbms,"_",cdmVersion,"_index_ddl.sql"))
		SqlRender::writeSql(indexDDL,paste0("output/",rdbms,"_",cdmVersion,"_index_ddl.sql"))
	}
}
