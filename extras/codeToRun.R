######################################
## Synthea OMOP Builder code to run ##
######################################

## Create connectionDetails object to postgres (or other db)

connectionDetails <- DatabaseConnector::createConnectionDetails(
									   dbms="postgresql",
										 server="pgsql03.cqnqzwtn5s1q.us-east-1.rds.amazonaws.com/etl",
										 user=Sys.getenv("postgresOhdsiUser"),
										 password= Sys.getenv("postgresOhdsiPw"),
										 port=5432
)

## Assuming the raw data and vocabulary has been loaded, this will run the synthea cdm sql builder

CreateCDMTables(connectionDetails, "cdm_lauren", vocabTableCreate = FALSE)
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
