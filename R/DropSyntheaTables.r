#' @title Drop Synthea Tables.
#'
#' @description This function drops all Synthea tables.
#'
#' @usage DropSyntheaTables(connectionDetails, syntheaSchema, cdmVersion)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#'
#' @param syntheaDatabaseSchema  The name of the database schema that contains the Synthea
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param cdmVersion The version of the CDM into which the synthea will be loaded.  Currently "5.3" and "6.0" are supported.
#'
#'@export


DropSyntheaTables <- function (connectionDetails, syntheaSchema, cdmVersion)
{

	if (cdmVersion == "5.3")
		sqlFilePath <- "v53"
	else if (cdmVersion == "6.0")
		sqlFilePath <- "v60"

    translatedSql <- SqlRender::loadRenderTranslateSql(
		sqlFilename     = paste0(sqlFilePath,"/","drop_synthea_tables.sql"),
		packageName     = "ETLSyntheaBuilder",
		dbms            = connectionDetails$dbms,
		synthea_schema  = syntheaSchema
	)

    writeLines("Running drop_synthea_tables.sql")

	conn <- DatabaseConnector::connect(connectionDetails)

    DatabaseConnector::dbExecute(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE)

    on.exit(DatabaseConnector::disconnect(conn))

}
