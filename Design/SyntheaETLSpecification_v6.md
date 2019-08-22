# Source Data Mapping Approach to CDMV6.0

![](SyntheaETLSpecification_v6_files/image1.png)

## Table name: condition_occurrence

### Reading from conditions.csv

![](SyntheaETLSpecification_v6_files/image2.png)

| Destination Field | Source field | Logic | Comment field |
| --- | --- | --- | --- |
| condition_occurrence_id |  |  |  |
| person_id | patient | Map by mapping person.person_source_value to patient.  Find person.person_id by mapping encouters.patient to person.person_source_value. |  |
| condition_concept_id | code | Use the following SQL code to lookup target_concept_id in CTE_TARGET_VOCAB_MAP:    select ctvm.target_concept_id    from conditions c     join cte_target_vocab_map ctvm       on ctvm.source_code              = c.code     and ctvm.target_domain_id       = 'Condition'     and ctvm.target_vocabulary_id = 'SNOMED'     and ctvm.target_invalid_reason is NULL     and ctvm.target_standard_concept = 'S' |  |
| condition_start_date | start |  |  |
| condition_start_datetime | start |  |  |
| condition_end_date | stop |  |  |
| condition_end_datetime | stop |  |  |
| condition_type_concept_id |  | Set to 32020 (EHR Encounter Diagnosis) for all records |  |
| stop_reason |  |  |  |
| provider_id |  |  |  |
| visit_occurrence_id | encounter | Lookup visit_occurrence_id using encounter, joining to temp table defined in AllVisitTable.sql. |  |
| visit_detail_id |  |  |  |
| condition_source_value | code |  |  |
| condition_source_concept_id | code | Use the following SQL code to lookup the source_concept_id in CTE_SOURCE_VOCAB_MAP:     select csvm.source_concept_id     from cte_source_vocab_map csvm      join conditions c        on csvm.source_code                 = c.code      and csvm.source_vocabulary_id  = 'SNOMED' |  |
| condition_status_source_value |  |  |  |
| condition_status_concept_id |  |  |  |

## Table name: device_exposure

## Table name: drug_exposure

### Reading from conditions.csv

![](SyntheaETLSpecification_v6_files/image3.png)

| Destination Field | Source field | Logic | Comment field |
| --- | --- | --- | --- |
| drug_exposure_id |  |  |  |
| person_id | patient | Map by mapping person.person_source_value to patient.  Find person.person_id by mapping encouters.patient to person.person_source_value. |  |
| drug_concept_id | code | Use code to lookup target_concept_id in CTE_TARGET_VOCAB_MAP:    select ctvm.target_concept_id    from conditions c     join cte_target_vocab_map ctvm       on ctvm.source_code              = c.code     and ctvm.target_domain_id       = 'Drug'     and ctvm.target_vocabulary_id = 'RxNorm'     and ctvm.target_standard_concept = 'S'     and ctvm.target_invalid_reason is NULL |  |
| drug_exposure_start_date | start |  |  |
| drug_exposure_start_datetime | start |  |  |
| drug_exposure_end_date | stop |  |  |
| drug_exposure_end_datetime | stop |  |  |
| verbatim_end_date | stop |  |  |
| drug_type_concept_id |  |  | Use the concept_id 581452 for all records from the immunizations and conditions tables and concept_id 38000177 for all records from the medications table.  |
| stop_reason |  |  |  |
| refills |  |  |  |
| quantity |  |  |  |
| days_supply |  |  |  |
| sig |  |  |  |
| route_concept_id |  |  |  |
| lot_number |  |  |  |
| provider_id |  |  |  |
| visit_occurrence_id | encounter | Lookup visit_occurrence_id using encounter, joining to temp table defined in AllVisitTable.sql. |  |
| visit_detail_id |  |  |  |
| drug_source_value | code |  |  |
| drug_source_concept_id | code | Use code to lookup source_concept_id in CTE_SOURCE_VOCAB_MAP:     select csvm.source_concept_id     from cte_source_vocab_map csvm      join conditions c        on csvm.source_code                 = c.code      and csvm.source_vocabulary_id  = 'SNOMED' |  |
| route_source_value |  |  |  |
| dose_unit_source_value |  |  |  |

