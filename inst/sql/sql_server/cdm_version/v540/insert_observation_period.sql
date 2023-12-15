

insert into @cdm_schema.observation_period (
observation_period_id,
person_id,
observation_period_start_date,
observation_period_end_date,
period_type_concept_id
)
select row_number()over(order by person_id),
       person_id,
	   start_date,
	   end_date,
	   32882 period_type_concept_id
  from (
select p.person_id,
       min(e.start) start_date,
	   max(e.stop) end_date
  from @cdm_schema.person p
  join @synthea_schema.encounters e
    on p.person_source_value = e.patient
 group by p.person_id
       ) tmp;
