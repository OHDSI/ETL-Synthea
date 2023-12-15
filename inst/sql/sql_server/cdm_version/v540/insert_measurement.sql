
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
value_source_value,
unit_source_concept_id,
measurement_event_id,
meas_event_field_concept_id
)
select row_number()over(order by person_id) measurement_id,
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
value_source_value,
unit_source_concept_id,
measurement_event_id,
meas_event_field_concept_id

from (
select
  p.person_id                              person_id,
  srctostdvm.target_concept_id             measurement_concept_id,

{@synthea_version == "2.7.0"} ? {
  pr.date                                  measurement_date,
  pr.date                                  measurement_datetime,
  pr.date                                  measurement_time,
}

{@synthea_version == "3.0.0"} ? {
  pr.start                                 measurement_date,
  pr.start                                 measurement_datetime,
  pr.start                                 measurement_time,
}

  32827                                 measurement_type_concept_id,
  0                                        operator_concept_id,
  cast(null as float)                      value_as_number,
  0                                        value_as_concept_id,
  0                                        unit_concept_id,
  cast(null as float)                      range_low,
  cast(null as float)                      range_high,
  prv.provider_id                          provider_id,
  fv.visit_occurrence_id_new               visit_occurrence_id,
  fv.visit_occurrence_id_new + 1000000     visit_detail_id,
  pr.code                                  measurement_source_value,
  srctosrcvm.source_concept_id             measurement_source_concept_id,
  cast(null as varchar)                    unit_source_value,
  cast(null as varchar)                    value_source_value,
  cast(null as int)                        unit_source_concept_id,
  cast(null as bigint)                     measurement_event_id,
  cast(null as int)                        meas_event_field_concept_id

from @synthea_schema.procedures pr
join @cdm_schema.source_to_standard_vocab_map  srctostdvm
  on srctostdvm.source_code             = pr.code
 and srctostdvm.target_domain_id        = 'Measurement'
 and srctostdvm.source_vocabulary_id    = 'SNOMED'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason is null
join @cdm_schema.source_to_source_vocab_map srctosrcvm
  on srctosrcvm.source_code             = pr.code
 and srctosrcvm.source_vocabulary_id    = 'SNOMED'
left join @cdm_schema.final_visit_ids fv
  on fv.encounter_id                    = pr.encounter
left join @synthea_schema.encounters e
  on pr.encounter                       = e.id
 and pr.patient                         = e.patient
left join @cdm_schema.provider prv
  on e.provider                         = prv.provider_source_value
join @cdm_schema.person p
  on p.person_source_value              = pr.patient

union all

select
  p.person_id                               person_id,
  srctostdvm.target_concept_id              measurement_concept_id,
  o.date                                    measurement_date,
  o.date                                    measurement_datetime,
  o.date                                    measurement_time,
  32827                                  measurement_type_concept_id,
  0                                         operator_concept_id,
  case
  when isnumeric(o.value) = 1
  then cast(o.value as float)
  else cast(null as float)
  end                                       value_as_number,
  coalesce(srcmap2.target_concept_id,0)     value_as_concept_id,
  coalesce(srcmap1.target_concept_id,0)     unit_concept_id,
  cast(null as float)                       range_low,
  cast(null as float)                       range_high,
  pr.provider_id                            provider_id,
  fv.visit_occurrence_id_new                visit_occurrence_id,
  fv.visit_occurrence_id_new + 1000000      visit_detail_id,
  o.code                                    measurement_source_value,
  coalesce(srctosrcvm.source_concept_id,0)  measurement_source_concept_id,
  o.units                                   unit_source_value,
  o.value                                   value_source_value,
  cast(null as int)                         unit_source_concept_id,
  cast(null as bigint)                      measurement_event_id,
  cast(null as int)                         meas_event_field_concept_id

from @synthea_schema.observations o
join @cdm_schema.source_to_standard_vocab_map  srctostdvm
  on srctostdvm.source_code             = o.code
 and srctostdvm.target_domain_id        = 'Measurement'
 and srctostdvm.source_vocabulary_id    = 'LOINC'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason   is null
left join @cdm_schema.source_to_standard_vocab_map  srcmap1
  on srcmap1.source_code                = o.units
 and srcmap1.target_vocabulary_id       = 'UCUM'
 and srcmap1.source_vocabulary_id       = 'UCUM'
 and srcmap1.target_standard_concept    = 'S'
 and srcmap1.target_invalid_reason      is null
left join @cdm_schema.source_to_standard_vocab_map  srcmap2
  on srcmap2.source_code                = o.value
 and srcmap2.target_domain_id           = 'Meas value'
 and srcmap2.target_standard_concept    = 'S'
 and srcmap2.target_invalid_reason     is null
left join @cdm_schema.source_to_source_vocab_map srctosrcvm
  on srctosrcvm.source_code             = o.code
 and srctosrcvm.source_vocabulary_id    = 'LOINC'
left join @cdm_schema.final_visit_ids fv
  on fv.encounter_id                    = o.encounter
left join @synthea_schema.encounters e
  on o.encounter                        = e.id
 and o.patient                          = e.patient
left join @cdm_schema.provider pr
  on e.provider                         = pr.provider_source_value
join @cdm_schema.person p
  on p.person_source_value              = o.patient
  ) tmp
;
