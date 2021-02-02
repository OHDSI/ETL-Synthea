
insert into @cdm_schema.procedure_occurrence
(
procedure_occurrence_id,
person_id,
procedure_concept_id,
procedure_date,
procedure_datetime,
procedure_type_concept_id,
modifier_concept_id,
quantity,
provider_id,
visit_occurrence_id,
visit_detail_id,
procedure_source_value,
procedure_source_concept_id,
modifier_source_value
)
select
  row_number()over(order by p.person_id),
  p.person_id,
  case when srctostdvm.target_concept_id is NULL then 0 else srctostdvm.target_concept_id end as target_concept_id,
  pr.date,
  pr.date,
  38000275,
  0,
  cast(null as integer),
  0,
  fv.visit_occurrence_id_new visit_occurrence_id,
  0,
  pr.code,
  coalesce(srctosrcvm.source_concept_id,0),
  NULL
from @synthea_schema.procedures pr
join @cdm_schema.source_to_standard_vocab_map  srctostdvm
  on srctostdvm.source_code             = pr.code
 and srctostdvm.target_domain_id        = 'Procedure'
 and srctostdvm.source_vocabulary_id    = 'SNOMED'
 and srctostdvm.target_standard_concept = 'S'
 and (srctostdvm.target_invalid_reason IS NULL OR srctostdvm.target_invalid_reason = '')
left join @cdm_schema.source_to_source_vocab_map srctosrcvm
  on srctosrcvm.source_code             = pr.code
 and srctosrcvm.source_vocabulary_id    = 'SNOMED'
left join @cdm_schema.final_visit_ids fv
  on fv.encounter_id = pr.encounter
join @cdm_schema.person p
  on p.person_source_value    = pr.patient;
