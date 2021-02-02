# Utility to Load Synthea CSV data to OMOP CDM
## Currently supports CDM v5.3 and v6.0 

Follow the steps on the [synthea wiki](https://github.com/synthetichealth/synthea/wiki) to run the program and generate the files. This builder works off of the csv files, not the fhir files. To do this the `exporter.csv.export` option in the `./src/main/resources/synthea.properties` file needs to be set to TRUE.

### Step by Step Example

```
 devtools::install_github("OHDSI/ETL-Synthea")

 library(ETLSyntheaBuilder)

 # We are loading a version 5.3 CDM into a local PostgreSQL database called "synthea10".  
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
                                                                                
ETLSyntheaBuilder::CreateCDMTables(connectionDetails = cd, cdmSchema = "cdm_synthea10", cdmVersion = "5.3")
                                     
ETLSyntheaBuilder::CreateSyntheaTables(connectionDetails = cd, syntheaSchema = "native", cdmVersion = "5.3")
                                       
ETLSyntheaBuilder::LoadSyntheaTables(connectionDetails = cd,
									 syntheaSchema = "native",
									 syntheaFileLoc = "/tmp/synthea/output/csv")
                                     
ETLSyntheaBuilder::LoadVocabFromCsv(connectionDetails = cd, 
                                    cdmSchema = "cdm_synthea10",
									vocabFileLoc = "/tmp/Vocabulary_20181119")
                                    
ETLSyntheaBuilder::LoadEventTables(connectionDetails = cd, 
                                   cdmDatabaseSchema = "cdm_synthea10", 
                                   syntheaDatabaseSchema = "native",
								   cdmVersion = "5.3")
```

### Simulating Data with Synthea
For commented code used to convert the Synthea data see extras/codeToRun.R

For more information on Synthea visit:
https://synthetichealth.github.io/synthea/

Get Synthea from GitHub:
https://github.com/synthetichealth/synthea
