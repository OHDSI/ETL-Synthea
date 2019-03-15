
insert into @cdm_schema.procedure_occurrence (
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
row_number()over(order by p.person_id),
p.person_id,
case when srctostdvm.target_concept_id is NULL then 0 else srctostdvm.target_concept_id end as target_concept_id,
pr.date,
pr.date,
38000275,
0,
cast(null as integer),
cast(null as integer),
(select fv.visit_occurrence_id_new from @cdm_schema.final_visit_ids fv
  where fv.encounter_id = pr.encounter) visit_occurrence_id,
0,
pr.code,
(
select case when source_concept_id is NULL then 0 else source_concept_id end as source_concept_id
from (
		select srctosrcvm.source_concept_id
	   from @vocab_schema.source_to_source_vocab_map srctosrcvm
	  where srctosrcvm.source_code = pr.code
	    and srctosrcvm.source_vocabulary_id  = 'SNOMED'
	    ) a
),
NULL

from @synthea_schema.procedures pr
join @vocab_schema.source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = pr.code
 and srctostdvm.target_domain_id        = 'Procedure'
 and srctostdvm.target_vocabulary_id    = 'SNOMED'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason IS NULL
join @cdm_schema.person p
  on p.person_source_value    = pr.patient;
