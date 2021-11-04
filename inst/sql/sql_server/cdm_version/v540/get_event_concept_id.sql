select distinct condition_concept_id as concept_id from @cdm_schema.condition_occurrence
union
select distinct procedure_concept_id               from @cdm_schema.procedure_occurrence
union
select distinct drug_concept_id                    from @cdm_schema.drug_exposure
union
select distinct measurement_concept_id             from @cdm_schema.measurement
union
select distinct observation_concept_id             from @cdm_schema.observation
union
select distinct visit_concept_id                   from @cdm_schema.visit_occurrence
union
select distinct drug_concept_id                    from @cdm_schema.drug_era
union
select distinct condition_concept_id               from @cdm_schema.condition_era;


