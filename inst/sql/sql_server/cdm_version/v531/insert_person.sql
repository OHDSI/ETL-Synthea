
insert into @cdm_schema.person (
person_id,
gender_concept_id,
year_of_birth,
month_of_birth,
day_of_birth,
birth_datetime,
race_concept_id,
ethnicity_concept_id,
location_id,
provider_id,
care_site_id,
person_source_value,
gender_source_value,
gender_source_concept_id,
race_source_value,
race_source_concept_id,
ethnicity_source_value,
ethnicity_source_concept_id
)
with mapped_states as (

	select distinct l.location_id,l.city,states_map.state,l.zip
	from @cdm_schema.location l
	left join @cdm_schema.states_map states_map on l.state=states_map.state_abbreviation
)
select
	row_number()over(order by p.id),
	case upper(p.gender)
		when 'M' then 8507
		when 'F' then 8532
	end,
	YEAR(p.birthdate),
	MONTH(p.birthdate),
	DAY(p.birthdate),
	p.birthdate,
	case upper(p.race)
		when 'WHITE' then 8527
		when 'BLACK' then 8516
		when 'ASIAN' then 8515
	else 0
	end,
    case
      when Upper(p.ethnicity) = 'HISPANIC' then 38003563
      when Upper(p.ethnicity) = 'NONHISPANIC' then 38003564
      else 0
    end,
	l.location_id,
	NULL,
	NULL,
	p.id,
	p.gender,
	0,
	p.race,
	0,
	p.ethnicity,
	0
	from @synthea_schema.patients p
	left join mapped_states l on p.city = l.city and p.state=l.state and p.zip=l.zip
	where p.gender is not null;
