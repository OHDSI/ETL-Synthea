## Support functions

getSequence <- function (startValue = 1) {
	counterInstance <- new.env(parent = emptyenv());
	counterInstance$currentValue <- startValue;
	counterInstance$nextSequence <- function()
	{
		nextValue <- counterInstance$currentValue;
		counterInstance$currentValue = counterInstance$currentValue + 1;
		return(nextValue)
	}
	return (counterInstance);
}

sequencer <- getSequence()


createPatient <- function() {
	personId = sequencer$nextSequence();
	return (list(id = personId));
}


createEncounter <- function() {
	encounterId = sequencer$nextSequence();
	return (list(id = encounterId));
}


## Function to get insertsql statement
getInsertSql <- function(connectionDetails) {
	return(frameworkContext$insertSql);
}


## Function to get testsql statement
getTestSql <- function(connectionDetails) {
	return(frameworkContext$testSql);
}

getTests <- function() {
	source('extras/ConditionTests.r')
	#source('R/ConditionEraTests.R')
	#source('R/CostTests.R')
	#source('R/DeathTests.R')
	#source('R/DeviceExposureTests.R')
	#source('R/DrugExposureTests.R')
	#source('R/DrugEraTests.R')
	#source('R/LocationTests.R')
	# source('R/MeasurementTests.R')
	source('extras/ObservationPeriodTests.r')
	# source('extras/ObservationTests.R')
	# source('R/PayerPlanPeriodTests.R')
	source('extras/PersonTests.r')
	# source('R/ProcedureOccurrenceTests.R')
	# source('R/ProviderTests.R')
	source('extras/VisitTests.r')
}

createTests <- function() {
	createPersonTests()
	createConditionTests()
	createObservationPeriodTests()
	createVisitTests()
}
