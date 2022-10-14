#' @title Drop Vocabulary Tables.
#'
#' @description This function drops Vocabulary tables in a CDM.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the CDM schema that contains the Vocabulary.
#'                   Requires read and write permissions to this database. On SQL
#'                   Server, this should specifiy both the database and the schema,
#'                   so for example 'cdm_instance.dbo'.
#'
#'@export


DropVocabTables <- function(connectionDetails, cdmSchema)
{
  vocabTables <- c(
    "ATTRIBUTE_DEFINITION",
    "COHORT_DEFINITION",
    "CONCEPT",
    "CONCEPT_ANCESTOR",
    "CONCEPT_CLASS",
    "CONCEPT_RELATIONSHIP",
    "CONCEPT_SYNONYM",
    "DOMAIN",
    "DRUG_STRENGTH",
    "RELATIONSHIP",
    "SOURCE_TO_CONCEPT_MAP",
    "VOCABULARY"
  )

  conn <- DatabaseConnector::connect(connectionDetails)
  allTables <- DatabaseConnector::getTableNames(conn, cdmSchema)
  writeLines("Dropping vocabulary tables...")
  tablesToDrop <- allTables[which(allTables %in% vocabTables)]
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
