
createConditionTests <- function () {

	patient <- createPatient()
	encounter <- createEncounter()
	declareTest(id = patient$id, "ICD9 code in SNOMED column, CONDITION_CONCEPT_ID = 0")
	add_patients(id = patient$id)
	add_encounters(id = encounter$id, patient = patient$id, encounterclass = "outpatient", start = "2009-08-19", stop = "2009-08-19")
	add_conditions(patient = patient$id, encounter = encounter$id, start = "2009-08-19", stop = "2009-10-18", code = "V89.03")
	expect_condition_occurrence(condition_status_source_value = "V89.03", condition_concept_id = 0)

}
