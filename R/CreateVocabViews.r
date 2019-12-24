#' @title Create Vocabulary Views to a Preexisting Vocabulary Schema.
#'
#' @description This function creates views for all Vocabulary tables to a specified schema that contains all those tables.
#'
#' @usage CreateVocabViews(connectionDetails, vocabSourceSchema, vocabTargetSchema)
#'
#' @details This function assumes has already been run and \cr\code{vocabSourceSchema} has all required Vocabulary tables.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param vocabSourceSchema  The name of the database schema that already contains the Vocabulary
#'                                     tables to create views to.  Requires read permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param vocabTargetSchema  The name of the database schema into which to create the Vocabulary
#'                                     views in.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#'
#'@export

CreateVocabViews <- function (connectionDetails, vocabSourceSchema, vocabTargetSchema)
{
    pathToSql <- base::system.file("sql/sql_server", package = "ETLSyntheaBuilder")

    sqlFile <- base::paste0(pathToSql, "/", "create_vocab_views.sql")

    sqlQuery <- base::readChar(sqlFile, base::file.info(sqlFile)$size)

    renderedSql <- SqlRender::render(sqlQuery, vocab_schema = vocabSourceSchema, cdm_schema = vocabTargetSchema)

    translatedSql <- SqlRender::translate(renderedSql, targetDialect = connectionDetails$dbms)

    writeLines("Running create_vocab_views.sql")

    conn <- DatabaseConnector::connect(connectionDetails)

    DatabaseConnector::dbExecute(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE)

    on.exit(DatabaseConnector::disconnect(conn))
}
