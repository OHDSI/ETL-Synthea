#' @title Create Optional Extra Indices for ETL Performance
#'
#' @description This function creates indices for certain tables which may help to speed up LoadEventTables.
#'
#' @param connectionDetails An R object of type\cr\code{connectionDetails} created using the
#'                          function \code{createConnectionDetails} in the \code{DatabaseConnector} package.
#' @param cdmSchema The name of the CDM database schema. Requires read and write permissions to this schema. On SQL
#'                  Server, this should specify both the database and the schema, so for example 'cdm_instance.dbo'.
#' @param syntheaSchema The name of the Synthea database schema. Requires read and write permissions to this schema. On SQL
#'                      Server, this should specify both the database and the schema, so for example 'synthea.dbo'.
#' @param syntheaVersion Your Synthea version. Currently "2.7.0" and "3.0.0" are supported.
#' @param outputFolder Location of the SQL scripts if sqlOnly = TRUE. Default is NULL.
#' @param sqlOnly A boolean that determines whether to create the indices or generate a SQL scripts. Default is FALSE.
#'
#' @details This function creates indices which have been found to speed up certain long-running INSERT queries in LoadEventTables,
#'          for some users. Indices are created on the intermediate vocabulary mapping tables; the person & provider CDM tables;
#'          and the claims_transactions Synthea table (in Synthea 3.0.0).
#'
#' @importFrom utils head
#'
#' @export


createExtraIndices <- function(connectionDetails,
                               cdmSchema,
                               syntheaSchema,
                               syntheaVersion,
                               outputFolder = NULL,
                               sqlOnly = FALSE) {
  sqlFilename <- "extra_indices.sql"

  sql <- SqlRender::loadRenderTranslateSql(
    sqlFilename = sqlFilename,
    packageName = "ETLSyntheaBuilder",
    dbms = connectionDetails$dbms,
    targetDialect = connectionDetails$dbms,
    cdmDatabaseSchema = cdmSchema,
    syntheaVersion = syntheaVersion,
    syntheaSchema = syntheaSchema
  )
  sqlQueries <- utils::head(unlist(strsplit(sql, ";")), -1)

  if (!sqlOnly) {
    print("Creating Extra Indices....")
    conn <- DatabaseConnector::connect(connectionDetails)
    lapply(sqlQueries, function(query) {
      tryCatch(
        expr = {
          DatabaseConnector::executeSql(conn, query)
        },
        error = function(e) {
          message(paste("Error in SQL:", query))
          message(e)
        }
      )
    })
    DatabaseConnector::disconnect(conn)
    print("Index Creation Complete.")
  } else {
    if (is.null(outputFolder)) {
      stop("Must specify an outputFolder location when using sqlOnly = TRUE")
    }
    if (!dir.exists(outputFolder)) {
      dir.create(outputFolder)
    }
    writeLines(paste0("Saving to output/", sqlFilename))
    SqlRender::writeSql(sql, paste0("output/", sqlFilename))
  }
}
