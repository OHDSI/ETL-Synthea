#' @title Create Indices on Common Data Model Tables.
#'
#' @description This function creates indices for the tables in the CDM.
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param cdmSchema  The name of the CDM database schema.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#' @param cdmVersion Your CDM version.  Currently "5.3" and "5.4" are supported.
#' @param outputFolder Location of the SQL scripts if sqlOnly = TRUE. Default is NULL.
#' @param sqlOnly A boolean that determines whether to create the indices or generate a SQL scripts Default is FALSE.
#'
#' @details This function creates the indices specified by the function \code{CommonDataModel::writeIndex()}.
#'          Supported CDM versions and db dialects are determined by \code{CommonDataModel::listSupportedVersions()}
#'          and \code{CommonDataModel::listSupportedDialects()}, respectively.
#'
#'@export


CreateCDMIndices <-
  function(connectionDetails,
           cdmSchema,
           cdmVersion,
           outputFolder = NULL,
           sqlOnly = FALSE)
{
    if (!sqlOnly) {
		
		print("Creating Indices on CDM Tables....")

		indexSQLFile <- CommonDataModel::writeIndex(
		targetDialect     = connectionDetails$dbms,
		cdmVersion        = cdmVersion,
		cdmDatabaseSchema = cdmSchema,
		outputfolder      = tempdir())

		indexDDL <- SqlRender::readSql(paste0(tempdir(),"/",indexSQLFile))
		conn <- DatabaseConnector::connect(connectionDetails)
		DatabaseConnector::executeSql(conn,indexDDL)
		DatabaseConnector::disconnect(conn)
		print("Index Creation Complete.")
	
    } else {
      if (is.null(outputFolder)) {
        stop("Must specify an outputFolder location when using sqlOnly = TRUE")
      }
      if (!dir.exists(outputFolder)) {
        dir.create(outputFolder)
      }
      CommonDataModel::writeIndex(
        targetDialect     = connectionDetails$dbms,
        cdmVersion        = cdmVersion,
        outputfolder      = outputFolder,
        cdmDatabaseSchema = cdmSchema
      )
    }
}
