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
