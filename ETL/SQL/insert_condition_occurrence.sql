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
select nextval('condition_occurrence_id_seq'),
p.person_id,
case when srctostdvm.target_concept_id is NULL then 0 else srctostdvm.target_concept_id end as target_concept_id,
c.start,
c.start,
c.stop,
c.stop,
32020,
cast(null as varchar),
cast(null as integer),
(select fv.visit_occurrence_id_new from final_visit_ids fv
  where fv.encounter_id = c.encounter) visit_occurrence_id,
0,
c.code,
(
	select case when source_concept_id is null then 0 else source_concept_id end as source_concept_id
	from (
		select srctosrcvm.source_concept_id
	   from source_to_source_vocab_map srctosrcvm
	  where srctosrcvm.source_code = c.code
	    and srctosrcvm.source_vocabulary_id  = 'SNOMED'
	    ) a
),
NULL,
0
from conditions c
left join source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = c.code
 and srctostdvm.target_domain_id        = 'Condition'
 and srctostdvm.target_vocabulary_id    = 'SNOMED'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason IS NULL
join person p
  on c.patient = p.person_source_value;
