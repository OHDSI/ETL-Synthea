
if object_id('@synthea_schema.allergies', 'U')        is not null drop table @synthea_schema.allergies;
if object_id('@synthea_schema.careplans', 'U')        is not null drop table @synthea_schema.careplans;
if object_id('@synthea_schema.conditions', 'U')       is not null drop table @synthea_schema.conditions;
if object_id('@synthea_schema.encounters', 'U')       is not null drop table @synthea_schema.encounters;
if object_id('@synthea_schema.imaging_studies', 'U')  is not null drop table @synthea_schema.imaging_studies;
if object_id('@synthea_schema.immunizations', 'U')    is not null drop table @synthea_schema.immunizations;
if object_id('@synthea_schema.medications', 'U')      is not null drop table @synthea_schema.medications;
if object_id('@synthea_schema.observations', 'U')     is not null drop table @synthea_schema.observations;
if object_id('@synthea_schema.organizations', 'U')    is not null drop table @synthea_schema.organizations;
if object_id('@synthea_schema.patients', 'U')         is not null drop table @synthea_schema.patients;
if object_id('@synthea_schema.procedures', 'U')       is not null drop table @synthea_schema.procedures;
if object_id('@synthea_schema.providers', 'U')        is not null drop table @synthea_schema.providers;
