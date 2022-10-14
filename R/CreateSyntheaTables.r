#' @title Create Synthea Tables.
#'
#' @description This function creates all Synthea tables.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param syntheaSchema  The name of the database schema that will contain the Synthea
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specify both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param syntheaVersion The version of Synthea used to generate the csv files.
#'                       Currently "2.7.0" and "3.0.0" are is supported.
#'
#'@export


CreateSyntheaTables <- function (connectionDetails, syntheaSchema, syntheaVersion = "2.7.0")
{

    if (syntheaVersion == "2.7.0")
        sqlFilePath <- "synthea_version/v270"
    else if (syntheaVersion == "3.0.0")
        sqlFilePath <- "synthea_version/v300"
    else
        stop("Invalid synthea version specified. Currently \"2.7.0\" and \"3.0.0\" are supported.")

    sqlFilename =  paste0(sqlFilePath,"/","create_synthea_tables.sql")

    translatedSql <- SqlRender::loadRenderTranslateSql(
	      sqlFilename     = sqlFilename,
	      packageName     = "ETLSyntheaBuilder",
	      dbms            = connectionDetails$dbms,
	      synthea_schema  = syntheaSchema
    )

    writeLines(paste0("Running ", sqlFilename))

    conn <- DatabaseConnector::connect(connectionDetails)

    DatabaseConnector::executeSql(conn, translatedSql)

    on.exit(DatabaseConnector::disconnect(conn))

}
