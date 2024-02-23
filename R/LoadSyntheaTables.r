#' @title Load Synthea Tables.
#'
#' @description This function populates all Synthea tables.
#'
#' @details This function assumes \cr\code{createSyntheaTables()} has already been run.  Additionally,
#'              this function assumes the data files used to populate the tables are csv files generated by
#'              running the basic setup (creating a database with 1000 people):
#'                  \cr\code{git clone https://github.com/synthetichealth/synthea.git}
#'                  \cr\code{cd synthea}
#'                  \cr\code{./gradlew build check test}
#'                  \cr\code{./run_synthea -p 1000}
#'
#'               You can enable csv records in src/main/resources/synthea.properties by setting exporter.csv.export = true.
#'               As of the time of this writing the csv files can be found at synthea/output/csv.
#'               For more details: \href{https://github.com/synthetichealth/synthea/wiki/Basic-Setup-and-Running}{Synthea Basic Setup}
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param syntheaSchema  The name of the database schema that will contain the Synthea
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param syntheaFileLoc     The location of the Synthea csv files created by running the executable run_synthea.
#' @param bulkLoad       Boolean flag indicating whether or not to use bulk loading (if possible).  Default is FALSE.
#'
#'@export


LoadSyntheaTables <-
  function(connectionDetails,
           syntheaSchema,
           syntheaFileLoc,
           bulkLoad = FALSE)
  {
    csvList <- list.files(syntheaFileLoc, pattern = "*.csv")

    conn <- DatabaseConnector::connect(connectionDetails)

    for (csv in csvList) {
      syntheaTable <-
        data.table::fread(
          file = paste0(syntheaFileLoc, "/", csv),
          stringsAsFactors = FALSE,
          header = TRUE,
          sep = ",",
          na.strings = ""
        )

      writeLines(paste0("Loading: ", csv))

      # experiencing type conversion errors and need to explicitly case some columns
      if ("START"       %in% colnames(syntheaTable)) {
        syntheaTable$START <-
          as.Date(syntheaTable$START, format = "%Y-%m-%d")
      }
      if ("STOP"        %in% colnames(syntheaTable)) {
        syntheaTable$STOP         <-
          as.Date(syntheaTable$STOP, format = "%Y-%m-%d")
      }
      if ("DATE"        %in% colnames(syntheaTable)) {
        syntheaTable$DATE         <-
          as.Date(syntheaTable$DATE, format = "%Y-%m-%d")
      }
      if ("START_DATE"        %in% colnames(syntheaTable)) {
        syntheaTable$START_DATE         <-
          as.Date(syntheaTable$START_DATE, format = "%Y-%m-%d")
      }
      if ("END_DATE"        %in% colnames(syntheaTable)) {
        syntheaTable$END_DATE         <-
          as.Date(syntheaTable$END_DATE, format = "%Y-%m-%d")
      }
      if ("BIRTHDATE"   %in% colnames(syntheaTable)) {
        syntheaTable$BIRTHDATE    <-
          as.Date(syntheaTable$BIRTHDATE, format = "%Y-%m-%d")
      }
      if ("DEATHDATE"   %in% colnames(syntheaTable)) {
        syntheaTable$DEATHDATE    <-
          as.Date(syntheaTable$DEATHDATE, format = "%Y-%m-%d")
      }
      if ("CODE"        %in% colnames(syntheaTable)) {
        syntheaTable$CODE         <- as.character(syntheaTable$CODE)
      }
      if ("REASONCODE"  %in% colnames(syntheaTable)) {
        syntheaTable$REASONCODE   <-
          as.character(syntheaTable$REASONCODE)
      }
      if ("PHONE"       %in% colnames(syntheaTable)) {
        syntheaTable$PHONE        <-
          as.character(syntheaTable$PHONE)
      }
      if ("UTILIZATION" %in% colnames(syntheaTable)) {
        syntheaTable$UTILIZATION  <-
          as.numeric(syntheaTable$UTILIZATION)
      }

      suppressWarnings({
        DatabaseConnector::insertTable(
          conn,
          tableName = paste0(syntheaSchema, ".", strsplit(csv, "[.]")[[1]][1]),
          data = as.data.frame(syntheaTable),
          dropTableIfExists = FALSE,
          createTable = FALSE,
          bulkLoad = bulkLoad,
          progressBar = TRUE
        )
      })
    }

    on.exit(DatabaseConnector::disconnect(conn))

  }
