#' @title Backup Vocabulary and Event tables before pruning.
#'
#' @description This function performs a "back up" of the original tables by renaming them. (Eunomia support)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the database schema that contains the CDM.
#'                           Requires read and write permissions to this database. On SQL
#'                           Server, this should specifiy both the database and the schema,
#'                           so for example 'cdm_instance.dbo'.
#' @param cdmVersion The version of your CDM.  Currently "5.3.1" and "6.0.1".
#'
#'@export


backupCDM <- function(connectionDetails, cdmSchema, cdmVersion)
{
  if (cdmVersion == "5.3.1")
    sqlFilePath <- "cdm_version/v531"
  else if (cdmVersion == "6.0.0")
    sqlFilePath <- "cdm_version/v600"
  else
    stop("Unsupported CDM specified. Supported CDM versions are \"5.3.1\" and \"6.0.0\"")


  sql <- SqlRender::loadRenderTranslateSql(
    sqlFileName = paste0(sqlFilePath, "/backup_cdm.sql"),
    packageName = "ETLSyntheaBuilder",
    dbms        = connectionDetails$dbms,
    cdm_schema  = cdmSchema
  )
  conn <- DatabaseConnector::connect(connectionDetails)
  DatabaseConnector::executeSql(conn, sql)
  on.exit(DatabaseConnector::disconnect(conn))
}
