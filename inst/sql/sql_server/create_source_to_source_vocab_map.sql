
--Use this code to map source codes to source concept ids;

if object_id('@cdm_schema.source_to_source_vocab_map', 'U')  is not null drop table @cdm_schema.source_to_source_vocab_map;

WITH CTE_VOCAB_MAP AS (
       SELECT c.concept_code AS SOURCE_CODE, c.concept_id AS SOURCE_CONCEPT_ID, c.CONCEPT_NAME AS SOURCE_CODE_DESCRIPTION,
                        c.vocabulary_id AS SOURCE_VOCABULARY_ID, c.domain_id AS SOURCE_DOMAIN_ID, c.concept_class_id AS SOURCE_CONCEPT_CLASS_ID,
            c.VALID_START_DATE AS SOURCE_VALID_START_DATE, c.VALID_END_DATE AS SOURCE_VALID_END_DATE, c.invalid_reason AS SOURCE_INVALID_REASON,
            c.concept_ID as TARGET_CONCEPT_ID, c.concept_name AS TARGET_CONCEPT_NAME, c.vocabulary_id AS TARGET_VOCABULARY_ID, c.domain_id AS TARGET_DOMAIN_ID,
                        c.concept_class_id AS TARGET_CONCEPT_CLASS_ID, c.INVALID_REASON AS TARGET_INVALID_REASON,
            c.STANDARD_CONCEPT AS TARGET_STANDARD_CONCEPT
       FROM @cdm_schema.CONCEPT c
       UNION
       SELECT source_code, SOURCE_CONCEPT_ID, SOURCE_CODE_DESCRIPTION, source_vocabulary_id, c1.domain_id AS SOURCE_DOMAIN_ID, c2.CONCEPT_CLASS_ID AS SOURCE_CONCEPT_CLASS_ID,
                                        c1.VALID_START_DATE AS SOURCE_VALID_START_DATE, c1.VALID_END_DATE AS SOURCE_VALID_END_DATE,stcm.INVALID_REASON AS SOURCE_INVALID_REASON,
                                        target_concept_id, c2.CONCEPT_NAME AS TARGET_CONCEPT_NAME, target_vocabulary_id, c2.domain_id AS TARGET_DOMAIN_ID, c2.concept_class_id AS TARGET_CONCEPT_CLASS_ID,
                     c2.INVALID_REASON AS TARGET_INVALID_REASON, c2.standard_concept AS TARGET_STANDARD_CONCEPT
       FROM @cdm_schema.source_to_concept_map stcm
              LEFT OUTER JOIN @cdm_schema.CONCEPT c1
                     ON c1.concept_id = stcm.source_concept_id
              LEFT OUTER JOIN @cdm_schema.CONCEPT c2
                     ON c2.CONCEPT_ID = stcm.target_concept_id
       WHERE stcm.INVALID_REASON IS NULL
)

SELECT * INTO @cdm_schema.source_to_source_vocab_map FROM CTE_VOCAB_MAP;

create index idx_source_vocab_map_source_code on @cdm_schema.source_to_source_vocab_map (source_code);
create index idx_source_vocab_map_source_vocab_id on @cdm_schema.source_to_source_vocab_map (source_vocabulary_id);
