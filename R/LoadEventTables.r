#' @title Load CDM Non-Vocabulary Tables.
#'
#' @description This function loads the CDM Event tables with Synthea data.  The tables that comprise the Vocabulary are
#'               loaded via \cr\code{LoadVocabTables()}.
#'
#' @usage LoadEventTables (connectionDetails, cdmDatabaseSchema, syntheaDatabaseSchema)
#'
#' @details This function assumes \cr\code{createEventTables()}, \cr\code{createSyntheaTables()}, \cr\code{LoadSyntheaTables()},
#'              and \cr\code{LoadVocabTables()} have all been run.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmDatabaseSchema  The name of the database schema that will contain the different VISIT
#'                                     tables.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param syntheaDatabaseSchema  The name of the database schema that contain the Synthea
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param vocabDatabaseSchema  The name of the database schema that contains the OMOP Vocabulary tables. Requires
#'                                     read permissions to this database. By default this is set to cdmDatabaseSchema.
#'
#'@export


LoadEventTables <- function (connectionDetails, cdmDatabaseSchema, syntheaDatabaseSchema, vocabDatabaseSchema = cdmDatabaseSchema)
{

    queries <- c("insert_person.sql", "insert_observation_period.sql", "insert_visit_occurrence.sql", "insert_condition_occurrence.sql",
                 "insert_observation.sql", "insert_measurement.sql", "insert_procedure_occurrence.sql", "insert_drug_exposure.sql",
				 "insert_condition_era.sql", "insert_drug_era.sql", "insert_cdm_source.sql")

	conn <- DatabaseConnector::connect(connectionDetails)

	for (query in queries) {

        pathToSql <- base::system.file("sql/sql_server", package = "ETLSyntheaBuilder")

        sqlFile <- base::paste0(pathToSql, "/", query)

        sqlQuery <- base::readChar(sqlFile, base::file.info(sqlFile)$size)

        renderedSql <- SqlRender::render(sqlQuery, cdm_schema = cdmDatabaseSchema, synthea_schema = syntheaDatabaseSchema, vocab_schema = vocabDatabaseSchema)

        translatedSql <- SqlRender::translate(renderedSql, targetDialect = connectionDetails$dbms)

        writeLines(paste0("Running: ",query))

        DatabaseConnector::executeSql(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE)

    }

    on.exit(DatabaseConnector::disconnect(conn))

}
