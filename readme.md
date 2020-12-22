# Utility to Load Synthea CSV data to OMOP CDM
## Currently supports CDM v6.0 (see branch [v5.3.1-updates](https://github.com/OHDSI/ETL-Synthea/tree/v5.3.1-updates) for CDM v5.3 support)

Follow the steps on the [synthea wiki](https://github.com/synthetichealth/synthea/wiki) to run the program and generate the files. This builder works off of the csv files, not the fhir files. To do this the `exporter.csv.export` option in the `./src/main/resources/synthea.properties` file needs to be set to TRUE.

### Step by Step Example (R package)

```
 devtools::install_github("OHDSI/ETL-Synthea")

 library(ETLSyntheaBuilder)

 # We are loading into a local PostgreSQL database called "synthea10".  
 # The schema to load the Synthea tables is "native".
 # The schema to load the Vocabulary and CDM tables is "cdm_synthea10".  
 # The username and pw are "postgres" and "lollipop".
 # The Synthea and Vocabulary CSV files are located in /tmp/synthea/output/csv and /tmp/Vocabulary_20181119, respectively.
 
 cd <- DatabaseConnector::createConnectionDetails(
  dbms     = "postgresql", 
  server   = "localhost/synthea10", 
  user     = "postgres", 
  password = "lollipop", 
  port     = 5432
)

ETLSyntheaBuilder::DropVocabTables(connectionDetails = cd,
                                   vocabDatabaseSchema = "cdm_synthea10")

ETLSyntheaBuilder::DropEventTables(connectionDetails = cd,
                                   cdmDatabaseSchema = "cdm_synthea10")
                                   
ETLSyntheaBuilder::DropSyntheaTables(connectionDetails = cd, 
                                     syntheaDatabaseSchema = "native")
                                     
ETLSyntheaBuilder::DropMapAndRollupTables (connectionDetails = cd, 
                                           cdmDatabaseSchema = "cdm_synthea10")
                                           
ETLSyntheaBuilder::CreateVocabTables(connectionDetails = cd, 
                                     vocabDatabaseSchema = "cdm_synthea10")
                                     
ETLSyntheaBuilder::CreateEventTables(connectionDetails = cd, 
                                     cdmDatabaseSchema = "cdm_synthea10")
                                     
ETLSyntheaBuilder::CreateSyntheaTables(connectionDetails = cd, 
                                       syntheaDatabaseSchema = "native")
                                       
ETLSyntheaBuilder::LoadSyntheaTables(connectionDetails = cd, 
                                     syntheaDatabaseSchema = "native", 
                                     syntheaFileLoc = "/tmp/synthea/output/csv")
                                     
ETLSyntheaBuilder::LoadVocabFromCsv(connectionDetails = cd, 
                                    vocabDatabaseSchema = "cdm_synthea10", 
                                    vocabFileLoc = "/tmp/Vocabulary_20181119")
                                    
ETLSyntheaBuilder::CreateVocabMapTables(connectionDetails = cd, 
                                        cdmDatabaseSchema = "cdm_synthea10")
                                        
ETLSyntheaBuilder::CreateVisitRollupTables(connectionDetails = cd, 
                                           cdmDatabaseSchema = "cdm_synthea10", 
                                           syntheaDatabaseSchema = "native")

ETLSyntheaBuilder::LoadEventTables(connectionDetails = cd, 
                                   cdmDatabaseSchema = "cdm_synthea10", 
                                   syntheaDatabaseSchema = "native")
```

### Docker usage

The docker image associated with this repo can be used to run ETL-Synthea without installing any dependencies except Docker. It requires a Synthea CSV dataset to be generated (see links below). It also requires a schema in the target database where a OHDSI vocabulary is loaded.

```
docker build -t ohdsi/etl-synthea .
docker run --rm \
  -e SYNTHEA_DB_URI="postgres://myuser:mypassword@host:port/dbname" \
  -e SYNTHEA_RAW_SCHEMA=native \
  -e SYNTHEA_CDM_SCHEMA=cdm_synthea \
  -e SYNTHEA_VOCAB_SCHEMA=vocab \
  -v /path/to/synthea/csv:/data/synthea/csv
  ohdsi/etl-synthea
```

### Simulating Data with Synthea
For commented code used to convert the Synthea data see extras/codeToRun.R

For more information on Synthea visit:
https://synthetichealth.github.io/synthea/

Get Synthea from GitHub:
https://github.com/synthetichealth/synthea
