
if object_id('@cdm_schema.IP_VISITS', 'U')  is not null drop table @cdm_schema.IP_VISITS;
if object_id('@cdm_schema.ER_VISITS', 'U')  is not null drop table @cdm_schema.ER_VISITS;
if object_id('@cdm_schema.OP_VISITS', 'U')  is not null drop table @cdm_schema.OP_VISITS;
if object_id('@cdm_schema.ALL_VISITS', 'U') is not null drop table @cdm_schema.ALL_VISITS;

/* Inpatient visits */
/* Collapse IP claim lines with <=1 day between them into one visit */

WITH CTE_END_DATES AS (
	SELECT patient, encounterclass, dateadd(day,-1,EVENT_DATE) AS END_DATE
	FROM (
		SELECT patient, encounterclass, EVENT_DATE, EVENT_TYPE,
			MAX(START_ORDINAL) OVER (PARTITION BY patient, encounterclass ORDER BY EVENT_DATE, EVENT_TYPE ROWS UNBOUNDED PRECEDING) AS START_ORDINAL,
			ROW_NUMBER() OVER (PARTITION BY patient, encounterclass ORDER BY EVENT_DATE, EVENT_TYPE) AS OVERALL_ORD
		FROM (
			SELECT patient, encounterclass, start AS EVENT_DATE, -1 AS EVENT_TYPE,
			       ROW_NUMBER () OVER (PARTITION BY patient, encounterclass ORDER BY start, stop) AS START_ORDINAL
			FROM @synthea_schema.encounters
			WHERE encounterclass = 'inpatient'
			UNION ALL
			SELECT patient, encounterclass, dateadd(day,1,stop), 1 AS EVENT_TYPE, NULL
			FROM @synthea_schema.encounters
			WHERE encounterclass = 'inpatient'
		) RAWDATA
	) E
	WHERE (2 * E.START_ORDINAL - E.OVERALL_ORD = 0)
),
CTE_VISIT_ENDS AS (
	SELECT MIN(V.id) encounter_id,
	    V.patient,
		V.encounterclass,
		V.start VISIT_START_DATE,
		MIN(E.END_DATE) AS VISIT_END_DATE
	FROM @synthea_schema.encounters V
		JOIN CTE_END_DATES E
			ON V.patient = E.patient
			AND V.encounterclass = E.encounterclass
			AND E.END_DATE >= V.start
	GROUP BY V.patient,V.encounterclass,V.start
)
SELECT T2.encounter_id,
    T2.patient,
	T2.encounterclass,
	T2.VISIT_START_DATE,
	T2.VISIT_END_DATE
INTO @cdm_schema.IP_VISITS
FROM (
	SELECT
	    encounter_id,
	    patient,
		encounterclass,
		MIN(VISIT_START_DATE) AS VISIT_START_DATE,
		VISIT_END_DATE
	FROM CTE_VISIT_ENDS
	GROUP BY encounter_id, patient, encounterclass, VISIT_END_DATE
) T2;


/* Emergency visits */
/* collapse ER claim lines with no days between them into one visit */

SELECT T2.encounter_id,
    T2.patient,
	T2.encounterclass,
	T2.VISIT_START_DATE,
	T2.VISIT_END_DATE
INTO @cdm_schema.ER_VISITS
FROM (
	SELECT MIN(encounter_id) encounter_id,
	    patient,
		encounterclass,
		VISIT_START_DATE,
		MAX(VISIT_END_DATE) AS VISIT_END_DATE
	FROM (
		SELECT CL1.id encounter_id,
			CL1.patient,
			CL1.encounterclass,
			CL1.start VISIT_START_DATE,
			CL2.stop VISIT_END_DATE
		FROM @synthea_schema.encounters CL1
		JOIN @synthea_schema.encounters CL2
			ON CL1.patient = CL2.patient
			AND CL1.start = CL2.start
			AND CL1.encounterclass = CL2.encounterclass
		WHERE CL1.encounterclass in ('emergency','urgent')
	) T1
	GROUP BY patient, encounterclass, VISIT_START_DATE
) T2;


/* Outpatient visits */

WITH CTE_VISITS_DISTINCT AS (
	SELECT MIN(id) encounter_id,
	               patient,
				   encounterclass,
					start VISIT_START_DATE,
					stop VISIT_END_DATE
	FROM @synthea_schema.encounters
	WHERE encounterclass in ('ambulatory', 'wellness', 'outpatient')
	GROUP BY patient,encounterclass,start,stop
)
SELECT MIN(encounter_id) encounter_id,
       patient,
		encounterclass,
		VISIT_START_DATE,
		MAX(VISIT_END_DATE) AS VISIT_END_DATE
INTO @cdm_schema.OP_VISITS
FROM CTE_VISITS_DISTINCT
GROUP BY patient, encounterclass, VISIT_START_DATE;


/* All visits */


SELECT *, row_number()over(order by patient) as visit_occurrence_id
INTO @cdm_schema.all_visits
FROM
(
	SELECT * FROM @cdm_schema.IP_VISITS
	UNION ALL
	SELECT * FROM @cdm_schema.ER_VISITS
	UNION ALL
	SELECT * FROM @cdm_schema.OP_VISITS
) T1;

if object_id('@cdm_schema.IP_VISITS', 'U')  is not null drop table @cdm_schema.IP_VISITS;
if object_id('@cdm_schema.ER_VISITS', 'U')  is not null drop table @cdm_schema.ER_VISITS;
if object_id('@cdm_schema.OP_VISITS', 'U')  is not null drop table @cdm_schema.OP_VISITS;
