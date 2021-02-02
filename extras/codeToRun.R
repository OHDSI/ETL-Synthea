######################################
## Synthea OMOP Builder code to run ##
######################################

library("ETLSyntheaBuilder")
library("SqlRender")
library("DatabaseConnector")

## Create connectionDetails object to postgres (or other db)

cd <- DatabaseConnector::createConnectionDetails(
  dbms     = "postgresql",
  server   = "localhost/synthea10", #This should be your server location. If it is on your local machine, change 'cdm_v6_testing' with the name of the database you chose
  user     = "postgres", #Your user name. If you are the owner this will most likely be 'postgres'
  password = "lollipop", #Your password
  port     = 5432 #The port number. You can find this by right-clicking on the server and choosing properties
)

## Create all CDM tables (version 5.3)

ETLSyntheaBuilder::CreateCDMTables(connectionDetails = cd, cdmSchema = "cdm_synthea10", cdmVersion = "5.3")

## Create all synthea tables

ETLSyntheaBuilder::CreateSyntheaTables(connectionDetails = cd, syntheaSchema = "native")

## Load Synthea tables from a local file system

ETLSyntheaBuilder::LoadSyntheaTables(connectionDetails = cd,
                                     syntheaSchema = "native",
									                   syntheaFileLoc = "/tmp/synthea/output/csv")

## Load the Vocabulary from a local file system

ETLSyntheaBuilder::LoadVocabFromCsv(connectionDetails = cd,
                                    cdmSchema = "cdm_synthea10",
									                  vocabFileLoc = "/tmp/Vocabulary_20181119")

## Alternatively, load the Vocabulary from another schema that already has a Vocabulary loaded
# ETLSyntheaBuilder::LoadVocabFromSchema(connectionDetails = cd,
#                                        cdmSourceSchema = "some_other_cdm_schema",
# 	  								                   cdmTargetSchema = "cdm_synthea10")

## Assuming the raw data and vocabulary has been loaded, this will run the synthea cdm sql builder

ETLSyntheaBuilder::LoadEventTables(connectionDetails = cd,
                                   cdmSchema = "cdm_synthea10",
                                   syntheaSchema = "native",
								                   cdmVersion = "5.3")
