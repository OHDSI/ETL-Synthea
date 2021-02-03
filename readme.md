# Utility to Load Synthea CSV data to OMOP CDM
## Currently supports CDM v5.3.1 and v6.0.0 

Follow the steps on the [synthea wiki](https://github.com/synthetichealth/synthea/wiki) to run the program and generate the files. This builder works off of the csv files, not the fhir files. To do this the `exporter.csv.export` option in the `./src/main/resources/synthea.properties` file needs to be set to TRUE.

### Step by Step Example

```
 devtools::install_github("OHDSI/ETL-Synthea")

 library(ETLSyntheaBuilder)

 # We are loading a version 5.3.1 CDM into a local PostgreSQL database called "synthea10".  
 # The supported Synthea version is 2.6.1
 # The schema to load the Synthea tables is called "native".
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

cdmSchema      <- "cdm_synthea10"
cdmVersion     <- "5.3.1"
syntheaVersion <- "2.6.1"
syntheaSchema  <- "native"
syntheaFileLoc <- "/tmp/synthea/output/csv"
vocabFileLoc   <- "/tmp/Vocabulary_20181119"

ETLSyntheaBuilder::CreateCDMTables(connectionDetails = cd, cdmSchema = cdmSchema, cdmVersion = cdmVersion)
                                     
ETLSyntheaBuilder::CreateSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaVersion = syntheaVersion)
                                       
ETLSyntheaBuilder::LoadSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaFileLoc = syntheaFileLoc)
                                     
ETLSyntheaBuilder::LoadVocabFromCsv(connectionDetails = cd, cdmSchema = cdmSchema, vocabFileLoc = vocabFileLoc)
                                    
ETLSyntheaBuilder::LoadEventTables(connectionDetails = cd, cdmSchema = cdmSchema, syntheaSchema = syntheaSchema, cdmVersion = cdmVersion)

# Optional: Create index and constraint DDL scripts for the rdbms that support them.  Scripts will be written to the "output" directory.
# ETLSyntheaBuilder::CreateCDMIndexAndConstraintScripts(connectionDetails = cd, cdmSchema = cdmSchema, cdmVersion = cdmVersion)

```

### Simulating Data with Synthea
For commented code used to convert the Synthea data see extras/codeToRun.R

For more information on Synthea visit:
https://synthetichealth.github.io/synthea/

Get Synthea from GitHub:
https://github.com/synthetichealth/synthea
