#' @title Drop Synthea Tables.
#'
#' @description This function drops all Synthea tables.
#'
#' @usage DropSyntheaTables(connectionDetails, syntheaSchema, syntheaVersion)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#'
#' @param syntheaSchema  The name of the database schema that contains the Synthea
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'synthea_instance.dbo'.
#' @param syntheaVersion The version of Synthea used to generate the csv files.  Currently "2.6.1" is supported.
#'
#'@export


DropSyntheaTables <- function (connectionDetails, syntheaSchema, syntheaVersion)
{

	if (syntheaVersion == "2.6.1")
		sqlFilePath <- "synthea_version/v261"
	else 
		stop("Invalid synthea version specified.  Version 2.6.1 is currenty supported")

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
