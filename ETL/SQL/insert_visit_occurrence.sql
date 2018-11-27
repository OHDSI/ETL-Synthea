drop sequence if exists visit_occurrence_id_seq;
create sequence visit_occurrence_id_seq start with 1;

insert into visit_occurrence (
visit_occurrence_id,
person_id,
visit_concept_id,
visit_start_date,
visit_start_datetime,
visit_end_date,
visit_end_datetime,
visit_type_concept_id,
provider_id,
care_site_id,
visit_source_value,
visit_source_concept_id,
admitting_source_concept_id,
admitting_source_value,
discharge_to_concept_id,
discharge_to_source_value,
preceding_visit_occurrence_id
)
select
nextval('visit_occurrence_id_seq'),   -- visit_occurrence_id
p.person_id,                          -- person_id

case when position('emergency' in lower(e.description)) > 1 then 9203
     when position('hospital'  in lower(description))   > 1 then 9201
	 else 9201
end,                                  -- visit_concept_id
e.start,                              -- visit_start_date,
null,                                 -- visit_start_datetime,
e.start,                              -- visit_end_date,
null,                                 -- visit_end_datetime,
44818517,                             -- visit_type_concept_id
null,                                 -- provider_id,
null,                                 -- care_site_id,

case when position('emergency' in lower(e.description)) > 1 then 'ER'
     when position('hospital'  in lower(description))   > 1 then 'IP'
	 else 'OP'
end,                                     -- visit_source_value,
0,                                       -- visit_source_concept_id,
vm.target_concept_id,                    -- admitting_source_concept_id,
e.id,                                    -- admitting_source_value,
0,                                       -- discharge_to_concept_id,
null,                                    -- discharge_to_source_value,
lag(currval('visit_occurrence_id_seq'))  -- preceding_visit_occurrence_id
 over(partition by p.person_id
	      order by e.start)

from encounters e
join person p
  on e.patient = p.person_source_value
join vocab_map vm
  on e.code    = vm.source_code
where vm.source_vocabulary_id = 'SNOMED';
