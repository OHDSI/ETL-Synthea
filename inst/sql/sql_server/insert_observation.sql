
if object_id('observation_id_seq', 'U') is not null drop sequence observation_id_seq;
create sequence observation_id_seq start with 1;

insert into @cdm_schema.observation (
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
nextval('observation_id_seq'),        
p.person_id,                         
srctostdvm.target_concept_id,    
a.start,                         
a.start,
38000280,                 
cast(null as float),      
cast(null as varchar),    
0,                        
0,
0,
0,
(select fv.visit_occurrence_id_new from @cdm_schema.final_visit_ids fv
  where fv.encounter_id = a.encounter) visit_occurrence_id,
0,
a.code,
(
select srctosrcvm.source_concept_id
   from @cdm_schema.source_to_source_vocab_map srctosrcvm
  where srctosrcvm.source_code = a.code
    and srctosrcvm.source_vocabulary_id  = 'SNOMED'
),
cast(null as varchar),
cast(null as varchar)

from @synthea_schema.allergies a
join @cdm_schema.source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = a.code
 and srctostdvm.target_domain_id        = 'Observation'
 and srctostdvm.target_vocabulary_id    = 'SNOMED'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason IS NULL
join @cdm_schema.person p
  on p.person_source_value    = a.patient

union all

select
nextval('observation_id_seq'),        
p.person_id,                         
srctostdvm.target_concept_id,    
c.start,                         
c.start,
38000276,                 
cast(null as float),      
cast(null as varchar),    
0,                        
0,
0,
0,
(select fv.visit_occurrence_id_new from @cdm_schema.final_visit_ids fv
  where fv.encounter_id = c.encounter) visit_occurrence_id,
0,
c.code,
(
select srctosrcvm.source_concept_id
   from @cdm_schema.source_to_source_vocab_map srctosrcvm
  where srctosrcvm.source_code = c.code
    and srctosrcvm.source_vocabulary_id  = 'SNOMED'
),
cast(null as varchar),
cast(null as varchar)

from @synthea_schema.conditions c
join @cdm_schema.source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = c.code
 and srctostdvm.target_domain_id        = 'Observation'
 and srctostdvm.target_vocabulary_id    = 'SNOMED'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason IS NULL
join @cdm_schema.person p
  on p.person_source_value    = c.patient;