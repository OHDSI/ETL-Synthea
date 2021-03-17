#' @title Create Common Data Model Tables.
#'
#' @description This function creates the all the required tables for the CDM.
#'
#' @usage CreateCDMTables(connectionDetails,cdmSchema,cdmVersion,githubTag)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the CDM database schema.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param cdmVersion Your CDM version.  Currently "5.3.1" and "6.0.0" are supported.
#' @param githubTag  An optional github tag from which to pull the DDL script. 
#'                   Currently "v5.3.1", "v5.3.1_fixes", "v6.0.0", and "v6.0.0_fixes" are supported.  The default is NULL.
#' @param sqlOnly A boolean that determines whether or not to perform the load or generate SQL scripts. Default is FALSE.
#'
#' @details This function creates all the tables in a CDM by referring to the
#'          correct SQL DDL script in the OHDSI CommonDataModel repo. The database platform is 
#'          determined by \code{connectionDetails$dbms}.  Currently "oracle", "postgresql", "pdw", 
#'          "impala", "netezza", "bigquery", "redshift", and "sql server" are supported.
#' 
#'@export


CreateCDMTables <- function (connectionDetails,cdmSchema,cdmVersion,githubTag = NULL,sqlOnly = FALSE)
{

	supportedDbs      <- c("oracle", "postgresql", "pdw", "impala", "netezza", "bigquery", "redshift", "sql server")
	supportedVersions <- c("5.3.1","6.0.0")
	supportedTags     <- c("v5.3.1","v6.0.0","v5.3.1_fixes","v6.0.0_fixes")
	rdbms <- tolower(connectionDetails$dbms)
	
	if (!(cdmVersion %in% supportedVersions)) {
		stop("Unsupported CDM specified. Supported CDM versions are \"5.3.1\" and \"6.0.0\"")
	}
	
	if (!(rdbms %in% supportedDbs)) {
		stop("Unsupported RDBMS specified. Supported rdbms are: 
			\"oracle\", \"postgresql\", \"pdw\", \"impala\", \"netezza\",\"bigquery\", \"redshift\", and \"sql server\"")
	}

	# Determine which DDL script to use (from https://github.com/OHDSI/CommonDataModel)
	# based on the given db platform, cdm version, and (optionally) github tag.
		
	if (!is.null(githubTag) && !(githubTag %in% supportedTags)) {
		stop("Unrecognized github tag.  Supported values are \"v5.3.1\", \"v6.0.0\", \"v5.3.1_fixes\", and \"v6.0.0_fixes\"")
	}
	
	if (cdmVersion == "5.3.1" && !is.null(githubTag) && !(githubTag %in% c("v5.3.1","v5.3.1_fixes"))) {
		stop("cdmVersion and githubTag mismatch.")
	}
	
	if (cdmVersion == "6.0.0" && !is.null(githubTag) && !(githubTag %in% c("v6.0.0","v6.0.0_fixes"))) {
		stop("cdmVersion and githubTag mismatch.")
	}
		
	if (rdbms == "oracle") {
		if (cdmVersion == "5.3.1") {
			if (is.null(githubTag) || githubTag == "v5.3.1") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Oracle/OMOP%20CDM%20oracle%20ddl.txt")
			} else if (githubTag == "v5.3.1_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/Oracle/OMOP%20CDM%20oracle%20v5_3_1%20ddl.sql")
			}
		} else if (cdmVersion == "6.0.0") {
			if (is.null(githubTag) || githubTag == "v6.0.0") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Oracle/OMOP%20CDM%20oracle%20ddl.txt")
			} else if (githubTag == "v6.0.0_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/Oracle/OMOP%20CDM%20oracle%20ddl.txt")
			}
		}
	} else if (rdbms == "postgresql") {
		if (cdmVersion == "5.3.1") {
			if (is.null(githubTag) || githubTag == "v5.3.1") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/PostgreSQL/OMOP%20CDM%20postgresql%20ddl.txt")
			} else if (githubTag == "v5.3.1_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/PostgreSQL/OMOP%20CDM%20postgresql%20v5_3_1%20ddl.sql")
			}
		} else if (cdmVersion == "6.0.0") {
			if (is.null(githubTag) || githubTag == "v6.0.0") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/PostgreSQL/OMOP%20CDM%20postgresql%20ddl.txt")
			} else if (githubTag == "v6.0.0_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/PostgreSQL/OMOP%20CDM%20postgresql%20ddl.txt")
			}
		}
	} else if (rdbms == "pdw") {
		if (cdmVersion == "5.3.1") {
			if (is.null(githubTag) || githubTag == "v5.3.1") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/ParallelDataWarehouse/OMOP%20CDM%20pdw%20ddl.txt")
			} else if (githubTag == "v5.3.1_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/ParallelDataWarehouse/OMOP%20CDM%20pdw%20v5_3_1%20ddl.sql")
			}
		} else if (cdmVersion == "6.0.0") {
			if (is.null(githubTag) || githubTag == "v6.0.0") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/ParallelDataWarehouse/OMOP%20CDM%20pdw%20ddl.txt")
			} else if (githubTag == "v6.0.0_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/ParallelDataWarehouse/OMOP%20CDM%20pdw%20ddl.txt")
			}
		}
	} else if (rdbms == "impala") {
		if (cdmVersion == "5.3.1") {
			if (is.null(githubTag) || githubTag == "v5.3.1") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Impala/OMOP%20CDM%20impala%20ddl.txt")
			} else if (githubTag == "v5.3.1_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/Impala/OMOP%20CDM%20impala%20v5_3_1%20ddl.sql")
			}
		} else if (cdmVersion == "6.0.0") {
			if (is.null(githubTag) || githubTag == "v6.0.0") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Impala/OMOP%20CDM%20impala%20ddl.txt")
			} else if (githubTag == "v6.0.0_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/Impala/OMOP%20CDM%20impala%20ddl.txt")
			}
		}
	} else if (rdbms == "netezza") {
		if (cdmVersion == "5.3.1") {
			if (is.null(githubTag) || githubTag == "v5.3.1") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Netezza/OMOP%20CDM%20netezza%20ddl.txt")
			} else if (githubTag == "v5.3.1_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/Netezza/OMOP%20CDM%20netezza%20v5_3_1%20ddl.sql")
			}
		} else if (cdmVersion == "6.0.0") {
			if (is.null(githubTag) || githubTag == "v6.0.0") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Netezza/OMOP%20CDM%20netezza%20ddl.txt")
			} else if (githubTag == "v6.0.0_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/Netezza/OMOP%20CDM%20netezza%20ddl.txt")
			}
		}
	} else if (rdbms == "bigquery") {
		if (cdmVersion == "5.3.1") {
			if (is.null(githubTag) || githubTag == "v5.3.1") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/BigQuery/OMOP%20CDM%20bigquery%20ddl.txt")
			} else if (githubTag == "v5.3.1_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/BigQuery/OMOP%20CDM%20bigquery%20v5_3_1%20ddl.sql")
			}
		} else if (cdmVersion == "6.0.0") {
			if (is.null(githubTag) || githubTag == "v6.0.0") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/BigQuery/OMOP%20CDM%20bigquery%20ddl.txt")
			} else if (githubTag == "v6.0.0_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/BigQuery/OMOP%20CDM%20bigquery%20ddl.txt")
			}
		}		
	} else if (rdbms == "redshift") {
		if (cdmVersion == "5.3.1") {
			if (is.null(githubTag) || githubTag == "v5.3.1") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Redshift/OMOP%20CDM%20redshift%20ddl.txt")
			} else if (githubTag == "v5.3.1_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/Redshift/OMOP%20CDM%20redshift%20v5_3_1%20ddl.sql")
			}
		} else if (cdmVersion == "6.0.0") {
			if (is.null(githubTag) || githubTag == "v6.0.0") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Redshift/OMOP%20CDM%20redshift%20ddl.txt")
			} else if (githubTag == "v6.0.0_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/Redshift/OMOP%20CDM%20redshift%20ddl.txt")
			}
		}		
	} else if (rdbms == "sql server") {
		if (cdmVersion == "5.3.1") {
			if (is.null(githubTag) || githubTag == "v5.3.1") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Sql%20Server/OMOP%20CDM%20sql%20server%20ddl.txt")
			} else if (githubTag == "v5.3.1_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/Sql%20Server/OMOP%20CDM%20sql%20server%20v5_3_1%20ddl.sql")
			}
		} else if (cdmVersion == "6.0.0") {
			if (is.null(githubTag) || githubTag == "v6.0.0") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Sql%20Server/OMOP%20CDM%20sql%20server%20ddl.txt")
			} else if (githubTag == "v6.0.0_fixes") {
				webResponse <- httr::GET("https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/Sql%20Server/OMOP%20CDM%20sql%20server%20ddl.txt")
			}
		}		
	}
	
	# Read the SQL DDL from the correct github repo and apply some string formatting to enable
	# use of parameterized sql to write to the correct schema.
	
	tableDDL <- httr::content(webResponse)
	tableDDL <- toupper(tableDDL)

	if (!is.null(githubTag) && githubTag == "v5.3.1_fixes") {
		tableDDL <- SqlRender::render(sql = tableDDL, CDMDATABASESCHEMA = cdmSchema)
	} else {
		tableDDL <- gsub("CREATE TABLE  \n", "CREATE TABLE ", tableDDL)
		tableDDL <- gsub("CREATE TABLE ", "CREATE TABLE @CDM_SCHEMA.", tableDDL)
		tableDDL <- gsub("CREATE TABLE @CDM_SCHEMA. ", "CREATE TABLE @CDM_SCHEMA.", tableDDL)
		tableDDL <- gsub("INSERT INTO ", "INSERT INTO @CDM_SCHEMA.", tableDDL)	
		tableDDL <- SqlRender::render(sql = tableDDL, CDM_SCHEMA = cdmSchema)
	}
	
	tableDDL <- SqlRender::translate(sql = tableDDL, targetDialect = rdbms)
			
	# Save the translated sql ddl for review purposes.
	if (!dir.exists("output")) {
		dir.create("output")
	}
	
    writeLines(paste0("Executing DDL from: ",webResponse$url))
    writeLines(paste0("Saving DDL in: output/",rdbms,"_",cdmVersion,"_ddl.sql"))
	SqlRender::writeSql(tableDDL,paste0("output/",rdbms,"_",cdmVersion,"_ddl.sql"))

	if (!sqlOnly) {
		conn <- DatabaseConnector::connect(connectionDetails)
		DatabaseConnector::executeSql(conn, tableDDL)
		on.exit(DatabaseConnector::disconnect(conn))
	}
}
