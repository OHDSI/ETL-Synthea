
-- This script is taken from here:
-- https://github.com/OHDSI/ETL-CMS/blob/master/SQL/create_CDMv5_condition_era.sql
--

if object_id('tempdb..#tmp_ce', 'U') is not null drop table #tmp_ce;

WITH cteConditionTarget (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date) AS
(
	SELECT
		co.condition_occurrence_id
		, co.person_id
		, co.condition_concept_id
		, co.condition_start_date
		, COALESCE(NULLIF(co.condition_end_date,NULL), dateadd(day,1,condition_start_date)) AS condition_end_date
	FROM @cdm_schema.condition_occurrence co
	/* Depending on the needs of your data, you can put more filters on to your code. We assign 0 to our unmapped condition_concept_id's,
	 * and since we don't want different conditions put in the same era, we put in the filter below.
 	 */
	---WHERE condition_concept_id != 0
),
--------------------------------------------------------------------------------------------------------------
cteEndDates (person_id, condition_concept_id, end_date) AS -- the magic
(
	SELECT
		person_id
		, condition_concept_id
		, dateadd(day,-30,event_date) AS end_date -- unpad the end date
	FROM
	(
		SELECT
			person_id
			, condition_concept_id
			, event_date
			, event_type
			, MAX(start_ordinal) OVER (PARTITION BY person_id, condition_concept_id ORDER BY event_date, event_type ROWS UNBOUNDED PRECEDING) AS start_ordinal -- this pulls the current START down from the prior rows so that the NULLs from the END DATES will contain a value we can compare with
			, ROW_NUMBER() OVER (PARTITION BY person_id, condition_concept_id ORDER BY event_date, event_type) AS overall_ord -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
		FROM
		(
			-- select the start dates, assigning a row number to each
			SELECT
				person_id
				, condition_concept_id
				, condition_start_date AS event_date
				, -1 AS event_type
				, ROW_NUMBER() OVER (PARTITION BY person_id
				, condition_concept_id ORDER BY condition_start_date) AS start_ordinal
			FROM cteConditionTarget

			UNION ALL

			-- pad the end dates by 30 to allow a grace period for overlapping ranges.
			SELECT
				person_id
			       	, condition_concept_id
				, dateadd(day,30,condition_end_date)
				, 1 AS event_type
				, NULL
			FROM cteConditionTarget
		) RAWDATA
	) e
	WHERE (2 * e.start_ordinal) - e.overall_ord = 0
),
--------------------------------------------------------------------------------------------------------------
cteConditionEnds (person_id, condition_concept_id, condition_start_date, era_end_date) AS
(
SELECT
        c.person_id
	, c.condition_concept_id
	, c.condition_start_date
	, MIN(e.end_date) AS era_end_date
FROM cteConditionTarget c
JOIN cteEndDates e ON c.person_id = e.person_id AND c.condition_concept_id = e.condition_concept_id AND e.end_date >= c.condition_start_date
GROUP BY
        c.condition_occurrence_id
	, c.person_id
	, c.condition_concept_id
	, c.condition_start_date
)
--------------------------------------------------------------------------------------------------------------


SELECT 
    row_number()over(order by person_id) condition_era_id
	, person_id
	, condition_concept_id
	, MIN(condition_start_date) AS condition_era_start_date
	, era_end_date AS condition_era_end_date
	, COUNT(*) AS condition_occurrence_count
INTO #tmp_ce
FROM cteConditionEnds
GROUP BY person_id, condition_concept_id, era_end_date
;

INSERT INTO @cdm_schema.condition_era (condition_era_id,person_id, condition_concept_id, condition_era_start_date, condition_era_end_date, condition_occurrence_count)
SELECT * FROM #tmp_ce;