### Reading from immunizations.csv

![](SyntheaETLSpecification_v6_files/image4.png)

| Destination Field | Source field | Logic | Comment field |
| --- | --- | --- | --- |
| drug_exposure_id |  |  |  |
| person_id | patient | Map by mapping person.person_source_value to patient.  Find person.person_id by mapping immunizations.patient to person.person_source_value. |  |
| drug_concept_id | code | Use code to lookup target_concept_id in CTE_TARGET_VOCAB_MAP:    select ctvm.target_concept_id    from immunizations i     join cte_target_vocab_map ctvm       on ctvm.source_code               = i.code     and ctvm.target_domain_id        = 'Drug'     and ctvm.target_vocabulary_id = 'CVX'     and ctvm.target_standard_concept = 'S'     and ctvm.target_invalid_reason is NULL |  |
| drug_exposure_start_date | date |  |  |
| drug_exposure_start_datetime | date | Use 00:00:00 as the time. |  |
| drug_exposure_end_date | date |  |  |
| drug_exposure_end_datetime | date | Use 00:00:00 as the time. |  |
| verbatim_end_date | date |  |  |
| drug_type_concept_id |  |  |Use the concept_id 581452 for all records from the immunizations and conditions tables and concept_id 38000177 for all records from the medications table.   |
| stop_reason |  |  |  |
| refills |  |  |  |
| quantity |  |  |  |
| days_supply |  |  |  |
| sig |  |  |  |
| route_concept_id |  |  |  |
| lot_number |  |  |  |
| provider_id |  |  |  |
| visit_occurrence_id | encounter | Lookup visit_occurrence_id using encounter, joining to temp table defined in AllVisitTable.sql. |  |
| visit_detail_id |  |  |  |
| drug_source_value | code |  |  |
| drug_source_concept_id | code | Use code to lookup target_concept_id in CTE_SOURCE_VOCAB_MAP:    select csvm.source_concept_id    from immunizations i     join cte_source_vocab_map csvm      on csvm.source_code                = i.code     and csvm.source_vocabulary_id = 'CVX' |  |
| route_source_value |  |  |  |
| dose_unit_source_value |  |  |  |

### Reading from medications.csv




![](SyntheaETLSpecification_v6_files/image5.png)

| Destination Field | Source field | Logic | Comment field |
| --- | --- | --- | --- |
| drug_exposure_id |  |  |  |
| person_id | patient | Map by mapping person.person_source_value to patient.  Find person.person_id by mapping  medications.patient to person.person_source_value. |  |
| drug_concept_id | code | Use code to lookup target_concept_id in CTE_TARGET_VOCAB_MAP:    select ctvm.target_concept_id    from medications m     join cte_target_vocab_map ctvm       on ctvm.source_code               = m.code     and ctvm.target_domain_id        = 'Drug'     and ctvm.target_vocabulary_id  = 'RxNorm'     and ctvm.target_standard_concept = 'S'     and ctvm.target_invalid_reason is NULL |  |
| drug_exposure_start_date | start |  |  |
| drug_exposure_start_datetime | start | Use 00:00:00 as the time. |  |
| drug_exposure_end_date | stop  start |  |  |
| drug_exposure_end_datetime | stop  start | Use 00:00:00 as the time. |  |
| verbatim_end_date | stop |  |  |
| drug_type_concept_id |  |  | Use the concept_id 581452 for all records from the immunizations and conditions tables and concept_id 38000177 for all records from the medications table.  |
| stop_reason |  |  |  |
| refills |  |  |  |
| quantity |  |  |  |
| days_supply | start  stop |  |  |
| sig |  |  |  |
| route_concept_id |  |  |  |
| lot_number |  |  |  |
| provider_id |  |  |  |
| visit_occurrence_id | encounter | Lookup visit_occurrence_id using encounter, joining to temp table defined in AllVisitTable.sql. |  |
| visit_detail_id |  |  |  |
| drug_source_value | code |  |  |
| drug_source_concept_id | code | Use code to lookup target_concept_id in CTE_SOURCE_VOCAB_MAP:    select csvm.source_concept_id    from medications m     join cte_source_vocab_map csvm      on cvm.source_code                = m.code      and cvm.source_vocabulary_id = 'RxNorm' |  |
| route_source_value |  |  |  |
| dose_unit_source_value |  |  |  |

