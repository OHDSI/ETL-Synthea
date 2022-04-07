insert into @cdm_schema.person
            (person_id,
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
             ethnicity_source_concept_id)
select row_number() over(order by p.id),
       case Upper(p.gender)
         when 'M' then 8507
         when 'F' then 8532
       end,
       Year(p.birthdate),
       Month(p.birthdate),
       Day(p.birthdate),
       p.birthdate,
       case Upper(p.race)
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
       NULL,
       NULL,
       NULL,
       p.id,
       p.gender,
       0,
       p.race,
       0,
       p.ethnicity,
       0
from   @synthea_schema.patients p
where  p.gender is not null;
