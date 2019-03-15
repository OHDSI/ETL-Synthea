TRUNCATE TABLE synthea_test.[allergies];
TRUNCATE TABLE synthea_test.[careplans];
TRUNCATE TABLE synthea_test.[conditions];
TRUNCATE TABLE synthea_test.[encounters];
TRUNCATE TABLE synthea_test.[imaging_studies];
TRUNCATE TABLE synthea_test.[immunizations];
TRUNCATE TABLE synthea_test.[medications];
TRUNCATE TABLE synthea_test.[observations];
TRUNCATE TABLE synthea_test.[patients];
TRUNCATE TABLE synthea_test.[procedures];
-- 1: Drop patients with no gender, id is PERSON_SOURCE_VALUE
INSERT INTO synthea_test.[patients](id, birthdate, ssn, prefix, first, last, marital, race, ethnicity, birthplace, address, city, state, zip) VALUES ('1', '1926-02-23', '999-41-5589', 'Mr.', 'Benito209', 'Marks830', 'M', 'white', 'irish', 'Boston', '192 MacGyver Dam', 'Boston', 'Massachusetts', '02108');
-- 2: Patient with unknown race has RACE_CONCEPT_ID = 0, id is PERSON_SOURCE_VALUE
INSERT INTO synthea_test.[patients](id, birthdate, ssn, prefix, first, last, marital, race, ethnicity, gender, birthplace, address, city, state, zip) VALUES ('2', '1926-02-23', '999-41-5589', 'Mr.', 'Benito209', 'Marks830', 'M', 'Unknown', 'irish', 'M', 'Boston', '192 MacGyver Dam', 'Boston', 'Massachusetts', '02108');
-- 3: Patient with ethnicity other than hispanic has ETHNICITY_CONCEPT_ID = 0, id is PERSON_SOURCE_VALUE
INSERT INTO synthea_test.[patients](id, birthdate, ssn, prefix, first, last, marital, race, ethnicity, gender, birthplace, address, city, state, zip) VALUES ('3', '1926-02-23', '999-41-5589', 'Mr.', 'Benito209', 'Marks830', 'M', 'white', 'English', 'M', 'Boston', '192 MacGyver Dam', 'Boston', 'Massachusetts', '02108');
-- 4: Patient with strange birth date, id is PERSON_SOURCE_VALUE
INSERT INTO synthea_test.[patients](id, birthdate, ssn, prefix, first, last, marital, race, ethnicity, gender, birthplace, address, city, state, zip) VALUES ('4', '2099-01-01', '999-41-5589', 'Mr.', 'Benito209', 'Marks830', 'M', 'white', 'irish', 'M', 'Boston', '192 MacGyver Dam', 'Boston', 'Massachusetts', '02108');
-- 5: Patient with strange birth date, id is PERSON_SOURCE_VALUE
INSERT INTO synthea_test.[patients](id, birthdate, ssn, prefix, first, last, marital, race, ethnicity, gender, birthplace, address, city, state, zip) VALUES ('5', '1099-01-01', '999-41-5589', 'Mr.', 'Benito209', 'Marks830', 'M', 'white', 'irish', 'M', 'Boston', '192 MacGyver Dam', 'Boston', 'Massachusetts', '02108');