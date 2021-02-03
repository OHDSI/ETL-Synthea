insert into @cdm_schema.cdm_source (
cdm_source_name,
cdm_source_abbreviation,
cdm_holder,
source_description,
source_documentation_reference,
cdm_etl_reference,
source_release_date,
cdm_release_date,
cdm_version,
vocabulary_version
) 
select
'Synthea synthetic health database',
'Synthea',
'OHDSI Community',
'SyntheaTM is a Synthetic Patient Population Simulator. The goal is to output synthetic, realistic (but not real), patient data and associated health records in a variety of formats.',
'https://synthetichealth.github.io/synthea/',
'https://github.com/OHDSI/ETL-Synthea',
getdate(), -- NB: Set this value to the day the source data was pulled
getdate(), 
'v5.3',
vocabulary_version
from @cdm_schema.vocabulary 
where vocabulary_id = 'None';
