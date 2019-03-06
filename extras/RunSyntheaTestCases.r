######################################
## Synthea OMOP Builder test cases  ##
######################################

library("DatabaseConnector")
library("SqlRender")

## STEP 0: Initialize an empty schema if necessary

## STEP 1: Set database variables for testing. Be sure to update the config.csv file first

config <- read.csv("inst/settings/config.csv",as.is=TRUE)[1,]

dbms = config$dbms
user = config$user
pw = config$pw
server = config$server
port = config$port
raw_db = config$raw_db
raw_schema = config$raw
cdm_db = config$cdm_db
cdm_schema = config$cdm

## STEP 2: Update the files in the R folder with any test cases and install/restart the R project. Then run the functions to create the tests.

initFramework()
createPersonTests()
createObservationPeriodTests()
createConditionOccurrenceTests()
createObservationTests()
createDrugExposureTests()

## STEP 3: Create insert and test sql statements

cat(file="inst/sql/insert.sql", paste(generateInsertSql(databaseSchema = raw_schema), collapse="\n"))

cat(file="inst/sql/test.sql", paste(generateTestSql(databaseSchema = paste(cdm_db,cdm_schema,sep=".")), collapse="\n"))

## STEP 4: Connect and put the test cases in the database specified in step 1

connectionDetails <- createConnectionDetails(dbms = dbms,
																						 server = server,
																						 schema = raw_db,
																						 user = user,
																						 password = pw
)

conn <- connect(connectionDetails)

insertSql <- readSql("inst/sql/insert.sql")
renderedSql <- renderSql(sql = insertSql)$sql
executeSql(conn, renderedSql)

# STEP 5: Take a break, run builder externally
#               .--.
#              (    )
#                 _/
#  ,   ,         |
#  |\_/|_________|
#  |+ +          o
#  |_^_|-||_____||
#    U   ||     ||
#       (_|    (_|

testResults <- data.frame("id"=numeric(0), "description"=character(0),
													"test"=character(0), "source_pid"=numeric(0),
													"cdm_pid"=numeric(0), "status"=character(0)
													, stringsAsFactors=FALSE)

connectionDetails <- createConnectionDetails(dbms = dbms,
																						 server = server,
																						 schema = raw_db,
																						 user = user,
																						 password = pw
)

conn <- connect(connectionDetails)

insertSql <- readSql("inst/sql/test.sql")
renderedSql <- renderSql(sql = insertSql)$sql;
executeSql(conn, renderedSql)
testResults <- rbind(testResults,querySql(conn,
																					paste0("select * from ", paste0(cdm_db,".",cdm_schema,".test_results"))))

DatabaseConnector::disconnect(conn)
