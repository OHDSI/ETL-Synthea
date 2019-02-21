/*Assign VISIT_OCCURRENCE_ID to all encounters*/

if object_id('@cdm_schema.ASSIGN_ALL_VISIT_IDS', 'U')  is not null drop table @cdm_schema.ASSIGN_ALL_VISIT_IDS;


SELECT  E.id AS encounter_id,
		E.patient as person_source_value,
		E.start AS date_service,
		E.stop AS date_service_end,
		E.encounterclass,
		AV.encounterclass AS VISIT_TYPE,
		AV.VISIT_START_DATE,
		AV.VISIT_END_DATE,
		AV.VISIT_OCCURRENCE_ID,
		CASE
			WHEN E.encounterclass = 'inpatient' and AV.encounterclass = 'inpatient'
				THEN VISIT_OCCURRENCE_ID
			WHEN E.encounterclass in ('emergency','urgent')
				THEN (
					CASE
						WHEN AV.encounterclass = 'inpatient' AND E.start > AV.VISIT_START_DATE
							THEN VISIT_OCCURRENCE_ID
						WHEN AV.encounterclass in ('emergency','urgent') AND E.start = AV.VISIT_START_DATE
							THEN VISIT_OCCURRENCE_ID
						ELSE NULL
					END
				)
			WHEN E.encounterclass in ('ambulatory', 'wellness', 'outpatient')
				THEN (
					CASE
						WHEN AV.encounterclass = 'inpatient' AND E.start >= AV.VISIT_START_DATE
							THEN VISIT_OCCURRENCE_ID
						WHEN AV.encounterclass in ('ambulatory', 'wellness', 'outpatient')
							THEN VISIT_OCCURRENCE_ID
						ELSE NULL
					END
				)
			ELSE NULL
		END AS VISIT_OCCURRENCE_ID_NEW
INTO @cdm_schema.ASSIGN_ALL_VISIT_IDS
FROM @synthea_schema.ENCOUNTERS E
JOIN @cdm_schema.ALL_VISITS AV
	ON E.patient = AV.patient
	AND E.start >= AV.VISIT_START_DATE
	AND E.start <= AV.VISIT_END_DATE;
