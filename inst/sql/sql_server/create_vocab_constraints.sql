
ALTER TABLE @vocab_schema.CONCEPT ADD CONSTRAINT fpk_CONCEPT_domain_id FOREIGN KEY (domain_id) REFERENCES @vocab_schema.DOMAIN (DOMAIN_ID);

ALTER TABLE @vocab_schema.CONCEPT ADD CONSTRAINT fpk_CONCEPT_vocabulary_id FOREIGN KEY (vocabulary_id) REFERENCES @vocab_schema.VOCABULARY (VOCABULARY_ID);

ALTER TABLE @vocab_schema.CONCEPT ADD CONSTRAINT fpk_CONCEPT_concept_class_id FOREIGN KEY (concept_class_id) REFERENCES @vocab_schema.CONCEPT_CLASS (CONCEPT_CLASS_ID);

ALTER TABLE @vocab_schema.VOCABULARY ADD CONSTRAINT fpk_VOCABULARY_vocabulary_concept_id FOREIGN KEY (vocabulary_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.DOMAIN ADD CONSTRAINT fpk_DOMAIN_domain_concept_id FOREIGN KEY (domain_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.CONCEPT_CLASS ADD CONSTRAINT fpk_CONCEPT_CLASS_concept_class_concept_id FOREIGN KEY (concept_class_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.CONCEPT_RELATIONSHIP ADD CONSTRAINT fpk_CONCEPT_RELATIONSHIP_concept_id_1 FOREIGN KEY (concept_id_1) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.CONCEPT_RELATIONSHIP ADD CONSTRAINT fpk_CONCEPT_RELATIONSHIP_concept_id_2 FOREIGN KEY (concept_id_2) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.CONCEPT_RELATIONSHIP ADD CONSTRAINT fpk_CONCEPT_RELATIONSHIP_relationship_id FOREIGN KEY (relationship_id) REFERENCES @vocab_schema.RELATIONSHIP (RELATIONSHIP_ID);

ALTER TABLE @vocab_schema.RELATIONSHIP ADD CONSTRAINT fpk_RELATIONSHIP_relationship_concept_id FOREIGN KEY (relationship_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.CONCEPT_SYNONYM ADD CONSTRAINT fpk_CONCEPT_SYNONYM_concept_id FOREIGN KEY (concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.CONCEPT_SYNONYM ADD CONSTRAINT fpk_CONCEPT_SYNONYM_language_concept_id FOREIGN KEY (language_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.CONCEPT_ANCESTOR ADD CONSTRAINT fpk_CONCEPT_ANCESTOR_ancestor_concept_id FOREIGN KEY (ancestor_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.CONCEPT_ANCESTOR ADD CONSTRAINT fpk_CONCEPT_ANCESTOR_descendant_concept_id FOREIGN KEY (descendant_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.SOURCE_TO_CONCEPT_MAP ADD CONSTRAINT fpk_SOURCE_TO_CONCEPT_MAP_source_concept_id FOREIGN KEY (source_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.SOURCE_TO_CONCEPT_MAP ADD CONSTRAINT fpk_SOURCE_TO_CONCEPT_MAP_target_concept_id FOREIGN KEY (target_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.SOURCE_TO_CONCEPT_MAP ADD CONSTRAINT fpk_SOURCE_TO_CONCEPT_MAP_target_vocabulary_id FOREIGN KEY (target_vocabulary_id) REFERENCES @vocab_schema.VOCABULARY (VOCABULARY_ID);

ALTER TABLE @vocab_schema.DRUG_STRENGTH ADD CONSTRAINT fpk_DRUG_STRENGTH_drug_concept_id FOREIGN KEY (drug_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.DRUG_STRENGTH ADD CONSTRAINT fpk_DRUG_STRENGTH_ingredient_concept_id FOREIGN KEY (ingredient_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.DRUG_STRENGTH ADD CONSTRAINT fpk_DRUG_STRENGTH_amount_unit_concept_id FOREIGN KEY (amount_unit_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.DRUG_STRENGTH ADD CONSTRAINT fpk_DRUG_STRENGTH_numerator_unit_concept_id FOREIGN KEY (numerator_unit_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.DRUG_STRENGTH ADD CONSTRAINT fpk_DRUG_STRENGTH_denominator_unit_concept_id FOREIGN KEY (denominator_unit_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.COHORT_DEFINITION ADD CONSTRAINT fpk_COHORT_DEFINITION_definition_type_concept_id FOREIGN KEY (definition_type_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.COHORT_DEFINITION ADD CONSTRAINT fpk_COHORT_DEFINITION_subject_concept_id FOREIGN KEY (subject_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);

ALTER TABLE @vocab_schema.ATTRIBUTE_DEFINITION ADD CONSTRAINT fpk_ATTRIBUTE_DEFINITION_attribute_type_concept_id FOREIGN KEY (attribute_type_concept_id) REFERENCES @vocab_schema.CONCEPT (CONCEPT_ID);
