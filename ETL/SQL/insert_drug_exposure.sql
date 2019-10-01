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
nextval('drug_exposure_id_seq'),
p.person_id,
srctostdvm.target_concept_id,
c.start,
c.start,
coalesce(c.stop,c.start),
coalesce(c.stop,c.start),
c.stop,
581452,
cast(null as varchar),
0,
0,
coalesce(c.stop-c.start,0),
cast(null as varchar),
0,
0,
NULL,
(select fv.visit_occurrence_id_new from final_visit_ids fv
  where fv.encounter_id = c.encounter) visit_occurrence_id,
0,
c.code,
(
select srctosrcvm.source_concept_id
   from source_to_source_vocab_map srctosrcvm
  where srctosrcvm.source_code = c.code
    and srctosrcvm.source_vocabulary_id  = 'SNOMED'
),
cast(null as varchar),
cast(null as varchar)

from conditions c
join source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = c.code
 and srctostdvm.target_domain_id        = 'Drug'
 and srctostdvm.target_vocabulary_id    = 'RxNorm'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason IS NULL
join person p
  on p.person_source_value    = c.patient

union all

select
nextval('drug_exposure_id_seq'),
p.person_id,
srctostdvm.target_concept_id,
m.start,
m.start,
coalesce(m.stop,m.start),
coalesce(m.stop,m.start),
m.stop,
38000177,
cast(null as varchar),
0,
0,
coalesce(m.stop-m.start,0),
cast(null as varchar),
0,
0,
NULL,
(select fv.visit_occurrence_id_new from final_visit_ids fv
  where fv.encounter_id = m.encounter) visit_occurrence_id,
0,
m.code,
(
select srctosrcvm.source_concept_id
   from source_to_source_vocab_map srctosrcvm
  where srctosrcvm.source_code = m.code
    and srctosrcvm.source_vocabulary_id  = 'RxNorm'
),
cast(null as varchar),
cast(null as varchar)

from medications m
join source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = m.code
 and srctostdvm.target_domain_id        = 'Drug'
 and srctostdvm.target_vocabulary_id    = 'RxNorm'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason IS NULL
join person p
  on p.person_source_value    = m.patient

union all

select
nextval('drug_exposure_id_seq'),
p.person_id,
srctostdvm.target_concept_id,
i.date,
i.date,
i.date,
i.date,
i.date,
581452,
cast(null as varchar),
0,
0,
0,
cast(null as varchar),
0,
0,
NULL,
(select fv.visit_occurrence_id_new from final_visit_ids fv
  where fv.encounter_id = i.encounter) visit_occurrence_id,
0,
i.code,
(
select srctosrcvm.source_concept_id
   from source_to_source_vocab_map srctosrcvm
  where srctosrcvm.source_code = i.code
    and srctosrcvm.source_vocabulary_id  = 'CVX'
),
cast(null as varchar),
cast(null as varchar)

from immunizations i
join source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = i.code
 and srctostdvm.target_domain_id        = 'Drug'
 and srctostdvm.target_vocabulary_id    = 'CVX'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason IS NULL
join person p
  on p.person_source_value    = i.patient;
