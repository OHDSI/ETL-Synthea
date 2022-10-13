#' @title Create Tables for Visit Rollup Logic.
#'
#' @description This function creates tables ALL_VISITS, ASSIGN_ALL_VISIT_IDS, and FINAL_VISIT_IDS.
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
#' @param cdmVersion The version of your CDM.  Currently "5.3" and "5.4" are supported.
#' @param sqlOnly A boolean that determines whether or not to perform the load or generate SQL scripts. Default is FALSE.
#'
#'@export


CreateVisitRollupTables <-
  function(connectionDetails,
           cdmSchema,
           syntheaSchema,
           cdmVersion,
           sqlOnly = FALSE)
  {
    if (cdmVersion == "5.3")
      sqlFilePath <- "cdm_version/v531"
    else if (cdmVersion == "5.4")
      sqlFilePath <- "cdm_version/v540"
    else
      stop("Unsupported CDM specified. Supported CDM versions are \"5.3\" and \"5.4\"")

    queries <-
      c("AllVisitTable.sql",
        "AAVITable.sql",
        "final_visit_ids.sql")

    if (!sqlOnly) {
      conn <- DatabaseConnector::connect(connectionDetails)
    }

    for (query in queries) {
      translatedSql <- SqlRender::loadRenderTranslateSql(
        sqlFilename    = paste0(sqlFilePath, "/", query),
        packageName    = "ETLSyntheaBuilder",
        dbms           = connectionDetails$dbms,
        cdm_schema     = cdmSchema,
        synthea_schema = syntheaSchema,
        warnOnMissingParameters = FALSE
      )

      if (sqlOnly) {
        if (!dir.exists("output"))
          dir.create("output")

        writeLines(paste0("Saving to output/", query))
        SqlRender::writeSql(translatedSql, paste0("output/", query))

      } else {
        writeLines(paste0("Running: ", query))
        DatabaseConnector::executeSql(conn, translatedSql)
      }
    }
    if (!sqlOnly) {
      DatabaseConnector::disconnect(conn)
    }
  }