## Table name: fact_relationship

## Table name: measurement

### Reading from observations.csv

![](SyntheaETLSpecification_v6_files/image6.png)

| Destination Field | Source field | Logic | Comment field |
| --- | --- | --- | --- |
| measurement_id |  |  |  |
| person_id | patient | Map by mapping person.person_source_value to patient.  Find person.person_id by mapping encouters.patient to person.person_source_value. |  |
| measurement_concept_id | code | Use code to lookup target_concept_id in CTE_TARGET_VOCAB_MAP:    select ctvm.target_concept_id    from observations o     join cte_target_vocab_map ctvm       on ctvm.source_code              = o.code     and ctvm.target_domain_id       = 'Measurement'     and ctvm.target_standard_concept = 'S'     and ctvm.target_invalid_reason is NULL |  |
| measurement_date | date |  |  |
| measurement_datetime | date | Use 00:00:00 as time. |  |
| measurement_time |  |  |  |
| measurement_type_concept_id |  |  |Use concept_id 5001 for all records  |
| operator_concept_id |  |  |  |
| value_as_number | value |  |  |
| value_as_concept_id |  |  |  |
| unit_concept_id |  |  |  |
| range_low |  |  |  |
| range_high |  |  |  |
| provider_id |  |  |  |
| visit_occurrence_id | code | Lookup visit_occurrence_id using encounter, joining to temp table defined in AllVisitTable.sql. |  |
| visit_detail_id |  |  |  |
| measurement_source_value | code |  |  |
| measurement_source_concept_id | code | Use code to lookup source_concept_id in CTE_SOURCE_VOCAB_MAP:     select csvm.source_concept_id     from cte_source_vocab_map csvm      join observations o        on csvm.source_code                 = o.code      and csvm.source_vocabulary_id  = 'SNOMED' |  |
| unit_source_value | units |  |  |
| value_source_value | value |  |  |

### Reading from procedures.csv

![](SyntheaETLSpecification_v6_files/image7.png)

| Destination Field | Source field | Logic | Comment field |
| --- | --- | --- | --- |
| measurement_id |  |  |  |
| person_id | patient | Lookup in the person table: map by mapping person.person_source_value to patient. |  |
| measurement_concept_id | code | Use code to lookup target_concept_id in CTE_TARGET_VOCAB_MAP:    select ctvm.target_concept_id    from procedures pr     join cte_target_vocab_map ctvm       on ctvm.source_code              = pr.code     and ctvm.target_domain_id       = 'Measurement'     and ctvm.target_vocabulary_id = 'SNOMED'     and ctvm.target_standard_concept = 'S'     and ctvm.target_invalid_reason is NULL |  |
| measurement_date | date |  |  |
| measurement_datetime | date | Use 00:00:00 as the time. |  |
| measurement_time | date |  |  |
| measurement_type_concept_id |  |  |Use concept_id 5001 for all records  |
| operator_concept_id |  |  |  |
| value_as_number |  |  |  |
| value_as_concept_id |  |  |  |
| unit_concept_id |  |  |  |
| range_low |  |  |  |
| range_high |  |  |  |
| provider_id |  |  |  |
| visit_occurrence_id | encounter | Lookup visit_occurrence_id using encounter, joining to temp table defined in AllVisitTable.sql. |  |
| visit_detail_id |  |  |  |
| measurement_source_value | code |  |  |
| measurement_source_concept_id | code | Use code to lookup source_concept_id in CTE_SOURCE_VOCAB_MAP:     select csvm.source_concept_id     from cte_source_vocab_map csvm      join procedures pr        on csvm.source_code                 = pr.code        and csvm.source_vocabulary_id  = 'SNOMED' |  |
| unit_source_value |  |  |  |
| value_source_value |  |  |  |

