#' @title Create Vocabulary Constraints And Indices
#'
#' @description This function sets the constrainsts and creates the indices on the vocabulary tables.
#'
#' @usage CreateVocabConstraintsAndIndices(connectionDetails,vocabDatabaseSchema)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param vocabDatabaseSchema  The name of the database schema that will contain the Vocabulary
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'vocab_instance.dbo'.
#'
#'@export


CreateVocabConstraintsAndIndices <- function (connectionDetails, vocabDatabaseSchema)
{

    pathToSql <- base::system.file("sql/sql_server", package = "ETLSyntheaBuilder")

    for (fileName in c("create_vocab_primary_keys.sql", "create_vocab_indices.sql", "create_vocab_constraints.sql")) {
        sqlFile <- base::paste0(pathToSql, "/", fileName)

        sqlQuery <- base::readChar(sqlFile, base::file.info(sqlFile)$size)

        renderedSql <- SqlRender::render(sqlQuery, vocab_schema = vocabDatabaseSchema)

        translatedSql <- SqlRender::translate(renderedSql, targetDialect = connectionDetails$dbms)

        writeLines(base::paste0("Running ", fileName))

    	conn <- DatabaseConnector::connect(connectionDetails)

        DatabaseConnector::dbExecute(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE)
    }

    on.exit(DatabaseConnector::disconnect(conn))

}
