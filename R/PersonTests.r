createPersonTests <- function () {

	patient <- createPatient()
	declareTest(id = patient$id, description = "Drop patients with no gender")
	add_patients.csv(id = patient$personId, gender = NULL)



## example of race loop

# 	race <- list(
# 		list(source = "1", value = "Mexican American", concept_id = 0),
# 		list(source = "2", value = "Other Hispanic", concept_id = 0),
# 		list(source = "3", value = "Non-Hispanic White", concept_id = 8527),
# 		list(source = "4", value = "Non-Hispanic Black", concept_id = 8516),
# 		list(source = "5", value = "Other Race - Including Multi-Racial", concept_id = 0)
# 	)
#
# 	for (r in race)
# 	{
# 		patient <- createPatient()
# 		declareTest(id = patient$person_id, description = paste0("Patient has race code ",r$source,", ID is person_id"))
# 		add_nhanes_all(seqn = patient$seqn, table_name = "DEMO_C", variable = "RIDAGEYR", value = "35")
# 		add_nhanes_all(seqn = patient$seqn, table_name = "DEMO_C", variable = "RIAGENDR", value = "1")
# 		add_nhanes_all(seqn = patient$seqn, table_name = "DEMO_C", variable = "RIDRETH1", value = r$source)
# 		add_nhanes_all_descriptions(table_name = 'DEMO_C', code_or_value = r$source, value_description = r$value, count = '5152', cumulative = '10122', skip_to_item = 'NA', var_name = "RIDRETH1")
# 		expect_person(person_id = patient$person_id, race_concept_id = r$concept_id, race_source_value = r$value)
# 	}
}