## Table name: note

## Table name: note_nlp

## Table name: observation

### Reading from allergies.csv

![](SyntheaETLSpecification_v6_files/image8.png)

| Destination Field | Source field | Logic | Comment field |
| --- | --- | --- | --- |
| observation_id |  |  |  |
| person_id | patient | Map by mapping person.person_source_value to patient.  Find person.person_id by mapping allergies.patient to person.person_source_value. |  |
| observation_concept_id | code | Use code to lookup target_concept_id in CTE_TARGET_VOCAB_MAP:    select ctvm.target_concept_id    from allergies a     join cte_target_vocab_map ctvm       on ctvm.source_code              = a.code     and ctvm.target_domain_id       = 'Observation'     and ctvm.target_vocabulary_id = 'SNOMED'     and ctvm.target_standard_concept = 'S'     and ctvm.target_invalid_reason is NULL |  |
| observation_date | start |  |  |
| observation_datetime | start | Use 00:00:00 as time. |  |
| observation_type_concept_id |  | Set as 38000280 for all records. |  |
| value_as_number |  |  |  |
| value_as_string |  |  |  |
| value_as_concept_id |  |  |  |
| qualifier_concept_id |  |  |  |
| unit_concept_id |  |  |  |
| provider_id |  |  |  |
| visit_occurrence_id | encounter | Lookup visit_occurrence_id using encounter, joining to temp table defined in AllVisitTable.sql. |  |
| visit_detail_id |  |  |  |
| observation_source_value | code |  |  |
| observation_source_concept_id | code | Use code to lookup source_concept_id in CTE_SOURCE_VOCAB_MAP:     select csvm.source_concept_id     from cte_source_vocab_map csvm      join allergies a        on csvm.source_code                 = a.code      and csvm.source_vocabulary_id  = 'SNOMED' |  |
| unit_source_value |  |  |  |
| qualifier_source_value |  |  |  |
| observation_event_id |  |  |  |
| obs_event_field_concept_id |  |  |  |
| value_as_datetime |  |  |  |

### Reading from conditions.csv

![](SyntheaETLSpecification_v6_files/image9.png)

| Destination Field | Source field | Logic | Comment field |
| --- | --- | --- | --- |
| observation_id |  |  |  |
| person_id | patient | Map by mapping person.person_source_value to patient.  Find person.person_id by mapping encouters.patient to person.person_source_value. |  |
| observation_concept_id | code | Use code to lookup target_concept_id in CTE_TARGET_VOCAB_MAP:    select ctvm.target_concept_id    from conditions c     join cte_target_vocab_map ctvm       on ctvm.source_code              = c.code     and ctvm.target_domain_id       = 'Observation'     and ctvm.target_vocabulary_id = 'SNOMED'     and ctvm.target_standard_concept = 'S'     and ctvm.target_invalid_reason is NULL |  |
| observation_date | start |  |  |
| observation_datetime | start |  |  |
| observation_type_concept_id |  | Set as 38000280 for all records. |  |
| value_as_number |  |  |  |
| value_as_string |  |  |  |
| value_as_concept_id |  |  |  |
| qualifier_concept_id |  |  |  |
| unit_concept_id |  |  |  |
| provider_id |  |  |  |
| visit_occurrence_id | encounter | Lookup visit_occurrence_id using encounter, joining to temp table defined in AllVisitTable.sql. |  |
| visit_detail_id |  |  |  |
| observation_source_value | code |  |  |
| observation_source_concept_id | code | Use code to lookup source_concept_id in CTE_SOURCE_VOCAB_MAP:     select csvm.source_concept_id     from cte_source_vocab_map csvm      join conditions c        on csvm.source_code                 = c.code      and csvm.source_vocabulary_id  = 'SNOMED' |  |
| unit_source_value |  |  |  |
| qualifier_source_value |  |  |  |
| observation_event_id |  |  |  |
| obs_event_field_concept_id |  |  |  |
| value_as_datetime |  |  |  |

## Table name: observation_period

