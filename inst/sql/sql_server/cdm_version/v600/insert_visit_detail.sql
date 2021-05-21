
-- For testing purposes, populate VISIT_DETAIL
-- such that it's basically a copy of VISIT_OCCURRENCE

insert into @cdm_schema.visit_detail (
  visit_detail_id,
  person_id,
  visit_detail_concept_id,
  visit_detail_start_date,
  visit_detail_start_datetime,
  visit_detail_end_date,
  visit_detail_end_datetime,
  visit_detail_type_concept_id,
  provider_id,
  care_site_id,
  admitted_from_concept_id,
  discharge_to_concept_id,
  preceding_visit_detail_id,
  visit_detail_source_value,
  visit_detail_source_concept_id,
  admitted_from_source_value,
  discharge_to_source_value,
  visit_detail_parent_id,
  visit_occurrence_id
)

select
  	av.visit_occurrence_id + 1000000     visit_detail_id,
	p.person_id                          person_id,                          

	case lower(av.encounterclass) 
		when 'ambulatory'  then 9202
		when 'emergency'   then 9203
		when 'inpatient'   then 9201
		when 'wellness'    then 9202
		when 'urgentcare'  then 9203 
		when 'outpatient'  then 9202
	else 0
	end                                  visit_detail_concept_id,
	
	av.visit_start_date                  visit_detail_start_date,
	av.visit_start_date                  visit_detail_start_datetime,
	av.visit_end_date                    visit_detail_end_date,
	av.visit_end_date                    visit_detail_end_datetime,
	44818517                             visit_detail_type_concept_id,                             
	0                                    provider_id,                                 
	null                                 care_site_id,                                 
	0                                    admitted_from_concept_id,
	0                                    discharge_to_concept_id,                                       
    lag(av.visit_occurrence_id) 
	over(partition by p.person_id
			 order by av.visit_start_date) + 1000000 preceding_visit_detail_id,
	av.encounter_id                                  visit_detail_source_value,
	0                                                visit_detail_source_concept_id,                                
	null                                             admitted_from_source_value,
	null                                             discharge_to_source_value,
	null                                             visit_detail_parent_id,
	av.visit_occurrence_id                           visit_occurrence_id
from @cdm_schema.all_visits av
join @cdm_schema.person p
  on av.patient = p.person_source_value
where av.visit_occurrence_id in (
		select distinct visit_occurrence_id_new
		from @cdm_schema.final_visit_ids);
