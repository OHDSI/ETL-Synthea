#' @title Load Vocabulary Tables From CSV Files.
#'
#' @description This function populates all Vocabulary tables with data in csv files.
#'
#' @details This function assumes \cr\code{createCDMTables()} has already been run.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the database schema that will contain the Vocabulary (and CDM)
#'                                     tables.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param vocabFileLoc     The location of the vocabulary csv files.
#' @param bulkLoad       Boolean flag indicating whether or not to use bulk loading (if possible).  Default is FALSE.
#'
#'@export


LoadVocabFromCsv <-
  function(connectionDetails,
           cdmSchema,
           vocabFileLoc,
           bulkLoad = FALSE)
  {
    csvList <- c(
      "concept.csv",
      "vocabulary.csv",
      "concept_ancestor.csv",
      "concept_relationship.csv",
      "relationship.csv",
      "concept_synonym.csv",
      "domain.csv",
      "concept_class.csv",
      "drug_strength.csv"
    )

    fileList <- list.files(vocabFileLoc)

    fileList <- fileList[which(tolower(fileList) %in% csvList)]

    conn <- DatabaseConnector::connect(connectionDetails)

    for (csv in fileList) {
      writeLines(paste0("Working on file ", paste0(vocabFileLoc, "/", csv)))

      writeLines(" - reading file ")
      vocabTable <-
        data.table::fread(
          file = paste0(vocabFileLoc, "/", csv),
          stringsAsFactors = FALSE,
          header = TRUE,
          sep = "\t",
          na.strings = ""
        )

      if (tolower(csv) == "concept.csv" ||
          tolower(csv) == "concept_relationship.csv" ||
          tolower(csv) == "drug_strength.csv") {
        writeLines(" - handling dates")
        vocabTable$valid_start_date <-
          as.Date(as.character(vocabTable$valid_start_date), "%Y%m%d")
        vocabTable$valid_end_date   <-
          as.Date(as.character(vocabTable$valid_end_date), "%Y%m%d")
        vocabTable <- dplyr::tibble(vocabTable)
      }

      writeLines(" - type converting")
      vocabTable <- readr::type_convert(df = vocabTable,
                                        col_types = readr::cols(),
                                        na = c(NA, "")) %>%
        dplyr::tibble()

      if (tolower(csv) == "drug_strength.csv") {
        vocabTable <- vocabTable %>%
          mutate_at(
            vars(
              "amount_value",
              "amount_unit_concept_id",
              "numerator_value",
              "numerator_unit_concept_id",
              "denominator_value",
              "denominator_unit_concept_id",
              "box_size"
            ),
            ~ replace(., is.na(.), 0)
          )
      }

      chunkSize <- 1e7
      numberOfRowsInVocabTable <- nrow(vocabTable)
      numberOfChunks <-
        ceiling(x = numberOfRowsInVocabTable / chunkSize)

      writeLines(
        paste0(
          " - uploading ",
          numberOfRowsInVocabTable,
          " rows of data in ",
          numberOfChunks,
          " chunks."
        )
      )

      sql <-
        "DELETE FROM @table_name;"
      DatabaseConnector::renderTranslateExecuteSql(
        connection = conn,
        sql = sql,
        table_name = paste0(cdmSchema, ".", strsplit(csv, "[.]")[[1]][1])
      )

      startRow <- 1
      for (j in (1:numberOfChunks)) {
        if (numberOfRowsInVocabTable >= startRow) {
          maxRows <- min(numberOfRowsInVocabTable,
                         startRow + chunkSize)
          chunk <- vocabTable[startRow:maxRows, ]
          writeLines(
            paste0(
              " - chunk uploading started on ",
              Sys.time(),
              " for rows ",
              startRow,
              " to ",
              maxRows
            )
          )
          suppressWarnings({
            DatabaseConnector::insertTable(
              connection = conn,
              tableName = paste0(cdmSchema, ".", strsplit(csv, "[.]")[[1]][1]),
              data = chunk,
              dropTableIfExists = FALSE,
              createTable = FALSE,
              bulkLoad = bulkLoad,
              progressBar = TRUE
            )
          })
          startRow <- maxRows + 1
        }
      }
      writeLines(" - Success")
    }

    on.exit(DatabaseConnector::disconnect(conn))
  }
