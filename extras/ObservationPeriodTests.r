createObservationPeriodTests <- function () {

	patient <- createPatient()
	encounter1 <- createEncounter()
	encounter2 <- createEncounter()
	declareTest(id = patient$id, description = "Test that observation period is taking the earliest start and latest stop, id is person_source_value")
	add_patients(id = patient$id, gender = NULL)
	add_encounters(id = encounter1$id, patient = patient$id, encounterclass = "outpatient", start = "2009-10-19", stop = "2009-10-19")
	add_encounters(id = encounter2$id, patient = patient$id, encounterclass = "inpatient", start = "2009-11-21", stop = "2009-11-30")
	expect_observation_period(observation_period_start_date = "2009-10-19", observation_period_end_date = "2009-11-30")

	}
