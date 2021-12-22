

insert into @cdm_schema.drug_exposure (
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

select row_number()over(order by person_id) drug_exposure_id,
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
from (


select
p.person_id                                  person_id,
srctostdvm.target_concept_id                 drug_concept_id,
m.start                                      drug_exposure_start_date,
m.start                                      drug_exposure_start_datetime,
coalesce(m.stop,m.start)                     drug_exposure_end_date,
coalesce(m.stop,m.start)                     drug_exposure_end_datetime,
m.stop                                       verbatim_end_date,
32869                                        drug_type_concept_id,
cast(null as varchar)                        stop_reason,
0                                            refills,
0                                            quantity,
coalesce(datediff(day,m.start,m.stop),0)     days_supply,
cast(null as varchar)                        sig,
0                                            route_concept_id,
0                                            lot_number,
pr.provider_id                               provider_id,
fv.visit_occurrence_id_new                   visit_occurrence_id,
fv.visit_occurrence_id_new + 1000000         visit_detail_id,
m.code                                       drug_source_value,
srctosrcvm.source_concept_id                 drug_source_concept_id,
cast(null as varchar)                        route_source_value,
cast(null as varchar)                        dose_unit_source_value
from @synthea_schema.medications m
join @cdm_schema.source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = m.code
 and srctostdvm.target_domain_id        = 'Drug'
 and srctostdvm.target_vocabulary_id    = 'RxNorm'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason is null
join @cdm_schema.source_to_source_vocab_map srctosrcvm
  on srctosrcvm.source_code             = m.code
 and srctosrcvm.source_vocabulary_id    = 'RxNorm'
left join @cdm_schema.final_visit_ids fv
  on fv.encounter_id                    = m.encounter
left join @synthea_schema.encounters e
  on m.encounter                        = e.id
 and m.patient                          = e.patient
left join @cdm_schema.provider pr 
  on e.provider                         = pr.provider_source_value
join @cdm_schema.person p
  on p.person_source_value              = m.patient

union all

select
p.person_id                                 person_id,
srctostdvm.target_concept_id                drug_concept_id,
i.date                                      drug_exposure_start_date,
i.date                                      drug_exposure_start_datetime,
i.date                                      drug_exposure_end_date,
i.date                                      drug_exposure_end_datetime,
i.date                                      verbatim_end_date,
32869                                       drug_type_concept_id,
cast(null as varchar)                       stop_reason,
0                                           refills,
0                                           quantity,
0                                           days_supply,
cast(null as varchar)                       sig,
0                                           route_concept_id,
0                                           lot_number, 
pr.provider_id                              provider_id,
fv.visit_occurrence_id_new                  visit_occurrence_id,
fv.visit_occurrence_id_new + 1000000        visit_detail_id,
i.code                                      drug_source_value,
srctosrcvm.source_concept_id                drug_source_concept_id,     
cast(null as varchar)                       route_source_value,
cast(null as varchar)                       dose_unit_source_value
from @synthea_schema.immunizations i
join @cdm_schema.source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = i.code
 and srctostdvm.target_domain_id        = 'Drug'
 and srctostdvm.target_vocabulary_id    = 'CVX'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason is null
join @cdm_schema.source_to_source_vocab_map srctosrcvm
  on srctosrcvm.source_code             = i.code
 and srctosrcvm.source_vocabulary_id    = 'CVX'
left join @cdm_schema.final_visit_ids fv
  on fv.encounter_id                    = i.encounter
left join @synthea_schema.encounters e
  on i.encounter                        = e.id
 and i.patient                          = e.patient
left join @cdm_schema.provider pr 
  on e.provider                         = pr.provider_source_value
join @cdm_schema.person p
  on p.person_source_value              = i.patient
 ) tmp
;
