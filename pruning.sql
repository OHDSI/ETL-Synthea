-- specialized pruning
-- @fjdefalco

-- this pruning routine was run to minimize the size of the data sample to try and get close to a 7MB maximum
-- required for submission to CRAN

-- the sqlite file was analyzed to determine areas for potential size savings via the following utility available for download from sqlite community
-- sample analysis commandline:
-- $ ./sqlite3_analyzer.exe /d/git/synthea/cdm.20190626200436.sqlite

-- remove all people not included in the identified cohorts for study
delete from condition_occurrence where person_id in (
	select person_id
	from person p
	left join coxibVsNonselVsGiBleed on subject_id = person_id
	where subject_id is null
)
delete from condition_era where person_id in (
	select person_id
	from person p
	left join coxibVsNonselVsGiBleed on subject_id = person_id
	where subject_id is null
)
delete from drug_exposure where person_id in (
	select person_id
	from person p
	left join coxibVsNonselVsGiBleed on subject_id = person_id
	where subject_id is null
)
delete from drug_era where person_id in (
	select person_id
	from person p
	left join coxibVsNonselVsGiBleed on subject_id = person_id
	where subject_id is null
)
delete from visit_occurrence where person_id in (
	select person_id
	from person p
	left join coxibVsNonselVsGiBleed on subject_id = person_id
	where subject_id is null
)
delete from visit_detail where person_id in (
	select person_id
	from person p
	left join coxibVsNonselVsGiBleed on subject_id = person_id
	where subject_id is null
)
delete from procedure_occurrence where person_id in (
	select person_id
	from person p
	left join coxibVsNonselVsGiBleed on subject_id = person_id
	where subject_id is null
)
delete from measurement where person_id in (
	select person_id
	from person p
	left join coxibVsNonselVsGiBleed on subject_id = person_id
	where subject_id is null
)
delete from observation where person_id in (
	select person_id
	from person p
	left join coxibVsNonselVsGiBleed on subject_id = person_id
	where subject_id is null
)

delete from person where person_id in (
	select person_id
	from person p
	left join coxibVsNonselVsGiBleed on subject_id = person_id
	where subject_id is null
)

-- only keep the inpatient visits required to find our outcome
delete from visit_occurrence where visit_concept_id in (9202,9203)

-- drop unncessary vocabulary content until we have a handle on the needs of the vocabulary chapters
delete from concept_relationship
delete from drug_strength
delete from source_to_concept_map

-- back out flu vaccines since they account for 10x more data than any other drug
delete from drug_exposure where drug_concept_id = 40213154

