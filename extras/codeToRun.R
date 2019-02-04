######################################
## Synthea OMOP Builder code to run ##
######################################

## Create connectionDetails object to postgres (or other db)

connectionDetails <- DatabaseConnector::createConnectionDetails(
									   dbms="postgresql",
										 server=Sys.getenv("postgresServer"),
										 user=Sys.getenv("postgresOhdsiUser"),
										 password= Sys.getenv("postgresOhdsiPw"),
										 port=5432
)

## Assuming the raw data and vocabulary has been loaded, this will run the synthea cdm sql builder

CreateVocabMapTables(connectionDetails, "cdm_synthea")
CreateCDMTables(connectionDetails, "cdm_synthea")
CreateVisitRollupTables(connectionDetails, "cdm_synthea", "raw_synthea")
LoadCDMTables(connectionDetails, "cdm_synthea", "raw_synthea")
