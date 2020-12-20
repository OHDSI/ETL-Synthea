
/**************************

Standardized vocabularies

***************************/

CREATE CLUSTERED INDEX idx_concept_concept_id ON @vocab_schema.concept (concept_id ASC);
CREATE INDEX idx_concept_code ON @vocab_schema.concept (concept_code ASC);
CREATE INDEX idx_concept_vocabluary_id ON @vocab_schema.concept (vocabulary_id ASC);
CREATE INDEX idx_concept_domain_id ON @vocab_schema.concept (domain_id ASC);
CREATE INDEX idx_concept_class_id ON @vocab_schema.concept (concept_class_id ASC);

CREATE CLUSTERED INDEX idx_vocabulary_vocabulary_id ON @vocab_schema.vocabulary (vocabulary_id ASC);

CREATE CLUSTERED INDEX idx_domain_domain_id ON @vocab_schema.domain (domain_id ASC);

CREATE CLUSTERED INDEX idx_concept_class_class_id ON @vocab_schema.concept_class (concept_class_id ASC);

CREATE CLUSTERED INDEX idx_concept_relationship_id_1 ON @vocab_schema.concept_relationship (concept_id_1 ASC);
CREATE INDEX idx_concept_relationship_id_2 ON @vocab_schema.concept_relationship (concept_id_2 ASC);
CREATE INDEX idx_concept_relationship_id_3 ON @vocab_schema.concept_relationship (relationship_id ASC);

CREATE CLUSTERED INDEX idx_relationship_rel_id ON @vocab_schema.relationship (relationship_id ASC);

CREATE CLUSTERED INDEX idx_concept_synonym_id ON @vocab_schema.concept_synonym (concept_id ASC);

CREATE CLUSTERED INDEX idx_concept_ancestor_id_1 ON @vocab_schema.concept_ancestor (ancestor_concept_id ASC);
CREATE INDEX idx_concept_ancestor_id_2 ON @vocab_schema.concept_ancestor (descendant_concept_id ASC);

CREATE CLUSTERED INDEX idx_source_to_concept_map_3 ON @vocab_schema.source_to_concept_map (target_concept_id ASC);
CREATE INDEX idx_source_to_concept_map_1 ON @vocab_schema.source_to_concept_map (source_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_2 ON @vocab_schema.source_to_concept_map (target_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_c ON @vocab_schema.source_to_concept_map (source_code ASC);

CREATE CLUSTERED INDEX idx_drug_strength_id_1 ON @vocab_schema.drug_strength (drug_concept_id ASC);
CREATE INDEX idx_drug_strength_id_2 ON @vocab_schema.drug_strength (ingredient_concept_id ASC);

