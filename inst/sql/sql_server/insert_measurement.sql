drop sequence if exists measurement_id_seq;
create sequence measurement_id_seq start with 1;


insert into @cdm_schema.measurement (
measurement_id,
person_id,
measurement_concept_id,
measurement_date,
measurement_datetime,
measurement_time,
measurement_type_concept_id,
operator_concept_id,
value_as_number,
value_as_concept_id,
unit_concept_id,
range_low,
range_high,
provider_id,
visit_occurrence_id,
visit_detail_id,
measurement_source_value,
measurement_source_concept_id,
unit_source_value,
value_source_value
)
select
nextval('measurement_id_seq'),
p.person_id,
case when srctostdvm.target_concept_id is NULL then 0 else srctostdvm.target_concept_id end as target_concept_id,
pr.date,
pr.date,
pr.date,
5001,
0,
cast(null as float),
0,
0,
cast(null as float),
cast(null as float),
cast(null as bigint) provider_id,
fv.visit_occurrence_id_new visit_occurrence_id,
0,
pr.code,
coalesce(srctosrcvm.source_concept_id,0),
cast(null as varchar),
cast(null as varchar)
from @synthea_schema.procedures pr
left join @vocab_schema.source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = pr.code
 and srctostdvm.target_domain_id        = 'Measurement'
 and srctostdvm.target_vocabulary_id    = 'SNOMED'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason IS NULL
left join @vocab_schema.source_to_source_vocab_map srctosrcvm
  on srctosrcvm.source_code             = pr.code
 and srctosrcvm.source_vocabulary_id    = 'SNOMED'
left join @cdm_schema.final_visit_ids fv
  on fv.encounter_id = pr.encounter
join @cdm_schema.person p
  on p.person_source_value              = pr.patient

union all

select
nextval('measurement_id_seq'),
p.person_id,
case when srctostdvm.target_concept_id is NULL then 0 else srctostdvm.target_concept_id end as target_concept_id,
o.date,
o.date,
o.date,
5001,
0,
cast(null as float),
0,
0,
cast(null as float),
cast(null as float),
cast(null as bigint) provider_id,
fv.visit_occurrence_id_new visit_occurrence_id,
0,
o.code,
coalesce(srctosrcvm.source_concept_id,0),
cast(null as varchar),
cast(null as varchar)
from @synthea_schema.observations o
left join @vocab_schema.source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = o.code
 and srctostdvm.target_domain_id        = 'Measurement'
 and srctostdvm.target_vocabulary_id    = 'LOINC'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason IS NULL
left join @vocab_schema.source_to_source_vocab_map srctosrcvm
  on srctosrcvm.source_code             = o.code
 and srctosrcvm.source_vocabulary_id    = 'LOINC'
left join @cdm_schema.final_visit_ids fv
  on fv.encounter_id                    = o.encounter
join @cdm_schema.person p
  on p.person_source_value              = o.patient;
  
