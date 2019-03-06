# Utility to Load Synthea CSV data to OMOP CDM
## Currently supports CDM V5.3

### Scripted Execution
Use the bulk-load script (Linux), R package (within an R session), or WindowsLoader.r (Windows command line).

### Step by Step Example (shell script)
  1. Obtain CDM V5.3 Vocabulary CSV files.

  2. Generate Synthea CSV files via the Synthea command line utility ./run_synthea. 
  
     (Details found here: https://github.com/synthetichealth/synthea/wiki/Basic-Setup-and-Running)

  3. Load and convert Synthea CSV data to an OMOP CDM using ./bulk-load:
```
./bulk-load synthea10 native cdm_synthea10 postgres lollipop /tmp/synthea/output/csv /tmp/Vocabulary_20181119
```
 The example above loads into a PostgreSQL database called synthea10.  The schema to load the Synthea tables is native.
 The schema to load the Vocabulary tables is cdm_synthea10.  The username and pw are postgres and lollipop.
 The Synthea and Vocabulary CSV files are located in /tmp/synthea/output/csv and /tmp/Vocabulary_20181119, respectively.

### Step by Step Example (R package)

```
 devtools::install_github("OHDSI/ETL-Synthea")

 library(ETLSyntheaBuilder)

 # Similar to the bulk-load example above, we are loading into a local PostgreSQL database called synthea10.  
 # The schema to load the Synthea tables is native.
 # The schema to load the Vocabulary and CDM tables is cdm_synthea10.  
 # The username and pw are postgres and lollipop.
 # The Synthea and Vocabulary CSV files are located in /tmp/synthea/output/csv and /tmp/Vocabulary_20181119, respectively.
 
 cd <- DatabaseConnector::createConnectionDetails(
  dbms     = "postgresql", 
  server   = "localhost/synthea10", 
  user     = "postgres", 
  password = "lollipop", 
  port     = 5432
)

ETLSyntheaBuilder::DropVocabTables(cd,"cdm_synthea10")
ETLSyntheaBuilder::DropEventTables(cd,"cdm_synthea10")
ETLSyntheaBuilder::DropSyntheaTables(cd,"native")
ETLSyntheaBuilder::CreateVocabTables(cd,"cdm_synthea10")
ETLSyntheaBuilder::CreateEventTables(cd,"cdm_synthea10")
ETLSyntheaBuilder::CreateSyntheaTables(cd,"native")
ETLSyntheaBuilder::LoadSyntheaTables(cd,"native","/tmp/synthea/output/csv")
ETLSyntheaBuilder::LoadVocabTables(cd,"cdm_synthea10","/tmp/Vocabulary_20181119")
ETLSyntheaBuilder::CreateVocabMapTables(cd,"cdm_synthea10")
ETLSyntheaBuilder::CreateVisitRollupTables(cd,"cdm_synthea10","native")
ETLSyntheaBuilder::LoadEventTables(cd,"cdm_synthea10","native")
```

### Step by Step Example (Windows command line)
  1. Obtain CDM V5.3 Vocabulary CSV files.

  2. Generate Synthea CSV files via the Synthea command line utility ./run_synthea. 
  
     (Details found here: https://github.com/synthetichealth/synthea/wiki/Basic-Setup-and-Running)
     
  3. Install R and include Rscript.exe in your PATH.

  3. Load and convert Synthea CSV data to an OMOP CDM using Rscript.exe and WindowsLoader.r:
```
   C:> Rscript WindowsLoader.r postgresql localhost synthea10 native cdm_synthea10 postgres lollipop D:\Apps\Git\synthea\output\csv D:\synthea\V2\csv\vocabulary 5432
```
 The example above loads into a local PostgreSQL database called synthea10 listening on port 5432 (the port is the last parameter).  
 The schema to load the Synthea tables is native.
 The schema to load the Vocabulary tables is cdm_synthea10.  The username and pw are postgres and lollipop.
 The Synthea and Vocabulary CSV files are located in D:\Apps\Git\synthea\output\csv and D:\synthea\V2\csv\vocabulary, respectively.

### Simulating Data with Synthea

For more information on Synthea visit:
https://synthetichealth.github.io/synthea/

Get Synthea from GitHub:
https://github.com/synthetichealth/synthea
