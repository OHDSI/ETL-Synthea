#' @title Create Common Data Model Tables.
#'
#' @description This function creates the all the required tables for the CDM.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the CDM database schema.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param cdmVersion Your CDM version.  Currently "5.3" and "5.4" are supported.
#' @param outputFolder Location of the SQL scripts if sqlOnly = TRUE. Default is NULL.
#' @param sqlOnly A boolean that determines whether or not to perform the load or generate SQL scripts. Default is FALSE.
#'
#' @details This function creates all the tables in a CDM by calling \code{CommonDataModel::executeDdl()}.
#'          Supported CDM versions and db dialects are determined by \code{CommonDataModel::listSupportedVersions()}
#'          and \code{CommonDataModel::listSupportedDialects()}, respectively.
#'
#'@export


CreateCDMTables <- function (connectionDetails,cdmSchema,cdmVersion,outputFolder = NULL,sqlOnly = FALSE)
{

	if (!sqlOnly) {
		CommonDataModel::executeDdl(
		connectionDetails = connectionDetails,
		cdmVersion        = cdmVersion,
		cdmDatabaseSchema = cdmSchema,
		executeDdl        = TRUE,
		executePrimaryKey = TRUE,
		executeForeignKey = FALSE) # False for now due to bug: https://github.com/OHDSI/CommonDataModel/issues/452

	} else {

		if (is.null(outputFolder)) {
			stop("Must specify an outputFolder location when using sqlOnly = TRUE")
		}
		if (!dir.exists(outputFolder)) {
			dir.create(outputFolder)
		}

		CommonDataModel::writeDdl(
			targetDialect     = connectionDetails$dbms,
			cdmVersion        = cdmVersion,
			outputfolder      = outputFolder,
			cdmDatabaseSchema = cdmSchema)
		CommonDataModel::writePrimaryKeys(
			targetDialect     = connectionDetails$dbms,
			cdmVersion        = cdmVersion,
			outputfolder      = outputfolder,
			cdmDatabaseSchema = cdmSchema)
		CommonDataModel::writeForeignKeys(
			targetDialect     = connectionDetails$dbms,
			cdmVersion        = cdmVersion,
			outputfolder      = outputFolder,
			cdmDatabaseSchema = cdmSchema)
		CommonDataModel::writeIndex(
			targetDialect     = connectionDetails$dbms,
			cdmVersion        = cdmVersion,
			outputfolder      = outputFolder,
			cdmDatabaseSchema = cdmSchema)
	}
}
