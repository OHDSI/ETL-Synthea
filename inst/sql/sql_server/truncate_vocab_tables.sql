
if object_id('@vocab_schema.attribute_definition', 'U')  is not null truncate table @vocab_schema.attribute_definition;
if object_id('@vocab_schema.cohort_definition', 'U')     is not null truncate table @vocab_schema.cohort_definition;
if object_id('@vocab_schema.concept', 'U')               is not null truncate table @vocab_schema.concept;
if object_id('@vocab_schema.concept_ancestor', 'U')      is not null truncate table @vocab_schema.concept_ancestor;
if object_id('@vocab_schema.concept_class', 'U')         is not null truncate table @vocab_schema.concept_class;
if object_id('@vocab_schema.concept_relationship', 'U')  is not null truncate table @vocab_schema.concept_relationship;
if object_id('@vocab_schema.concept_synonym', 'U')       is not null truncate table @vocab_schema.concept_synonym;
if object_id('@vocab_schema.domain', 'U')                is not null truncate table @vocab_schema.domain;
if object_id('@vocab_schema.drug_strength', 'U')         is not null truncate table @vocab_schema.drug_strength;
if object_id('@vocab_schema.relationship', 'U')          is not null truncate table @vocab_schema.relationship;
if object_id('@vocab_schema.source_to_concept_map', 'U') is not null truncate table @vocab_schema.source_to_concept_map;
if object_id('@vocab_schema.vocabulary', 'U')            is not null truncate table @vocab_schema.vocabulary;
