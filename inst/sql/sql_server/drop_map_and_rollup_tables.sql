if object_id('@cdm_schema.source_to_source_vocab_map', 'U')  is not null drop table @cdm_schema.source_to_source_vocab_map;
if object_id('@cdm_schema.source_to_standard_vocab_map', 'U')  is not null drop table @cdm_schema.source_to_standard_vocab_map;
if object_id('@cdm_schema.ALL_VISITS', 'U') is not null drop table @cdm_schema.ALL_VISITS;
if object_id('@cdm_schema.ASSIGN_ALL_VISIT_IDS', 'U')  is not null drop table @cdm_schema.ASSIGN_ALL_VISIT_IDS;
if object_id('@cdm_schema.FINAL_VISIT_IDS', 'U') is not null drop table @cdm_schema.FINAL_VISIT_IDS;
