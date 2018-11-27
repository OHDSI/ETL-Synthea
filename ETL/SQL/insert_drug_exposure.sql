drop sequence if exists drug_exposure_id_seq;
create sequence drug_exposure_id_seq start with 1;

insert into drug_exposure (
drug_exposure_id,
person_id,
drug_concept_id,
drug_exposure_start_date,
drug_exposure_start_datetime,
drug_exposure_end_date,
drug_exposure_end_datetime,
verbatim_end_date,
drug_type_concept_id,
stop_reason,
refills,
quantity,
days_supply,
sig,
route_concept_id,
lot_number,
provider_id,
visit_occurrence_id,
visit_detail_id,
drug_source_value,
drug_source_concept_id,
route_source_value,
dose_unit_source_value
)
select
nextval('drug_exposure_id_seq'),            -- drug_exposure_id,
pe.person_id,                               -- person_id,
vm.target_concept_id,                       -- drug_concept_id,
c1.start,                                   -- drug_exposure_start_date,
cast(null as timestamp),                    -- drug_exposure_start_datetime,
coalesce(c1.stop,c1.start),                 -- drug_exposure_end_date,
cast(null as timestamp),                    -- drug_exposure_end_datetime,
c1.stop,                                    -- verbatim_end_date,
38000175,                                   -- drug_type_concept_id,
cast(null as varchar),                      -- stop_reason,
cast(null as integer),                      -- refills,
cast(null as float),                        -- quantity,
cast(null as integer),                      -- days_supply,
cast(null as varchar),                      -- sig,
cast(null as integer),                      -- route_concept_id,
cast(null as varchar),                      -- lot_number,
cast(null as integer),                      -- provider_id,
vo.visit_occurrence_id,                     -- visit_occurrence_id,
cast(null as integer),                      -- visit_detail_id,
vm.source_code,                             -- drug_source_value,
vm.source_concept_id,                       -- drug_source_concept_id,
cast(null as varchar),                      -- route_source_value
cast(null as varchar)                       -- dose_unit_source_value
  from conditions c1
  join vocab_map vm
    on vm.source_code          = c1.code
   and vm.source_domain_id     = 'Drug'
  join person pe
    on c1.patient = pe.person_source_value
  join visit_occurrence vo
    on vo.person_id              = pe.person_id
   and vo.admitting_source_value = c1.encounter

union all

select
nextval('drug_exposure_id_seq'),            -- drug_exposure_id,
pe.person_id,                               -- person_id,
vm.target_concept_id,                       -- drug_concept_id,
i.date,                                    -- drug_exposure_start_date,
cast(null as timestamp),                    -- drug_exposure_start_datetime,
null,                                    -- drug_exposure_end_date,
cast(null as timestamp),                    -- drug_exposure_end_datetime,
cast(null as date),                         -- verbatim_end_date,
38000175,                                   -- drug_type_concept_id,
cast(null as varchar),                      -- stop_reason,
cast(null as integer),                      -- refills,
cast(null as float),                        -- quantity,
cast(null as integer),                      -- days_supply,
cast(null as varchar),                      -- sig,
cast(null as integer),                      -- route_concept_id,
cast(null as varchar),                      -- lot_number,
cast(null as integer),                      -- provider_id,
vo.visit_occurrence_id,                     -- visit_occurrence_id,
cast(null as integer),                      -- visit_detail_id,
vm.source_code,                             -- drug_source_value,
vm.source_concept_id,                       -- drug_source_concept_id,
cast(null as varchar),                      -- route_source_value
cast(null as varchar)                       -- dose_unit_source_value
  from immunizations i
  join vocab_map vm
    on vm.source_code          = i.code
   and vm.source_domain_id     = 'Drug'
   and vm.source_vocabulary_id = 'CVX'
  join person pe
    on i.patient = pe.person_source_value
  join visit_occurrence vo
    on vo.person_id              = pe.person_id
   and vo.admitting_source_value = i.encounter

union all


select
nextval('drug_exposure_id_seq'),            -- drug_exposure_id,
pe.person_id,                               -- person_id,
vm.target_concept_id,                       -- drug_concept_id,
m.start,                                    -- drug_exposure_start_date,
cast(null as timestamp),                    -- drug_exposure_start_datetime,
coalesce(m.stop,m.start),                   -- drug_exposure_end_date,
cast(null as timestamp),                    -- drug_exposure_end_datetime,
m.stop,                                     -- verbatim_end_date,
38000175,                                   -- drug_type_concept_id,
cast(null as varchar),                      -- stop_reason,
cast(null as integer),                      -- refills,
cast(null as float),                        -- quantity,
cast(null as integer),                      -- days_supply,
cast(null as varchar),                      -- sig,
cast(null as integer),                      -- route_concept_id,
cast(null as varchar),                      -- lot_number,
cast(null as integer),                      -- provider_id,
vo.visit_occurrence_id,                     -- visit_occurrence_id,
cast(null as integer),                      -- visit_detail_id,
vm.source_code,                             -- drug_source_value,
vm.source_concept_id,                       -- drug_source_concept_id,
cast(null as varchar),                      -- route_source_value
cast(null as varchar)                       -- dose_unit_source_value
  from medications m
  join vocab_map vm
    on vm.source_code          = m.code
   and vm.source_domain_id     = 'Drug'
   and vm.source_vocabulary_id = 'RxNorm'
  join person pe
    on m.patient = pe.person_source_value
  join visit_occurrence vo
    on vo.person_id              = pe.person_id
   and vo.admitting_source_value = m.encounter ;
