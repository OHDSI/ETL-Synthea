#' @title Drop Vocabulary Views.
#'
#' @description This function drops Vocabulary views.
#'
#' @usage DropVocabViews(connectionDetails,vocabDatabaseSchema)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param vocabDatabaseSchema  The name of the database schema that contains the Vocabulary
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'vocab_instance.dbo'.
#'
#'@export


DropVocabViews <- function (connectionDetails, vocabDatabaseSchema)
{


    pathToSql <- base::system.file("sql/sql_server", package = "ETLSyntheaBuilder")

    sqlFile <- base::paste0(pathToSql, "/", "drop_vocab_views.sql")

    sqlQuery <- base::readChar(sqlFile, base::file.info(sqlFile)$size)

    renderedSql <- SqlRender::render(sqlQuery, vocab_schema = vocabDatabaseSchema)

    translatedSql <- SqlRender::translate(renderedSql, targetDialect = connectionDetails$dbms)

    writeLines("Running drop_vocab_views.sql")

    conn <- DatabaseConnector::connect(connectionDetails)

    DatabaseConnector::dbExecute(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE, runAsBatch = TRUE)

    on.exit(DatabaseConnector::disconnect(conn))
}
