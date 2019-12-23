---
layout: default
title: Death
nav_order: 2
description: "Death mapping from cdm person"

---

# Death

## Reading from OMOP CDM table person

Filter
 
 - person.death_datetime is not null 

| Destination Field | Source field | Logic | Comment field |
| --- | --- | --- | --- |
| person_id | person_id |  |  |
| death_date | death_datetime |  |  |
| death_datetime | death_datetime | |  |
| death_type_concept_id |  | 38003569 | EHR record patient status "Deceased" |
| cause_concept_id |  |  |  |
| cause_source_value |  |  |  |
| cause_source_concept_id |  |  |  |
