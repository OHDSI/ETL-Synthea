drop sequence if exists procedure_occurrence_id_seq;
create sequence procedure_occurrence_id_seq start with 1;

insert into procedure_occurrence (
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
nextval('procedure_occurrence_id_seq'),     -- procedure_occurrence_id,
pe.person_id,                               -- person_id,
vm.target_concept_id,                       -- procedure_concept_id,
cp.start,                                   -- procedure_date,
cast(null as timestamp),                    -- procedure_datetime,
38000248,                  -- ask Erica,    -- procedure_type_concept_id,
cast(null as integer),                      -- modifier_concept_id,
cast(null as integer),                      -- quantity,
cast(null as integer),                      -- provider_id,
vo.visit_occurrence_id,                     -- visit_occurrence_id,
cast(null as integer),                      -- visit_detail_id,
cp.code,                                    -- procedure_source_value,
vm.source_concept_id,                       -- procedure_source_concept_id,
cast(null as varchar)                       -- modifier_source_value
   from vocab_map vm
   join careplans cp
     on vm.source_code           = cp.code
	and vm.source_domain_id      = 'Procedure'
    and vm.source_vocabulary_id  = 'SNOMED'
  join person pe
     on pe.person_source_value    = cp.patient
  join visit_occurrence vo
     on vo.person_id              = pe.person_id
	and vo.admitting_source_value = cp.encounter

union all

select
nextval('procedure_occurrence_id_seq'),     -- procedure_occurrence_id,
pe.person_id,                               -- person_id,
vm.target_concept_id,                       -- procedure_concept_id,
e.start,                                    -- procedure_date,
cast(null as timestamp),                    -- procedure_datetime,
38000248,                  -- ask Erica,    -- procedure_type_concept_id,
cast(null as integer),                      -- modifier_concept_id,
cast(null as integer),                      -- quantity,
cast(null as integer),                      -- provider_id,
vo.visit_occurrence_id,                     -- visit_occurrence_id,
cast(null as integer),                      -- visit_detail_id,
vm.source_code,                             -- procedure_source_value,
vm.source_concept_id,                       -- procedure_source_concept_id,
cast(null as varchar)                       -- modifier_source_value
   from vocab_map vm
   join encounters e
     on vm.source_code           = e.code
	and vm.source_domain_id      = 'Procedure'
	and vm.source_vocabulary_id  = 'SNOMED'
  join person pe
     on pe.person_source_value    = e.patient
  join visit_occurrence vo
     on vo.person_id              = pe.person_id
	and vo.admitting_source_value = e.id

union all

select
nextval('procedure_occurrence_id_seq'),     -- procedure_occurrence_id,
pe.person_id,                               -- person_id,
vm.target_concept_id,                       -- procedure_concept_id,
pr.date,                                   -- procedure_date,
cast(null as timestamp),                    -- procedure_datetime,
38000248,                  -- ask Erica,    -- procedure_type_concept_id,
cast(null as integer),                      -- modifier_concept_id,
cast(null as integer),                      -- quantity,
cast(null as integer),                      -- provider_id,
vo.visit_occurrence_id,                     -- visit_occurrence_id,
cast(null as integer),                      -- visit_detail_id,
vm.source_code,                             -- procedure_source_value,
vm.source_concept_id,                       -- procedure_source_concept_id,
cast(null as varchar)                       -- modifier_source_value
  from vocab_map vm
   join procedures pr
     on vm.source_code           = pr.code
	and vm.source_domain_id      = 'Procedure'
	and vm.source_vocabulary_id  = 'SNOMED'
  join person pe
     on pe.person_source_value    = pr.patient
  join visit_occurrence vo
     on vo.person_id              = pe.person_id
	and vo.admitting_source_value = pr.encounter;
