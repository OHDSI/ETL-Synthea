
insert into @cdm_schema.person (
person_id,
gender_concept_id,
year_of_birth,
month_of_birth,
day_of_birth,
birth_datetime,
death_datetime,
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
	p.deathdate,
	case upper(p.race)
		when 'WHITE' then 8527
		when 'BLACK' then 8516
		when 'ASIAN' then 8515
	else 0
	end,
	case
		when upper(p.race) = 'HISPANIC'
		then 38003563 else 0
	end,
	NULL,
	0,
	NULL,
	p.id,
	p.gender,
	0,
	p.race,
	0,
	p.ethnicity,
	0
	from @synthea_schema.patients p
	where p.gender is not null;
