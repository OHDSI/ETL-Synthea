
/************************

Standardized vocabulary

************************/

 if object_id('@vocab_schema.concept', 'U')  is not null drop table @vocab_schema.concept;
 CREATE TABLE @vocab_schema.concept (
  concept_id			    INTEGER			  NOT NULL ,
  concept_name			  VARCHAR(255)	NOT NULL ,
  domain_id				    VARCHAR(20)		NOT NULL ,
  vocabulary_id			  VARCHAR(20)		NOT NULL ,
  concept_class_id		VARCHAR(20)		NOT NULL ,
  standard_concept		VARCHAR(1)		NULL ,
  concept_code			  VARCHAR(50)		NOT NULL ,
  valid_start_date		DATE			    NOT NULL ,
  valid_end_date		  DATE			    NOT NULL ,
  invalid_reason		  VARCHAR(1)		NULL
)
;

if object_id('@vocab_schema.vocabulary', 'U')  is not null drop table @vocab_schema.vocabulary;
CREATE TABLE @vocab_schema.vocabulary (
  vocabulary_id			    VARCHAR(20)		NOT NULL,
  vocabulary_name		    VARCHAR(255)	NOT NULL,
  vocabulary_reference	VARCHAR(255)	 NULL,
  vocabulary_version	  VARCHAR(255)	 NULL,
  vocabulary_concept_id	INTEGER			  NOT NULL
)
;

if object_id('@vocab_schema.domain', 'U')  is not null drop table @vocab_schema.domain;
CREATE TABLE @vocab_schema.domain (
  domain_id			    VARCHAR(20)		NOT NULL,
  domain_name		    VARCHAR(255)	NOT NULL,
  domain_concept_id	INTEGER			  NOT NULL
)
;

if object_id('@vocab_schema.concept_class', 'U')  is not null drop table @vocab_schema.concept_class;
CREATE TABLE @vocab_schema.concept_class (
  concept_class_id			    VARCHAR(20)		NOT NULL,
  concept_class_name		    VARCHAR(255)	NOT NULL,
  concept_class_concept_id	INTEGER			  NOT NULL
)
;

if object_id('@vocab_schema.concept_relationship', 'U')  is not null drop table @vocab_schema.concept_relationship;
CREATE TABLE @vocab_schema.concept_relationship (
  concept_id_1			INTEGER			NOT NULL,
  concept_id_2			INTEGER			NOT NULL,
  relationship_id		VARCHAR(20)	NOT NULL,
  valid_start_date	DATE			  NOT NULL,
  valid_end_date		DATE			  NOT NULL,
  invalid_reason		VARCHAR(1)	NULL
  )
;

if object_id('@vocab_schema.relationship', 'U')  is not null drop table @vocab_schema.relationship;
CREATE TABLE @vocab_schema.relationship (
  relationship_id			    VARCHAR(20)		NOT NULL,
  relationship_name			  VARCHAR(255)	NOT NULL,
  is_hierarchical			    VARCHAR(1)		NOT NULL,
  defines_ancestry			  VARCHAR(1)		NOT NULL,
  reverse_relationship_id	VARCHAR(20)		NOT NULL,
  relationship_concept_id	INTEGER			  NOT NULL
)
;

if object_id('@vocab_schema.concept_synonym', 'U')  is not null drop table @vocab_schema.concept_synonym;
CREATE TABLE @vocab_schema.concept_synonym (
  concept_id			      INTEGER			  NOT NULL,
  concept_synonym_name	VARCHAR(1000)	NOT NULL,
  language_concept_id	  INTEGER			  NOT NULL
)
;

if object_id('@vocab_schema.concept_ancestor', 'U')  is not null drop table @vocab_schema.concept_ancestor;
CREATE TABLE @vocab_schema.concept_ancestor (
  ancestor_concept_id		    INTEGER		NOT NULL,
  descendant_concept_id		  INTEGER		NOT NULL,
  min_levels_of_separation	INTEGER		NOT NULL,
  max_levels_of_separation	INTEGER		NOT NULL
)
;

if object_id('@vocab_schema.source_to_concept_map', 'U')  is not null drop table @vocab_schema.source_to_concept_map;
CREATE TABLE @vocab_schema.source_to_concept_map (
  source_code				      VARCHAR(50)		NOT NULL,
  source_concept_id			  INTEGER			  NOT NULL,
  source_vocabulary_id		VARCHAR(20)		NOT NULL,
  source_code_description	VARCHAR(255)	NULL,
  target_concept_id			  INTEGER			  NOT NULL,
  target_vocabulary_id		VARCHAR(20)		NOT NULL,
  valid_start_date			  DATE			    NOT NULL,
  valid_end_date			    DATE			    NOT NULL,
  invalid_reason			    VARCHAR(1)		NULL
)
;


if object_id('@vocab_schema.drug_strength', 'U')  is not null drop table @vocab_schema.drug_strength;
CREATE TABLE @vocab_schema.drug_strength (
  drug_concept_id				      INTEGER		  NOT NULL,
  ingredient_concept_id			  INTEGER		  NOT NULL,
  amount_value					      NUMERIC		    NULL,
  amount_unit_concept_id		  INTEGER		  NULL,
  numerator_value				      NUMERIC		    NULL,
  numerator_unit_concept_id		INTEGER		  NULL,
  denominator_value				    NUMERIC		    NULL,
  denominator_unit_concept_id	INTEGER		  NULL,
  box_size						        INTEGER		  NULL,
  valid_start_date				    DATE		    NOT NULL,
  valid_end_date				      DATE		    NOT NULL,
  invalid_reason				      VARCHAR(1)  NULL
)
;


if object_id('@vocab_schema.cohort_definition', 'U')  is not null drop table @vocab_schema.cohort_definition;
CREATE TABLE @vocab_schema.cohort_definition (
  cohort_definition_id				    INTEGER			  NOT NULL,
  cohort_definition_name			    VARCHAR(255)	NOT NULL,
  cohort_definition_description		VARCHAR(255)	NULL,
  definition_type_concept_id		  INTEGER			  NOT NULL,
  cohort_definition_syntax			  VARCHAR(255)	NULL,
  subject_concept_id				      INTEGER			  NOT NULL,
  cohort_initiation_date			    DATE			    NULL
)
;

if object_id('@vocab_schema.attribute_definition', 'U')  is not null drop table @vocab_schema.attribute_definition;
CREATE TABLE @vocab_schema.attribute_definition (
  attribute_definition_id		  INTEGER			  NOT NULL,
  attribute_name				      VARCHAR(255)	NOT NULL,
  attribute_description			  VARCHAR(255)	NULL,
  attribute_type_concept_id		INTEGER			  NOT NULL,
  attribute_syntax				    VARCHAR(255)	NULL
)
;
