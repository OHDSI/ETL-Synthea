if object_id('@cdm_schema.concept', 'U') is not null rename object @cdm_schema.concept to concept_old;
if object_id('@cdm_schema.concept_ancestor', 'U') is not null rename object @cdm_schema.concept_ancestor to concept_ancestor_old;
if object_id('@cdm_schema.concept_class', 'U') is not null rename object @cdm_schema.concept_class to concept_class_old;
if object_id('@cdm_schema.concept_relationship', 'U') is not null rename object @cdm_schema.concept_relationship to concept_relationship_old;
if object_id('@cdm_schema.concept_synonym', 'U') is not null rename object @cdm_schema.concept_synonym to concept_synonym_old;
if object_id('@cdm_schema.source_to_concept_map', 'U') is not null rename object @cdm_schema.source_to_concept_map to source_to_concept_map_old;

if object_id('@cdm_schema.concept_orig', 'U') is not null rename object @cdm_schema.concept_orig to concept;
if object_id('@cdm_schema.concept_ancestor_orig', 'U') is not null rename object @cdm_schema.concept_ancestor_orig to concept_ancestor;
if object_id('@cdm_schema.concept_class_orig', 'U') is not null rename object @cdm_schema.concept_class_orig to concept_class;
if object_id('@cdm_schema.concept_relationship_orig', 'U') is not null rename object @cdm_schema.concept_relationship_orig to concept_relationship;
if object_id('@cdm_schema.concept_synonym_orig', 'U') is not null rename object @cdm_schema.concept_synonym_orig to concept_synonym;
if object_id('@cdm_schema.source_to_concept_map_orig', 'U') is not null rename object @cdm_schema.source_to_concept_map_orig to source_to_concept_map;

if object_id('@cdm_schema.concept_old', 'U') is not null drop table @cdm_schema.concept_old;
if object_id('@cdm_schema.concept_ancestor_old', 'U') is not null drop table @cdm_schema.concept_ancestor_old;
if object_id('@cdm_schema.concept_class_old', 'U') is not null drop table @cdm_schema.concept_class_old;
if object_id('@cdm_schema.concept_relationship_old', 'U') is not null drop table @cdm_schema.concept_relationship_old;
if object_id('@cdm_schema.concept_synonym_old', 'U') is not null drop table @cdm_schema.concept_synonym_old;
if object_id('@cdm_schema.source_to_concept_map_old', 'U') is not null drop table @cdm_schema.source_to_concept_map_old;


