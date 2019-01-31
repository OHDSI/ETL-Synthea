# Utility to Load Synthea CSV data to OMOP CDM
## Currently supports CDM V5.3

### Scripted Execution
Use the bulk-load script.

### Step by Step Example
  1. Obtain CDM V5.3 Vocabulary CSV files.

  2. Generate Synthea CSV files via the Synthea command line utility ./run_synthea. 
  
     (Details found here: https://github.com/synthetichealth/synthea/wiki/Basic-Setup-and-Running)

  3. Load and convert Synthea CSV data to an OMOP CDM using ./bulk-load:

   ./bulk-load synthea10 native cdm_synthea10 postgres lollipop /tmp/synthea/output/csv /tmp/Vocabulary_20181119

 The example above loads into a PostgreSQL database called synthea10.  The schema to load the Synthea tables is native.
 The schema to load the Vocabulary tables is cdm_synthea10.  The username and pw are postgres and lollipop.
 The Synthea and Vocabulary CSV files are located in /tmp/synthea/output/csv and /tmp/Vocabulary_20181119, respectively.


### Simulating Data with Synthea

For more information on Synthea visit:
https://synthetichealth.github.io/synthea/

Get Synthea from GitHub:
https://github.com/synthetichealth/synthea
