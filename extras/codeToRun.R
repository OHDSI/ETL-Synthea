######################################
## Synthea OMOP Builder code to run ##
######################################

library("ETLSyntheaBuilder")
library("SqlRender")
library("DatabaseConnector")

## Create connectionDetails object to postgres (or other db)

connectionDetails <- DatabaseConnector::createConnectionDetails(
									   dbms="postgresql",
										 server="localhost/cdm_v6_testing", #This should be your server location. If it is on your local machine, change 'cdm_v6_testing' with the name of the database you chose
										 user="postgres", #Your user name. If you are the owner this will most likely be 'postgres'
										 password= "lollipop", #Your password
										 port=5433 #The port number. You can find this by right-clicking on the server and choosing properties
)

## This section is meant to import the native synthea files

ETLSyntheaBuilder::CreateSyntheaTables(connectionDetails = connectionDetails,
																			 syntheaDatabaseSchema = "native") #Put the name you gave to the schema you plan to use for the native data

ETLSyntheaBuilder::LoadSyntheaTables(connectionDetails = connectionDetails,
																		 syntheaDatabaseSchema = "native",
																		 syntheaFileLoc = "S:/Git/GitHub/synthea/output/csv") #Put the location to the synthea files on your machine. They need to be in a csv file format

## This will create and load the vocabulary tables.

ETLSyntheaBuilder::CreateVocabTables(connectionDetails = connectionDetails,
																		 vocabDatabaseSchema = "cdm_synthea") #Put the name of the schema where you want to create the vocab tables

ETLSyntheaBuilder::LoadVocabFromCsv(connectionDetail = connectionDetails,
																		connectionDetails = "cdm_synthea",
																		vocabFileLoc = "S:/Vocabulary_20190625") #Put the location to the vocab files on your machine. These can be downloaded from Athena.ohdsi.org


## Assuming the raw data and vocabulary has been loaded, this will run the synthea cdm sql builder

ETLSyntheaBuilder::CreateVocabMapTables(connectionDetails = connectionDetails,
																				cdmDatabaseSchema = "cdm_synthea")

ETLSyntheaBuilder::CreateEventTables(connectionDetails = connectionDetails,
																		 cdmDatabaseSchema = "cdm_synthea")

ETLSyntheaBuilder::CreateVisitRollupTables(connectionDetails,
																					 cdmDatabaseSchema = "cdm_synthea",
																					 syntheaDatabaseSchema = "native"
																					 )

ETLSyntheaBuilder::LoadEventTables(connectionDetails,
																	 cdmDatabaseSchema = "cdm_synthea",
																	 syntheaDatabaseSchema = "native",
																	 vocabDatabaseSchema = "cdm_synthea"
																	 )
