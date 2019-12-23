INSERT INTO @cdm_schema.death
(
    person_id,
    death_date,
    death_datetime,
    death_type_concept_id,
    cause_concept_id,
    cause_source_value,
    cause_source_concept_id
)
SELECT
    person_id,
    death_datetime,
    death_datetime,
    38003569,
    NULL,
    NULL,
    NULL
FROM @cdm_schema.person
WHERE person.death_datetime IS NOT NULL
;