### Reading from encounters.csv

![](SyntheaETLSpecification_v6_files/image10.png)

| Destination Field | Source field | Logic | Comment field |
| --- | --- | --- | --- |
| observation_period_id |  |  |  |
| person_id | patient | Map by mapping person.person_source_value to patient.  Find person.person_id by mapping encouters.patient to person.person_source_value. |  |
| observation_period_start_date | start | min(start) group by patient  Take the earliest START per patient |  |
| observation_period_end_date | stop | max(stop) group by patient  Take the latest STOP per patient |  |
| period_type_concept_id |  |  | Set as concept 44814724 for all records |

## Table name: person

### Reading from patients.csv

![](SyntheaETLSpecification_v6_files/image11.png)

| Destination Field | Source field | Logic | Comment field |
| --- | --- | --- | --- |
| person_id |  |  |  |
| gender_concept_id | gender | When gender = ‘M’ then set gender_concept_id to 8507, when gender = ‘F’ then set to 8532 | Drop any rows with missing/unknown gender. |
| year_of_birth | birthdate | Take year from birthdate |  |
| month_of_birth | birthdate | Take month from birthdate |  |
| day_of_birth | birthdate | Take day from birthdate |  |
| birth_datetime | birthdate | With midnight as time 00:00:00 |  |
| death_datetime | deathdate | With midnight as time 00:00:00 |  |
| race_concept_id | race | When race = ‘WHITE’ then set as 8527, when race = ‘BLACK’ then set as 8516, when race = ‘ASIAN’ then set as 8515, otherwise set as 0 |  |
| ethnicity_concept_id | race  ethnicity | When race = ‘HISPANIC’, or when ethnicity in (‘CENTRAL_AMERICAN’, ‘DOMINICAN’, ‘MEXICAN’, ‘PUERTO_RICAN’, ‘SOUTH_AMERICAN’ ) then set as 38003563, otherwise set as 0  When race = ‘HISPANIC’, or when ethnicity in (‘CENTRAL_AMERICAN’, ‘DOMINICAN’, ‘MEXICAN’, ‘PUERTO_RICAN’, ‘SOUTH_AMERICAN’ ) then set as 38003563, otherwise set as 0 |  |
| location_id |  |  |  |
| provider_id |  |  |  |
| care_site_id |  |  |  |
| person_source_value | id |  |  |
| gender_source_value | gender |  |  |
| gender_source_concept_id |  |  |  |
| race_source_value | race |  |  |
| race_source_concept_id |  |  |  |
| ethnicity_source_value | ethnicity |  |  |
| ethnicity_source_concept_id |  |  |  |

## Table name: procedure_occurrence

### Reading from procedures.csv






![](SyntheaETLSpecification_v6_files/image12.png)

| Destination Field | Source field | Logic | Comment field |
| --- | --- | --- | --- |
| procedure_occurrence_id |  |  |  |
| person_id | patient | Map by mapping person.person_source_value to patient.  Find person.person_id by mapping encouters.patient to person.person_source_value. |  |
| procedure_concept_id | code | Use code to lookup target_concept_id in CTE_TARGET_VOCAB_MAP:    select ctvm.target_concept_id    from procedures pr     join cte_target_vocab_map ctvm       on ctvm.source_code              = pr.code     and ctvm.target_domain_id       = 'Procedure'     and ctvm.target_vocabulary_id = 'SNOMED'     and ctvm.target_invalid_reason is NULL     and ctvm.target_standard_concept = 'S' |  |
| procedure_date | date |  |  |
| procedure_datetime | date | Use 00:00:00 as the time. |  |
| procedure_type_concept_id |  |  | Use concept_id 38000275 for all records. |
| modifier_concept_id |  |  |  |
| quantity |  |  |  |
| provider_id |  |  |  |
| visit_occurrence_id | encounter | Lookup visit_occurrence_id using encounter, joining to temp table defined in AllVisitTable.sql. |  |
| visit_detail_id |  |  |  |
| procedure_source_value | code |  |  |
| procedure_source_concept_id | code | Use code to lookup source_concept_id in CTE_SOURCE_VOCAB_MAP:     select csvm.source_concept_id     from cte_source_vocab_map csvm      join procedures pr        on csvm.source_code                 = pr.code      and csvm.source_vocabulary_id  = 'SNOMED' |  |
| modifier_source_value |  |  |  |

