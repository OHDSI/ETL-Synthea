drop sequence if exists condition_occurrence_id_seq;
create sequence condition_occurrence_id_seq start with 1;


insert into condition_occurrence (
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
select nextval('condition_occurrence_id_seq'),  -- condition_occurrence_id,
pe.person_id,                                   -- person_id
vm.target_concept_id,                           -- condition_concept_id,
c1.start,                                       -- condition_start_date,
cast(null as timestamp),                        -- condition_start_datetime,
c1.stop,                                        -- condition_end_date,
cast(null as timestamp),                        -- condition_end_datetime,
38000183,                           -- condition_type_concept_id,
cast(null as varchar),              -- stop_reason,
cast(null as integer),                          -- provider_id,
vo.visit_occurrence_id,                         -- visit_occurrence_id,
cast(null as integer),                          -- vd.visit_detail_id,
vm.source_code,                                 -- condition_source_value,
vm.source_concept_id,                           -- condition_source_concept_id,
substring(c1.description,1,50),                 -- condition_status_source_value,
0                                               -- condition_status_concept_id
from conditions c1
join vocab_map vm
  on vm.source_code      = c1.code
 and vm.source_domain_id = 'Condition'
join person pe
  on c1.patient = pe.person_source_value
join visit_occurrence vo
  on c1.encounter  = vo.admitting_source_value
 and pe.person_id  = vo.person_id;
