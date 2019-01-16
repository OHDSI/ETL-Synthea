drop sequence if exists observation_period_id_seq;
create sequence observation_period_id_seq start with 1;

insert into observation_period (
observation_period_id,
person_id,
observation_period_start_date,
observation_period_end_date,
period_type_concept_id
)
select nextval('observation_period_id_seq') observation_period_id,
       person_id,
	   start_date,
	   end_date,
	   44814724 period_type_concept_id 
  from (
select p.person_id,
       min(e.start) start_date,
	   max(e.start) end_date
  from person p
  join encounters e
    on p.person_source_value = e.patient
 group by p.person_id
       ) tmp;
