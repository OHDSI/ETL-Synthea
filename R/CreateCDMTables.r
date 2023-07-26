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
#' @param createIndices A boolean that determines whether or not to create indices on CDM tables after they are created.
#' @param sqlOnly A boolean that determines whether to create the tables or generate SQL scripts. Default is FALSE.
#'
#' @details This function creates all the tables in a CDM by calling \code{CommonDataModel::executeDdl()}.
#'          Indices, if created, come from \code{CommonDataModel::writeIndex()}.
#'          Supported CDM versions and db dialects are determined by \code{CommonDataModel::listSupportedVersions()}
#'          and \code{CommonDataModel::listSupportedDialects()}, respectively.
#'
#'@export


CreateCDMTables <-
  function(connectionDetails,
           cdmSchema,
           cdmVersion,
           outputFolder = NULL,
		   createIndices = FALSE,
           sqlOnly = FALSE)
  {
    if (!sqlOnly) {
	
		print("Creating CDM Tables....")
		
		CommonDataModel::executeDdl(
			connectionDetails = connectionDetails,
			cdmVersion        = cdmVersion,
			cdmDatabaseSchema = cdmSchema,
			executeDdl        = TRUE,
			executePrimaryKey = TRUE,
			executeForeignKey = FALSE
		) # False for now due to bug: https://github.com/OHDSI/CommonDataModel/issues/452

		print("CDM Tables Created.")
				
		if (createIndices) {
		
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
		}
	
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
        cdmDatabaseSchema = cdmSchema
      )
      CommonDataModel::writePrimaryKeys(
        targetDialect     = connectionDetails$dbms,
        cdmVersion        = cdmVersion,
        outputfolder      = outputFolder,
        cdmDatabaseSchema = cdmSchema
      )
      CommonDataModel::writeForeignKeys(
        targetDialect     = connectionDetails$dbms,
        cdmVersion        = cdmVersion,
        outputfolder      = outputFolder,
        cdmDatabaseSchema = cdmSchema
      )
      CommonDataModel::writeIndex(
        targetDialect     = connectionDetails$dbms,
        cdmVersion        = cdmVersion,
        outputfolder      = outputFolder,
        cdmDatabaseSchema = cdmSchema
      )
    }
  }
