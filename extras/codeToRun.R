######################################
## Synthea OMOP Builder code to run ##
######################################

library("ETLSyntheaBuilder")
library("SqlRender")
library("DatabaseConnector")

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms     = "your dbms",
  server   = "your server",
  user     = "your user name",
  password = Sys.getenv("DATABASE_PASSWORD"),
  port     = 9999,  # port to connect to your db
  pathToDriver = "path to jdbc driver for db connector"
)

# Create a v5.4 CDM and a v2.7.0 synthea database, in specified locations using specified files.
# Update accordingly.

cdmVersion        <- "5.4"
cdmDatabaseSchema <- "cdm_synthea_v540"
syntheaSchema     <- "synthea_v270"
syntheaFileLoc    <- "D:/Apps/Git/synthea/output/csv"
vocabFileLoc      <- "D:/Apps/Git/vocab/csv"
syntheaVersion    <- "2.7.0"

# Create CDM tables
ETLSyntheaBuilder::CreateCDMTables(connectionDetails,cdmDatabaseSchema,cdmVersion)
# Create synthea tables
ETLSyntheaBuilder::CreateSyntheaTables(connectionDetails,syntheaSchema, syntheaVersion)
# Populate synthea tables
ETLSyntheaBuilder::LoadSyntheaTables(connectionDetails,syntheaSchema,syntheaFileLoc)
# Populate vocabulary tables
ETLSyntheaBuilder::LoadVocabFromCsv(connectionDetails,cdmDatabaseSchema,vocabFileLoc)
# Populate event tables
ETLSyntheaBuilder::LoadEventTables(connectionDetails,cdmDatabaseSchema,syntheaSchema,cdmVersion,syntheaVersion)
