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

cdmSchema      <- "cdm_synthea10"
cdmVersion     <- "5.3.1"
syntheaVersion <- "2.6.1"
syntheaSchema  <- "native"
syntheaFileLoc <- "/tmp/synthea/output/csv"
vocabFileLoc   <- "/tmp/Vocabulary_20181119"

## Create all CDM tables (version 5.3.1)

ETLSyntheaBuilder::CreateCDMTables(connectionDetails = cd, cdmSchema = cdmSchema, cdmVersion = cdmVersion)

## Create all synthea tables

ETLSyntheaBuilder::CreateSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaVersion = syntheaVersion)

## Load Synthea tables from a local file system

ETLSyntheaBuilder::LoadSyntheaTables(connectionDetails = cd,syntheaSchema = syntheaSchema,syntheaFileLoc = syntheaFileLoc)

## Load the Vocabulary from a local file system

ETLSyntheaBuilder::LoadVocabFromCsv(connectionDetails = cd,cdmSchema = cdmSchema,vocabFileLoc = vocabFileLoc)

## Alternatively, load the Vocabulary from another schema that already has a Vocabulary loaded
# ETLSyntheaBuilder::LoadVocabFromSchema(connectionDetails = cd,cdmSourceSchema = "some_other_cdm_schema",cdmTargetSchema = cdmSchema)

## Assuming the raw data and vocabulary has been loaded, this will run the synthea cdm sql builder

ETLSyntheaBuilder::LoadEventTables(connectionDetails = cd,cdmSchema = cdmSchema,syntheaSchema = syntheaSchema,cdmVersion = cdmVersion)
