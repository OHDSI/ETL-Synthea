# Utility to Load Synthea CSV data to OMOP CDM
## Currently supports CDM V5.3

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

ETLSyntheaBuilder::DropVocabTables(cd,"cdm_synthea10")
ETLSyntheaBuilder::DropEventTables(cd,"cdm_synthea10")
ETLSyntheaBuilder::DropSyntheaTables(cd,"native")
ETLSyntheaBuilder::DropMapAndRollupTables (cd,"cdm_synthea10")
ETLSyntheaBuilder::CreateVocabTables(cd,"cdm_synthea10")
ETLSyntheaBuilder::CreateEventTables(cd,"cdm_synthea10")
ETLSyntheaBuilder::CreateSyntheaTables(cd,"native")
ETLSyntheaBuilder::LoadSyntheaTables(cd,"native","/tmp/synthea/output/csv")
ETLSyntheaBuilder::LoadVocabFromCsv(cd,"cdm_synthea10","/tmp/Vocabulary_20181119")
ETLSyntheaBuilder::CreateVocabMapTables(cd,"cdm_synthea10")
ETLSyntheaBuilder::CreateVisitRollupTables(cd,"cdm_synthea10","native")
ETLSyntheaBuilder::LoadEventTables(cd,"cdm_synthea10","native")
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

For more information on Synthea visit:
https://synthetichealth.github.io/synthea/

Get Synthea from GitHub:
https://github.com/synthetichealth/synthea
