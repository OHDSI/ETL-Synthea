#' @title Create OMOP CDM Tables.
#'
#' @description This function creates all OMOP CDM tables (empty).
#'
#' @usage CreateCDMTables(connectionDetails,cdmDatabaseSchema)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmDatabaseSchema  The name of the database schema that will contain the OMOP CDM
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param vocabTableCreate Set to TRUE if the vocabulary tables should be created along with the event tables.
#'                                     Default is FALSE.
#'
#'@export


CreateCDMTables <- function (connectionDetails, cdmDatabaseSchema, vocabTableCreate = FALSE)
{


    pathToSql <- base::system.file("sql/sql_server", package = "ETLSyntheaBuilder")

    sqlFile <- base::paste0(pathToSql, "/", "create_cdm_tables.sql")

    sqlQuery <- base::readChar(sqlFile, base::file.info(sqlFile)$size)

    renderedSql <- SqlRender::renderSql(sqlQuery, cdm_schema = cdmDatabaseSchema, vocab_create = vocabTableCreate)$sql

    translatedSql <- SqlRender::translateSql(renderedSql, targetDialect = connectionDetails$dbms)$sql

    writeLines("Running create_cdm_tables.sql")

	conn <- DatabaseConnector::connect(connectionDetails)

    DatabaseConnector::dbExecute(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE)

    on.exit(DatabaseConnector::disconnect(conn))

}
