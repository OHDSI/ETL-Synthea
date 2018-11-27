
insert into death (
person_id,
death_date,
death_datetime,
death_type_concept_id,
cause_concept_id,
cause_source_value,
cause_source_concept_id
)
select
pe.person_id,   -- person_id,
pa.deathdate,         -- death_date,
null,           -- death_datetime,
0,              -- death_type_concept_id,
0,              -- cause_concept_id,
e.code,         -- cause_source_value
c.concept_id    -- cause_source_concept_id
 from concept c
 join encounters e
   on c.concept_code = e.code
 join person pe
   on pe.person_source_value = e.patient
 join patients pa
   on e.patient = pa.id
where pa.deathdate is not null
  and e.code = '308646001';
