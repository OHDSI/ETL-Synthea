#' @title Export a CDM (Vocabulary and Event tables) into a SQLite Database.
#'
#' @description This function fetches (pruned) table data into R dataframes and writes them to a SQLite DB. (Eunomia support)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#'
#' @param cdmSchema  The name of the database schema that contains the CDM.
#'                   Requires read and write permissions to this database. On SQL
#'                   Server, this should specifiy both the database and the schema,
#'                   so for example 'cdm_instance.dbo'.
#'
#' @param SQLiteDbName         The name of the SQLite Database File.
#'
#'@export

exportToSQLite <-
  function(connectionDetails,
           cdmSchema,
           SQLiteDbName = "cdm.sqlite")
  {
    conn      <- DatabaseConnector::connect(connectionDetails)
    sqliteCD  <-
      DatabaseConnector::createConnectionDetails(dbms = "sqlite", server = SQLiteDbName)
    sqliteCon <- DatabaseConnector::connect(sqliteCD)

    eventTable <- c(
      "care_site",
      "cdm_source",
      "cohort",
      "cohort_attribute",
      "condition_era",
      "condition_occurrence",
      "cost",
      "death",
      "device_exposure",
      "dose_era",
      "drug_era",
      "drug_exposure",
      "fact_relationship",
      "location",
      "measurement",
      "metadata",
      "note",
      "note_nlp",
      "observation",
      "observation_period",
      "payer_plan_period",
      "person",
      "procedure_occurrence",
      "provider",
      "specimen",
      "visit_detail",
      "visit_occurrence"
    )

    vocabTable <- c(
      "concept",
      "concept_ancestor",
      "concept_class",
      "concept_relationship",
      "concept_synonym",
      "domain",
      "drug_strength",
      "relationship",
      "source_to_concept_map",
      "vocabulary"
    )

    for (tableName in c(eventTable, vocabTable)) {
      sqlQuery <-
        paste0("select * from  ", paste0(cdmSchema, ".", tableName), ";")
      translatedSql <-
        SqlRender::translate(renderedSql, targetDialect = connectionDetails$dbms)
      writeLines(paste0("Fetching: ", tableName))
      tableData <- DatabaseConnector::querySql(conn, translatedSql)
      DatabaseConnector::insertTable(sqliteCon, toupper(tableName), tableData)
    }

    DatabaseConnector::disconnect(conn)
    DatabaseConnector::disconnect(sqliteCon)
  }
