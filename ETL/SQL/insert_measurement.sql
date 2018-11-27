drop sequence if exists measurement_id_seq;
create sequence measurement_id_seq start with 1;

insert into measurement (
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
nextval('measurement_id_seq'),                -- measurement_id,
pe.person_id,                                 -- person_id,
vm.target_concept_id,                         -- measurement_concept_id,
pr.date,                                     -- measurement_date,
cast(null as timestamp),                      -- measurement_datetime,
cast(null as timestamp),                      -- measurement_time,
38000215,                   -- Ask Erica      -- measurement_type_concept_id,
cast(null as integer),                        -- operator_concept_id,
cast(null as float),                          -- value_as_number,
cast(null as integer),                        -- value_as_concept_id,
cast(null as integer),                        -- unit_concept_id,
cast(null as float),                          -- range_low,
cast(null as float),                          -- range_high,
cast(null as integer),                        -- provider_id,
vo.visit_occurrence_id,                       -- visit_occurrence_id,
cast(null as integer),                        -- visit_detail_id,
vm.source_code,                               -- measurement_source_value,
vm.source_concept_id,                         -- measurement_source_concept_id,
cast(null as varchar),                        -- unit_source_value,
cast(null as varchar)                         -- value_source_value
  from procedures pr
  join vocab_map vm
    on vm.source_code           = pr.code
   and vm.source_domain_id      = 'Measurement'
   and vm.source_vocabulary_id  = 'SNOMED'
  join person pe
    on pr.patient = pe.person_source_value
  join visit_occurrence vo
    on vo.person_id = pe.person_id
   and vo.admitting_source_value = pr.encounter


union all

select
nextval('measurement_id_seq'),                -- measurement_id,
pe.person_id,                                 -- person_id,
vm.target_concept_id,                         -- measurement_concept_id,
o.date,                                      -- measurement_date,
cast(null as timestamp),                      -- measurement_datetime,
cast(null as timestamp),                      -- measurement_time,
38000215,                   -- Ask Erica      -- measurement_type_concept_id,
cast(null as integer),                        -- operator_concept_id,
cast(null as float),                          -- value_as_number,
cast(null as integer),                        -- value_as_concept_id,
cast(null as integer),                        -- unit_concept_id,
cast(null as float),                          -- range_low,
cast(null as float),                          -- range_high,
cast(null as integer),                        -- provider_id,
vo.visit_occurrence_id,                       -- visit_occurrence_id,
cast(null as integer),                        -- visit_detail_id,
vm.source_code,                               -- measurement_source_value,
vm.source_concept_id,                         -- measurement_source_concept_id,
cast(null as varchar),                        -- unit_source_value,
cast(null as varchar)                         -- value_source_value
  from observations o
  join vocab_map vm
    on vm.source_code           = o.code
   and vm.source_domain_id      = 'Measurement'
   and vm.source_vocabulary_id  = 'LOINC'
  join person pe
    on o.patient = pe.person_source_value
  join visit_occurrence vo
    on vo.person_id = pe.person_id
   and vo.admitting_source_value = o.encounter ;
