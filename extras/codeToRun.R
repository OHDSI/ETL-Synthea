######################################
## Synthea OMOP Builder code to run ##
######################################

library("ETLSyntheaBuilder")
library("SqlRender")
library("DatabaseConnector")

## Create connectionDetails object to postgres (or other db)

connectionDetails <- DatabaseConnector::createConnectionDetails(
									   dbms="postgresql",
										 server=Sys.getenv("postgresOhdsiServer"),
										 user=Sys.getenv("postgresOhdsiUser"),
										 password= Sys.getenv("postgresOhdsiPw"),
										 port=5432
)

## Assuming the raw data and vocabulary has been loaded, this will run the synthea cdm sql builder

CreateEventTables(connectionDetails, "cdm_lauren")

CreateVocabMapTables(connectionDetails, "cdm_lauren")

CreateVisitRollupTables(connectionDetails,
												cdmDatabaseSchema = "cdm_lauren",
												syntheaDatabaseSchema = "raw_lauren"
												)

LoadCDMTables(connectionDetails,
							cdmDatabaseSchema = "cdm_lauren",
							syntheaDatabaseSchema = "raw_lauren",
							vocabDatabaseSchema = "cdm_synthea"
							)
