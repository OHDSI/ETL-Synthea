######################################
## Synthea OMOP Builder test cases  ##
######################################

library("DatabaseConnector")
library("SqlRender")
library("ETLSyntheaBuilder")

connectionDetails <- DatabaseConnector::createConnectionDetails(
	dbms="postgresql",
	server="localhost/synthea10",
	user=Sys.getenv("postgresEC2User"),
	password= Sys.getenv("postgresEC2Pw"),
	port=5433
)

## STEP 0: Initialize an empty schema (if necessary)
DropSyntheaTables(connectionDetails, "synthea_test")
CreateSyntheaTables(connectionDetails, "synthea_test") #creating empty synthea tables
CreateEventTables(connectionDetails, "synthea_test") #creating empty cdm tables

## STEP 1: Update the files in the R folder with any test cases and install/restart the R project. Then run the functions to create the tests.

source("extras/SyntheaTestFramework.r")
source("extras/SupportFunctions.r")

getTests()
initFramework()
createTests()

## STEP 3: Create insert and test sql statements

cat(file="extras/insert.sql", paste(generateInsertSql(databaseSchema = "synthea_test"), collapse="\n"))

cat(file="extras/test.sql", paste(generateTestSql(databaseSchema = paste("synthea_test",sep=".")), collapse="\n"))

## STEP 4: Connect and put the test cases in the database specified in step 1

conn <- connect(connectionDetails)

insertSql <- SqlRender::readSql("extras/insert.sql")
renderedSql <- render(sql = insertSql)
translateSql <- translate(renderedSql, targetDialect = "postgresql")
executeSql(conn, translateSql)

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

insertSql <- readSql("extras/test.sql")
renderedSql <- renderSql(sql = insertSql)$sql;
executeSql(conn, renderedSql)
testResults <- rbind(testResults,querySql(conn,
																					paste0("select * from ", paste0(cdm_db,".",cdm_schema,".test_results"))))

DatabaseConnector::disconnect(conn)
