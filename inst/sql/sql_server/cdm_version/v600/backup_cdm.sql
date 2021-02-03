if object_id('@cdm_schema.concept_orig', 'U') is not null drop table @cdm_schema.concept_orig;
if object_id('@cdm_schema.concept', 'U') is not null rename object @cdm_schema.concept to concept_orig;

if object_id('@cdm_schema.concept_ancestor_orig', 'U') is not null drop table @cdm_schema.concept_ancestor_orig;
if object_id('@cdm_schema.concept_ancestor', 'U') is not null rename object @cdm_schema.concept_ancestor to concept_ancestor_orig;

if object_id('@cdm_schema.concept_class_orig', 'U') is not null drop table @cdm_schema.concept_class_orig;
if object_id('@cdm_schema.concept_class', 'U') is not null rename object @cdm_schema.concept_class to concept_class_orig;

if object_id('@cdm_schema.concept_relationship_orig', 'U') is not null drop table @cdm_schema.concept_relationship_orig;
if object_id('@cdm_schema.concept_relationship', 'U') is not null rename object @cdm_schema.concept_relationship to concept_relationship_orig;

if object_id('@cdm_schema.concept_synonym_orig', 'U') is not null drop table @cdm_schema.concept_synonym_orig;
if object_id('@cdm_schema.concept_synonym', 'U') is not null rename object @cdm_schema.concept_synonym to concept_synonym_orig;

if object_id('@cdm_schema.source_to_concept_map_orig', 'U') is not null drop table @cdm_schema.source_to_concept_map_orig;
if object_id('@cdm_schema.source_to_concept_map', 'U') is not null rename object @cdm_schema.source_to_concept_map to source_to_concept_map_orig;
