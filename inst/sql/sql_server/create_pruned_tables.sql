-- we prune the vocabulary tables
create table @vocab_schema.concept with (distribution = round_robin) as select * from @vocab_schema.concept_orig where concept_id in (@event_concept_id);
create table @vocab_schema.concept_ancestor with (distribution = round_robin) as select * from @vocab_schema.concept_ancestor_orig where descendant_concept_id in (@event_concept_id);
create table @vocab_schema.concept_class with (distribution = round_robin) as select * from @vocab_schema.concept_class_orig where concept_class_concept_id in (@event_concept_id);
create table @vocab_schema.concept_synonym with (distribution = round_robin) as select * from @vocab_schema.concept_synonym_orig where concept_id in (@event_concept_id);
create table @vocab_schema.concept_relationship with (distribution = round_robin) as select * from @vocab_schema.concept_relationship_orig where concept_id_1 in (@event_concept_id);
create table @vocab_schema.source_to_concept_map with (distribution = round_robin) as select * from @vocab_schema.source_to_concept_map_orig where source_concept_id in (@event_concept_id);

-- we prune the event tables of all unmapped concepts
delete from @cdm_schema.drug_exposure where drug_concept_id = 0;
delete from @cdm_schema.condition_occurrence where condition_concept_id = 0;
delete from @cdm_schema.measurement where measurement_concept_id = 0;
delete from @cdm_schema.procedure_occurrence where procedure_concept_id = 0;
delete from @cdm_schema.observation where observation_concept_id = 0;
delete from @cdm_schema.device_exposure where device_concept_id = 0;



