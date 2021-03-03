

insert into @cdm_schema.condition_occurrence (
condition_occurrence_id,
person_id,
condition_concept_id,
condition_start_date,
condition_start_datetime,
condition_end_date,
condition_end_datetime,
condition_type_concept_id,
stop_reason,
provider_id,
visit_occurrence_id,
visit_detail_id,
condition_source_value,
condition_source_concept_id,
condition_status_source_value,
condition_status_concept_id
)

select
row_number()over(order by p.person_id)     condition_occurrence_id,
p.person_id                                person_id,
case 
when srctostdvm.target_concept_id is null 
then 0 else srctostdvm.target_concept_id 
end                                        target_concept_id,
c.start                                    condition_start_date,
c.start                                    condition_start_datetime,
c.stop                                     condition_end_date,
c.stop                                     condition_end_datetime,
32020                                      condition_type_concept_id,
cast(null as varchar)                      stop_reason,
cast(null as integer)                      provider_id,
fv.visit_occurrence_id_new                 visit_occurrence_id,
fv.visit_occurrence_id_new + 1000000       visit_detail_id,
c.code                                     condition_source_value,
coalesce(srctosrcvm.source_concept_id,0)   condition_source_concept_id,
null                                       condition_status_source_value,
0                                          condition_status_concept_id

from @synthea_schema.conditions c
left join @cdm_schema.source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = c.code
 and srctostdvm.target_domain_id        = 'Condition'
 and srctostdvm.target_vocabulary_id    = 'SNOMED'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason is null
left join @cdm_schema.source_to_source_vocab_map srctosrcvm
  on srctosrcvm.source_code             = c.code
 and srctosrcvm.source_vocabulary_id    = 'SNOMED'
left join @cdm_schema.final_visit_ids fv
  on fv.encounter_id = c.encounter
join @cdm_schema.person p
  on c.patient = p.person_source_value;
