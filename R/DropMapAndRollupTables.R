#' @title Drop Vocabulary Mapping And Visit Rollup Tables.
#'
#' @description This function cleans up the tables created by the \cr\code{CreateVocabMapTables()} and \cr\code{CreateVisitRollupTables()}
#'
#' @details This function assumes \cr\code{CreateVocabMapTables()} and \cr\code{CreateVisitRollupTables()} have already been run.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the database schema that will contain the Vocab mapping
#'                                     tables.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#'
#'@export
DropMapAndRollupTables <- function(connectionDetails, cdmSchema)
{
  mapAndRollupTables <-
    c(
      "SOURCE_TO_SOURCE_VOCAB_MAP",
      "SOURCE_TO_STANDARD_VOCAB_MAP",
      "ALL_VISITS",
      "ASSIGN_ALL_VISIT_IDS",
      "FINAL_VISIT_IDS"
    )

  conn <- DatabaseConnector::connect(connectionDetails)
  allTables <- DatabaseConnector::getTableNames(conn, cdmSchema)
  tablesToDrop <- allTables[which(allTables %in% mapAndRollupTables)]
  sql <-
    paste("drop table @cdm_schema.",
          tablesToDrop,
          ";",
          collapse = "\n",
          sep = "")
  sql <- SqlRender::render(sql, cdm_schema = cdmSchema)
  sql <-
    SqlRender::translate(sql, targetDialect = connectionDetails$dbms)
  DatabaseConnector::executeSql(conn, sql)
  on.exit(DatabaseConnector::disconnect(conn))
}
