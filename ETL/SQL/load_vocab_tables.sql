copy concept              from 'D:\Apps\Git\synthea\ETL\CSV\vocab_20171201\CONCEPT.csv'              with (FORMAT CSV, DELIMITER E'\t', HEADER true, NULL '');
copy vocabulary           from 'D:\Apps\Git\synthea\ETL\CSV\vocab_20171201\VOCABULARY.csv'           with (FORMAT CSV, DELIMITER E'\t', HEADER true, NULL '');
copy concept_ancestor     from 'D:\Apps\Git\synthea\ETL\CSV\vocab_20171201\CONCEPT_ANCESTOR.csv'     with (FORMAT CSV, DELIMITER E'\t', HEADER true, NULL '');
copy concept_relationship from 'D:\Apps\Git\synthea\ETL\CSV\vocab_20171201\CONCEPT_RELATIONSHIP.csv' with (FORMAT CSV, DELIMITER E'\t', HEADER true, NULL '');
copy relationship         from 'D:\Apps\Git\synthea\ETL\CSV\vocab_20171201\RELATIONSHIP.csv'         with (FORMAT CSV, DELIMITER E'\t', HEADER true, NULL '');
copy concept_synonym      from 'D:\Apps\Git\synthea\ETL\CSV\vocab_20171201\CONCEPT_SYNONYM.csv'      with (FORMAT CSV, DELIMITER E'\t', HEADER true, NULL '');
copy domain               from 'D:\Apps\Git\synthea\ETL\CSV\vocab_20171201\DOMAIN.csv'               with (FORMAT CSV, DELIMITER E'\t', HEADER true, NULL '');
copy concept_class        from 'D:\Apps\Git\synthea\ETL\CSV\vocab_20171201\CONCEPT_CLASS.csv'        with (FORMAT CSV, DELIMITER E'\t', HEADER true, NULL '');

