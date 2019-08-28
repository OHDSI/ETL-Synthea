
insert into @cdm_schema.visit_occurrence (
visit_occurrence_id,
person_id,
visit_concept_id,
visit_start_date,
visit_start_datetime,
visit_end_date,
visit_end_datetime,
visit_type_concept_id,
provider_id,
care_site_id,
visit_source_value,
visit_source_concept_id,
admitting_source_concept_id,
admitting_source_value,
discharge_to_concept_id,
discharge_to_source_value,
preceding_visit_occurrence_id
)
select
  	av.visit_occurrence_id,
	p.person_id,                          

	case lower(av.encounterclass) 
		when 'ambulatory'  then 9202
		when 'emergency'   then 9203
		when 'inpatient'   then 9201
		when 'wellness'    then 9202
		when 'urgentcare'  then 9203 
		when 'outpatient'  then 9202
	else 0
	end,
	av.visit_start_date,
	av.visit_start_date,
	av.visit_end_date,
	av.visit_end_date,
	44818517,                             
	null,                                 
	null,                                 
	av.encounter_id,
	0,                                       
	0,
	NULL,
	0,                                
	NULL,   
	lag(visit_occurrence_id) 
	 over(partition by p.person_id
			  order by av.visit_start_date)
from @cdm_schema.all_visits av
join @cdm_schema.person p
  on av.patient = p.person_source_value
where av.visit_occurrence_id in (
		select distinct visit_occurrence_id_new
		from @cdm_schema.final_visit_ids);