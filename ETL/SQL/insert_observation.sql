drop sequence if exists observation_id_seq;
create sequence observation_id_seq start with 1;

insert into observation (
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
nextval('observation_id_seq'),        -- observation_id,
pe.person_id,                         -- person_id,
vm.target_concept_id,                 -- observation_concept_id,
a.start,                              -- observation_date,
cast(null as timestamp),              -- observation_datetime,
38000280,                 -- observation_type_concept_id,
cast(null as float),      -- value_as_number,
cast(null as varchar),    -- value_as_string,
0,                                    -- value_as_concept_id,
cast(null as integer),    -- qualifier_concept_id,
cast(null as integer),    -- unit_concept_id,
cast(null as integer),                -- provider_id,
vo.visit_occurrence_id,               -- visit_occurrence_id,
cast(null as integer),                -- visit_detail_id,
vm.source_code,                       -- observation_source_value,
vm.source_concept_id,                 -- observation_source_concept_id,
cast(null as varchar),    -- unit_source_value,
cast(null as varchar)     -- qualifier_source_value
from vocab_map vm
 join allergies a
   on a.code    = vm.source_code
  and vm.source_vocabulary_id = 'SNOMED'
 join person pe
   on pe.person_source_value = a.patient
 join visit_occurrence vo
   on vo.person_id              = pe.person_id
  and vo.admitting_source_value = a.encounter

union all

select
nextval('observation_id_seq'),        -- observation_id,
pe.person_id,                         -- person_id,
vm.target_concept_id,                 -- observation_concept_id,
cp.start,                             -- observation_date,
cast(null as timestamp),              -- observation_datetime,
38000280,                 -- observation_type_concept_id,
cast(null as float),      -- value_as_number,
cast(null as varchar),    -- value_as_string,
0,                                    -- value_as_concept_id,
cast(null as integer),    -- qualifier_concept_id,
cast(null as integer),    -- unit_concept_id,
cast(null as integer),                -- provider_id,
vo.visit_occurrence_id,               -- visit_occurrence_id,
cast(null as integer),                -- visit_detail_id,
vm.source_code,                       -- observation_source_value,
vm.source_concept_id,                 -- observation_source_concept_id,
cast(null as varchar),    -- unit_source_value,
cast(null as varchar)     -- qualifier_source_value
  from vocab_map vm
  join careplans cp
    on vm.source_code = cp.code
   and vm.source_vocabulary_id = 'SNOMED'
   and vm.source_domain_id = 'Observation'
  join person pe
    on pe.person_source_value = cp.patient
  join visit_occurrence vo
    on vo.person_id              = pe.person_id
   and vo.admitting_source_value = cp.encounter

union all


select
nextval('observation_id_seq'),        -- observation_id,
pe.person_id,                         -- person_id,
vm.target_concept_id,                 -- observation_concept_id,
cd.start,                             -- observation_date,
cast(null as timestamp),              -- observation_datetime,
38000280,                 -- observation_type_concept_id,
cast(null as float),      -- value_as_number,
cast(null as varchar),    -- value_as_string,
0,                                    -- value_as_concept_id,
cast(null as integer),    -- qualifier_concept_id,
cast(null as integer),    -- unit_concept_id,
cast(null as integer),                -- provider_id,
vo.visit_occurrence_id,               -- visit_occurrence_id,
cast(null as integer),                -- visit_detail_id,
vm.source_code,                       -- observation_source_value,
vm.source_concept_id,                 -- observation_source_concept_id,
cast(null as varchar),    -- unit_source_value,
cast(null as varchar)     -- qualifier_source_value
from vocab_map vm
 join conditions cd
   on vm.source_code = cd.code
  and vm.source_domain_id = 'Observation'
  and vm.source_vocabulary_id = 'SNOMED'
 join person pe
   on pe.person_source_value = cd.patient
 join visit_occurrence vo
   on vo.person_id              = pe.person_id
  and vo.admitting_source_value = cd.encounter

union all

select
nextval('observation_id_seq'),        -- observation_id,
pe.person_id,                         -- person_id,
vm.target_concept_id,                 -- observation_concept_id,
e.start,                              -- observation_date,
cast(null as timestamp),              -- observation_datetime,
38000280,                 -- observation_type_concept_id,
cast(null as float),      -- value_as_number,
cast(null as varchar),    -- value_as_string,
0,                                    -- value_as_concept_id,
cast(null as integer),    -- qualifier_concept_id,
cast(null as integer),    -- unit_concept_id,
cast(null as integer),                -- provider_id,
vo.visit_occurrence_id,               -- visit_occurrence_id,
cast(null as integer),                -- visit_detail_id,
vm.source_code,                       -- observation_source_value,
vm.source_concept_id,                 -- observation_source_concept_id,
cast(null as varchar),    -- unit_source_value,
cast(null as varchar)     -- qualifier_source_value
from vocab_map vm
join encounters e
  on vm.source_code = e.code
 and vm.source_domain_id = 'Observation'
 and vm.source_vocabulary_id = 'SNOMED'
join person pe
  on pe.person_source_value = e.patient
join visit_occurrence vo
  on vo.person_id              = pe.person_id
 and vo.admitting_source_value = e.id

union all

select
nextval('observation_id_seq'),        -- observation_id,
pe.person_id,                         -- person_id,
vm.target_concept_id,                 -- observation_concept_id,
o.date,                              -- observation_date,
cast(null as timestamp),              -- observation_datetime,
38000280,                 -- observation_type_concept_id,
cast(null as float),      -- value_as_number,
cast(null as varchar),    -- value_as_string,
0,                                    -- value_as_concept_id,
cast(null as integer),    -- qualifier_concept_id,
cast(null as integer),    -- unit_concept_id,
cast(null as integer),                -- provider_id,
vo.visit_occurrence_id,               -- visit_occurrence_id,
cast(null as integer),                -- visit_detail_id,
vm.source_code,                       -- observation_source_value,
vm.source_concept_id,                 -- observation_source_concept_id,
cast(null as varchar),    -- unit_source_value,
cast(null as varchar)     -- qualifier_source_value
   from vocab_map vm
   join observations o
     on vm.source_code          = o.code
	and vm.source_domain_id     = 'Observation'
	and vm.source_vocabulary_id = 'LOINC'
   join person pe
     on pe.person_source_value = o.patient
   join visit_occurrence vo
     on vo.person_id              = pe.person_id
	and vo.admitting_source_value = o.encounter

union all

select
nextval('observation_id_seq'),        -- observation_id,
pe.person_id,                         -- person_id,
vm.target_concept_id,                 -- observation_concept_id,
pr.date,                             -- observation_date,
cast(null as timestamp),              -- observation_datetime,
38000280,                 -- observation_type_concept_id,
cast(null as float),      -- value_as_number,
cast(null as varchar),    -- value_as_string,
0,                                    -- value_as_concept_id,
cast(null as integer),    -- qualifier_concept_id,
cast(null as integer),    -- unit_concept_id,
cast(null as integer),                -- provider_id,
vo.visit_occurrence_id,               -- visit_occurrence_id,
cast(null as integer),                -- visit_detail_id,
vm.source_code,                       -- observation_source_value,
vm.source_concept_id,                 -- observation_source_concept_id,
cast(null as varchar),    -- unit_source_value,
cast(null as varchar)     -- qualifier_source_value
from vocab_map vm
join procedures pr
  on vm.source_code        = pr.code
 and vm.source_domain_id   = 'Observation'
join person pe
  on pe.person_source_value    = pr.patient
join visit_occurrence vo
  on vo.person_id              = pe.person_id
 and vo.admitting_source_value = pr.encounter;
