
insert into @cdm_schema.observation (
observation_id,
person_id,
observation_concept_id,
observation_date,
observation_datetime,
observation_type_concept_id,
value_as_number,
value_as_string,
value_as_concept_id,
qualifier_concept_id,
unit_concept_id,
provider_id,
visit_occurrence_id,
visit_detail_id,
observation_source_value,
observation_source_concept_id,
unit_source_value,
qualifier_source_value
)
select
row_number()over(order by p.person_id),
p.person_id,
case when srctostdvm.target_concept_id is NULL then 0 else srctostdvm.target_concept_id end as target_concept_id,
a.start,
a.start,
38000280,
cast(null as float),
cast(null as varchar),
0,
0,
0,
0,
fv.visit_occurrence_id_new visit_occurrence_id,
0,
a.code,
coalesce(srctosrcvm.source_concept_id,0),
cast(null as varchar),
cast(null as varchar)
from @synthea_schema.allergies a
left join @vocab_schema.source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = a.code
 and srctostdvm.target_domain_id        = 'Observation'
 and srctostdvm.target_vocabulary_id    = 'SNOMED'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason IS NULL
left join @vocab_schema.source_to_source_vocab_map srctosrcvm
  on srctosrcvm.source_code             = a.code
 and srctosrcvm.source_vocabulary_id    = 'SNOMED'
left join @cdm_schema.final_visit_ids fv
  on fv.encounter_id = a.encounter
join @cdm_schema.person p
  on p.person_source_value    = a.patient

union all

select
row_number()over(order by p.person_id),
p.person_id,
case when srctostdvm.target_concept_id is NULL then 0 else srctostdvm.target_concept_id end as target_concept_id,
c.start,
c.start,
38000276,
cast(null as float),
cast(null as varchar),
0,
0,
0,
0,
fv.visit_occurrence_id_new visit_occurrence_id,
0,
c.code,
coalesce(srctosrcvm.source_concept_id,0),
cast(null as varchar),
cast(null as varchar)
from @synthea_schema.conditions c
left join @vocab_schema.source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = c.code
 and srctostdvm.target_domain_id        = 'Observation'
 and srctostdvm.target_vocabulary_id    = 'SNOMED'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason IS NULL
left join @vocab_schema.source_to_source_vocab_map srctosrcvm
  on srctosrcvm.source_code              = c.code
 and srctosrcvm.source_vocabulary_id     = 'SNOMED'
left join @cdm_schema.final_visit_ids fv
  on fv.encounter_id                     = c.encounter
join @cdm_schema.person p
  on p.person_source_value    = c.patient;