## Table name: specimen

## Table name: visit_detail

## Table name: visit_occurrence

### Reading from encounters.csv

STEP 1
For encounterclass = ‘Inpatient’ (IP):

Sort data in ascending order by PATIENT, START, END.
Then by PERSON_ID, collapse lines of claim as long as the time between the END of one line and the START of the next is <=1 day.
Each consolidated inpatient claim is then considered as one inpatient visit, set
MIN(START) as VISIT_START_DATE
MAX(END) as VISIT_END_DATE
‘IP’ as PLACE_OF_SERVICE_SOURCE_VALUE
See if any records with encounterclass ‘outpatient’ (OP), ‘ambulatory’ (OP), ‘wellness’ (OP), ‘emergency’ (ER) or ‘urgentcare’ (ER) occur during an identified ‘inpatient’ visit. These should be consolidated into the ‘inpatient’ visit, unless it is an ‘emergency’ or ‘urgentcare’ visit that starts and ends on the first day of the ‘inpatient’ visit. Types of outpatient (OP) visits not collapsed:
If an OP starts before an IP but ends during an IP
If an OP starts before and ends after an IP visit. If an OP is collapsed into an IP and its VISIT_END_DATE is greater than the IP’s VISIT_END_DATE it does not change the IP VISIT_END_DATE.
For claim type in (‘emergency’,’urgentcare’) (ER)

Sort data in ascending order by PATIENT, START, END.
Then by PERSON_ID, collapse all (ER) claims that start on the same day as one ER visit, then take START as VISIT_START_DATE, MAX (END) as VISIT_END_DATE, and ‘ER’ as PLACE_OF_SERVICE_SOURCE_VALUE.
For claim type in (‘ambulatory’, ‘wellness’, ‘outpatient’) (OP)

Sort data in ascending order by PATIENT, START, END.
Then by PERSON_ID take START as VISIT_START_DATE, MAX(END) as VISIT_END_DATE, and ‘OP’ as PLACE_OF_SERVICE_SOURCE_VALUE.
Use logic found here: https://github.com/OHDSI/ETL-Synthea/blob/master/ETL/SQL/AllVisitTable.sql

![](SyntheaETLSpecification_v6_files/image13.png)

| Destination Field | Source field | Logic | Comment field |
| --- | --- | --- | --- |
| visit_occurrence_id |  |  |  |
| person_id | patient | Map by mapping person.person_source_value to patient.  Find person.person_id by mapping encouters.patient to person.person_source_value. |  |
| visit_concept_id | encounterclass | When encounterclass is 'emergency' or 'urgentcare' then set to 9203. When encounterclass is 'ambulatory', 'wellness', or 'outpatient' then set to 9202. When encounterclass is 'inpatient' then set to 9201. Otherwise set to 0. |  |
| visit_start_date | start |  |  |
| visit_start_datetime | start |  |  |
| visit_end_date | stop |  |  |
| visit_end_datetime | stop |  |  |
| visit_type_concept_id |  |  | Set all records as concept_id 44818517. |
| provider_id |  |  |  |
| care_site_id |  |  |  |
| visit_source_value | encounterclass |  |  |
| visit_source_concept_id |  |  |  |
| admitted_from_concept_id |  |  |  |
| admitted_from_source_value |  |  |  |
| discharge_to_concept_id |  |  |  |
| discharge_to_source_value |  |  |  |
| preceding_visit_occurrence_id |  |  |  |

## Table name: cohort

## Table name: condition_era

## Table name: dose_era

## Table name: drug_era

## Table name: cost

## Table name: payer_plan_period

## Table name: care_site

## Table name: location

## Table name: provider

## Table name: cdm_source

## Table name: metadata

## Table name: cohort_definition

## Table name: survey_conduct

## Table name: location_history

