copy concept from '/vocabulary/CONCEPT.csv' with (FORMAT CSV,DELIMITER E'\t', HEADER true, NULL '');
copy vocabulary from '/vocabulary/VOCABULARY.csv' with (FORMAT CSV,DELIMITER E'\t', HEADER true, NULL '');
copy concept_ancestor from '/vocabulary/CONCEPT_ANCESTOR.csv' with (FORMAT CSV,DELIMITER E'\t', HEADER true, NULL '');
copy concept_relationship from '/vocabulary/CONCEPT_RELATIONSHIP.csv' with (FORMAT CSV, DELIMITER E'\t', HEADER true, NULL '');
copy relationship from '/vocabulary/RELATIONSHIP.csv' with (FORMAT CSV, DELIMITER E'\t', HEADER true, NULL '');
copy concept_synonym from '/vocabulary/CONCEPT_SYNONYM.csv' with (FORMAT CSV, DELIMITER E'\t', HEADER true, NULL '');
copy domain from '/vocabulary/DOMAIN.csv' with (FORMAT CSV, DELIMITER E'\t', HEADER true, NULL '');
copy concept_class from '/vocabulary/CONCEPT_CLASS.csv' with (FORMAT CSV, DELIMITER E'\t', HEADER true, NULL '');
copy concept_ancestor from '/vocabulary/CONCEPT_ANCESTOR.csv' with (FORMAT CSV, DELIMITER E'\t', HEADER true, NULL '');