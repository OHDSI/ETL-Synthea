######################################
## Synthea OMOP Builder code to run ##
######################################

library("ETLSyntheaBuilder")
library("SqlRender")
library("DatabaseConnector")

## Create connectionDetails object to postgres (or other db)

connectionDetails <- DatabaseConnector::createConnectionDetails(
									   dbms="postgresql",
										 server="localhost/synthea10",
										 user=Sys.getenv("postgresEC2User"),
										 password= Sys.getenv("postgresEC2Pw"),
										 port=5433
)

## Assuming the raw data and vocabulary has been loaded, this will run the synthea cdm sql builder

CreateEventTables(connectionDetails, "cdm_synthea10")
CreateVocabMapTables(connectionDetails, "cdm_synthea10")

CreateVisitRollupTables(connectionDetails,
												cdmDatabaseSchema = "cdm_lauren",
												syntheaDatabaseSchema = "raw_lauren"
												)

LoadCDMTables(connectionDetails,
							cdmDatabaseSchema = "cdm_lauren",
							syntheaDatabaseSchema = "raw_lauren",
							vocabDatabaseSchema = "cdm_synthea"
							)
