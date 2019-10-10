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
) values (
'Synthea synthetic health database',
'Synthea',
'OHDSI Community',
'SyntheaTM is a Synthetic Patient Population Simulator. The goal is to output synthetic, realistic (but not real), patient data and associated health records in a variety of formats.',
'https://synthetichealth.github.io/synthea/',
'https://github.com/OHDSI/ETL-Synthea',
'2019-10-02',
'2019-10-07',
'v6.0',
'v5.0 17-JUN-19'
);
