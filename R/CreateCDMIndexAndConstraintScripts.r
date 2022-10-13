#' @title Create Index and Constraint DDL SQL scripts for CDM tables on rdbms that support these features.
#'
#' @description This function creates one or more SQL scripts as defined in https://github.com/OHDSI/CommonDataModel.
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
#'
#' @details This function creates SQL scripts for the indices and constraints on tables in a CDM by referring to the
#'          correct SQL DDL script in the OHDSI CommonDataModel repo. The database platform is
#'          determined by \code{connectionDetails$dbms}.  Currently "oracle", "postgresql", "pdw", "netezza", and "sql server" are supported.
#'          The SQL DDL scripts are written to the \code{output} directory.  The SQL scripts can then be run manually in a SQL session
#'          or by using \code{DatabaseConnector::executeSql(connection,DDLscriptName)}
#'
#'@export


CreateCDMIndexAndConstraintScripts <-
  function(connectionDetails,
           cdmSchema,
           cdmVersion,
           githubTag = NULL)
  {
    supportedDbs      <-
      c("oracle", "postgresql", "pdw", "netezza", "sql server")
    supportedVersions <- c("5.3.1", "6.0.0")
    supportedTags     <-
      c("v5.3.1", "v6.0.0", "v5.3.1_fixes", "v6.0.0_fixes")
    rdbms <- tolower(connectionDetails$dbms)

    if (!(cdmVersion %in% supportedVersions)) {
      stop("Unsupported CDM specified. Supported CDM versions are \"5.3.1\" and \"6.0.0\"")
    }

    if (!(rdbms %in% supportedDbs)) {
      stop(
        "Unsupported RDBMS specified. Supported rdbms are: \"oracle\", \"postgresql\", \"pdw\", \"netezza\", and \"sql server\""
      )
    }

    if (!is.null(githubTag) && !(githubTag %in% supportedTags)) {
      stop(
        "Unrecognized github tag.  Supported values are \"v5.3.1\", \"v6.0.0\", \"v5.3.1_fixes\", and \"v6.0.0_fixes\""
      )
    }

    if (cdmVersion == "5.3.1" &&
        !(githubTag %in% c("v5.3.1", "v5.3.1_fixes"))) {
      stop("cdmVersion and githubTag mismatch.")
    }

    if (cdmVersion == "6.0.0" &&
        !(githubTag %in% c("v6.0.0", "v6.0.0_fixes"))) {
      stop("cdmVersion and githubTag mismatch.")
    }

    # Determine which DDL script to use (from https://github.com/OHDSI/CommonDataModel)
    # based on the given db platform, cdm version, and (optionally) github tag.

    if (rdbms == "oracle") {
      if (cdmVersion == "5.3.1") {
        if (is.null(githubTag) || githubTag == "v5.3.1") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Oracle/OMOP%20CDM%20oracle%20indexes.txt"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Oracle/OMOP%20CDM%20oracle%20constraints.txt"
            )
        } else if (githubTag == "v5.3.1_fixes") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/Oracle/OMOP%20CDM%20oracle%20v5_3_1%20primary%20keys.sql"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/Oracle/OMOP%20CDM%20oracle%20v5_3_1%20constraints.sql"
            )
        }
      } else if (cdmVersion == "6.0.0") {
        if (is.null(githubTag) || githubTag == "v6.0.0") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Oracle/OMOP%20CDM%20oracle%20pk%20indexes.txt"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Oracle/OMOP%20CDM%20oracle%20constraints.txt"
            )
        } else if (githubTag == "v6.0.0_fixes") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/Oracle/OMOP%20CDM%20oracle%20pk%20indexes.txt"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/Oracle/OMOP%20CDM%20oracle%20constraints.txt"
            )
        }
      }
    } else if (rdbms == "postgresql") {
      if (cdmVersion == "5.3.1") {
        if (is.null(githubTag) || githubTag == "v5.3.1") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/PostgreSQL/OMOP%20CDM%20postgresql%20indexes.txt"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/PostgreSQL/OMOP%20CDM%20postgresql%20constraints.txt"
            )
        } else if (githubTag == "v5.3.1_fixes") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/PostgreSQL/OMOP%20CDM%20postgresql%20v5_3_1%20primary%20keys.sql"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/PostgreSQL/OMOP%20CDM%20postgresql%20v5_3_1%20constraints.sql"
            )
        }
      } else if (cdmVersion == "6.0.0") {
        if (is.null(githubTag) || githubTag == "v6.0.0") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/PostgreSQL/OMOP%20CDM%20postgresql%20pk%20indexes.txt"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/PostgreSQL/OMOP%20CDM%20postgresql%20constraints.txt"
            )
        } else if (githubTag == "v6.0.0_fixes") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/PostgreSQL/OMOP%20CDM%20postgresql%20pk%20indexes.txt"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/PostgreSQL/OMOP%20CDM%20postgresql%20constraints.txt"
            )
        }
      }
    } else if (rdbms == "pdw") {
      if (cdmVersion == "5.3.1") {
        if (is.null(githubTag) || githubTag == "v5.3.1") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/ParallelDataWarehouse/OMOP%20CDM%20pdw%20indexes.txt"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/ParallelDataWarehouse/OMOP%20CDM%20pdw%20constraints.txt"
            )
        } else if (githubTag == "v5.3.1_fixes") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/ParallelDataWarehouse/OMOP%20CDM%20pdw%20v5_3_1%20indices.sql"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/ParallelDataWarehouse/OMOP%20CDM%20pdw%20v5_3_1%20constraints.sql"
            )
        }
      } else if (cdmVersion == "6.0.0") {
        if (is.null(githubTag) || githubTag == "v6.0.0") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/ParallelDataWarehouse/OMOP%20CDM%20pdw%20pk%20indexes.txt"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/ParallelDataWarehouse/OMOP%20CDM%20pdw%20constraints.txt"
            )
        } else if (githubTag == "v6.0.0_fixes") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/ParallelDataWarehouse/OMOP%20CDM%20pdw%20pk%20indexes.txt"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/ParallelDataWarehouse/OMOP%20CDM%20pdw%20constraints.txt"
            )
        }
      }
    } else if (rdbms == "netezza") {
      if (cdmVersion == "5.3.1") {
        if (is.null(githubTag) || githubTag == "v5.3.1") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Netezza/OMOP%20CDM%20netezza%20primary%20keys.txt"
            )
        } else if (githubTag == "v5.3.1_fixes") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/Netezza/OMOP%20CDM%20netezza%20v5_3_1%20primary%20keys.sql"
            )
        }
      } else if (cdmVersion == "6.0.0") {
        if (is.null(githubTag) || githubTag == "v6.0.0") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Netezza/OMOP%20CDM%20netezza%20primary%20keys.txt"
            )
        } else if (githubTag == "v6.0.0_fixes") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/Netezza/OMOP%20CDM%20netezza%20primary%20keys.txt"
            )
        }
      }
    } else if (rdbms == "sql server") {
      if (cdmVersion == "5.3.1") {
        if (is.null(githubTag) || githubTag == "v5.3.1") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Sql%20Server/OMOP%20CDM%20sql%20server%20indexes.txt"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1/Sql%20Server/OMOP%20CDM%20sql%20server%20constraints.txt"
            )
        } else if (githubTag == "v5.3.1_fixes") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/Sql%20Server/OMOP%20CDM%20sql%20server%20v5_3_1%20primary%20keys.sql"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.3.1_fixes/Sql%20Server/OMOP%20CDM%20sql%20server%20v5_3_1%20constraints.sql"
            )
        }
      } else if (cdmVersion == "6.0.0") {
        if (is.null(githubTag) || githubTag == "v6.0.0") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Sql%20Server/OMOP%20CDM%20sql%20server%20pk%20indexes.txt"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0.0/Sql%20Server/OMOP%20CDM%20sql%20server%20constraints.txt"
            )
        } else if (githubTag == "v6.0.0_fixes") {
          webResponseInd <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/Sql%20Server/OMOP%20CDM%20sql%20server%20pk%20indexes.txt"
            )
          webResponseCon <-
            httr::GET(
              "https://raw.githubusercontent.com/OHDSI/CommonDataModel/v6.0_fixes/Sql%20Server/OMOP%20CDM%20sql%20server%20constraints.txt"
            )
        }
      }
    }

    # Read the SQL DDL from the correct github repo and apply some string formatting to enable
    # use of parameterized sql to write to the correct schema.

    indexDDL      <- httr::content(webResponseInd)
    constraintDDL <- httr::content(webResponseCon)
    indexDDL      <- toupper(indexDDL)
    constraintDDL <- toupper(constraintDDL)

    if (githubTag == "v5.3.1_fixes") {
      indexDDL      <-
        SqlRender::render(sql = indexDDL, CDMDATABASESCHEMA = cdmSchema)
      constraintDDL <-
        SqlRender::render(sql = constraintDDL, CDMDATABASESCHEMA = cdmSchema)
    } else {
      indexDDL <- gsub(" ON ", " ON @CDM_SCHEMA.", indexDDL)
      indexDDL <-
        gsub("ALTER TABLE", "ALTER TABLE @CDM_SCHEMA.", indexDDL)
      indexDDL <- gsub("@CDM_SCHEMA. ", "@CDM_SCHEMA.", indexDDL)
      indexDDL <-
        SqlRender::render(indexDDL, CDM_SCHEMA = cdmSchema)
      indexDDL <-
        SqlRender::translate(indexDDL, targetDialect = rdbms)

      constraintDDL <-
        gsub("ALTER TABLE", "ALTER TABLE @CDM_SCHEMA.", constraintDDL)
      constraintDDL <-
        gsub("@CDM_SCHEMA. ", "@CDM_SCHEMA.", constraintDDL)
      constraintDDL <-
        SqlRender::render(constraintDDL, CDM_SCHEMA = cdmSchema)
      constraintDDL <-
        SqlRender::translate(constraintDDL, targetDialect = rdbms)
    }

    # Save the translated sql ddl to be run at a later time
    if (!dir.exists("output")) {
      dir.create("output")
    }

    # Constraint DDL
    writeLines(paste0("Pulling constraint DDL from: ", webResponseCon$url))
    writeLines(
      paste0(
        "Saving constraint DDL in: output/",
        rdbms,
        "_",
        cdmVersion,
        "_constraint_ddl.sql"
      )
    )
    SqlRender::writeSql(constraintDDL,
                        paste0("output/", rdbms, "_", cdmVersion, "_constraint_ddl.sql"))

    # Index DDL
    # Netezza only has a PK script file
    if (rdbms != "netezza") {
      writeLines(paste0("Pulling index DDL from: ", webResponseInd$url))
      writeLines(paste0(
        "Saving index DDL in: output/",
        rdbms,
        "_",
        cdmVersion,
        "_index_ddl.sql"
      ))
      SqlRender::writeSql(indexDDL,
                          paste0("output/", rdbms, "_", cdmVersion, "_index_ddl.sql"))
    }
  }
