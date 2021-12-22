

insert into @cdm_schema.device_exposure (
  device_exposure_id,
  person_id,
  device_concept_id,
  device_exposure_start_date,
  device_exposure_start_datetime,
  device_exposure_end_date,
  device_exposure_end_datetime,
  device_type_concept_id,
  unique_device_id,
  quantity,
  provider_id,
  visit_occurrence_id,
  visit_detail_id,
  device_source_value,
  device_source_concept_id
)

select row_number()over(order by person_id) device_exposure_id,
p.person_id                                 person_id,
srctostdvm.target_concept_id                device_concept_id,
d.start                                     device_exposure_start_date,
d.start                                     device_exposure_start_datetime,
d.stop                                      device_exposure_end_date,
d.stop                                      device_exposure_end_datetime,
38000267                                    device_type_concept_id,
d.udi                                       unique_device_id,
cast(null as int)                           quantity,
pr.provider_id                              provider_id,
fv.visit_occurrence_id_new                  visit_occurrence_id,
fv.visit_occurrence_id_new+1000000          visit_detail_id,
d.code                                      device_source_value,
srctosrcvm.source_concept_id                device_source_concept_id

from @synthea_schema.devices d
join @cdm_schema.source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = d.code
 and srctostdvm.target_domain_id        = 'Device'
 and srctostdvm.target_vocabulary_id    = 'SNOMED'
 and srctostdvm.source_vocabulary_id    = 'SNOMED'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason is null
join @cdm_schema.source_to_source_vocab_map srctosrcvm
  on srctosrcvm.source_code             = d.code
 and srctosrcvm.source_vocabulary_id    = 'SNOMED'
left join @cdm_schema.final_visit_ids fv
  on fv.encounter_id                    = d.encounter
left join @synthea_schema.encounters e
  on d.encounter                        = e.id
 and d.patient                          = e.patient
left join @cdm_schema.provider pr 
  on e.provider                         = pr.provider_source_value
join @cdm_schema.person p
  on p.person_source_value              = d.patient
;

