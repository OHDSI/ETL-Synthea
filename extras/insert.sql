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
-- 6: ICD9 code in SNOMED column, CONDITION_CONCEPT_ID = 0
INSERT INTO synthea_test.[patients](id, birthdate, ssn, prefix, first, last, marital, race, ethnicity, gender, birthplace, address, city, state, zip) VALUES ('6', '1926-02-23', '999-41-5589', 'Mr.', 'Benito209', 'Marks830', 'M', 'white', 'irish', 'M', 'Boston', '192 MacGyver Dam', 'Boston', 'Massachusetts', '02108');
INSERT INTO synthea_test.[encounters](id, start, stop, patient, encounterclass, code, description, cost) VALUES ('7', '2009-08-19', '2009-08-19', '6', 'outpatient', '185349003', 'Encounter for check up (procedure)', '129.16');
INSERT INTO synthea_test.[conditions](start, stop, patient, encounter, code, description) VALUES ('2009-08-19', '2009-10-18', '6', '7', 'V89.03', 'Viral sinusitis (disorder)');
-- 8: Test that observation period is taking the earliest start and latest stop, id is person_source_value
INSERT INTO synthea_test.[patients](id, birthdate, ssn, prefix, first, last, marital, race, ethnicity, birthplace, address, city, state, zip) VALUES ('8', '1926-02-23', '999-41-5589', 'Mr.', 'Benito209', 'Marks830', 'M', 'white', 'irish', 'Boston', '192 MacGyver Dam', 'Boston', 'Massachusetts', '02108');
INSERT INTO synthea_test.[encounters](id, start, stop, patient, encounterclass, code, description, cost) VALUES ('9', '2009-10-19', '2009-10-19', '8', 'outpatient', '185349003', 'Encounter for check up (procedure)', '129.16');
INSERT INTO synthea_test.[encounters](id, start, stop, patient, encounterclass, code, description, cost) VALUES ('10', '2009-11-21', '2009-11-30', '8', 'inpatient', '185349003', 'Encounter for check up (procedure)', '129.16');
-- 11: Collapse IP claim lines with <= 1 day between them, id is PERSON_SOURCE_VALUE
INSERT INTO synthea_test.[patients](id, birthdate, ssn, prefix, first, last, marital, race, ethnicity, gender, birthplace, address, city, state, zip) VALUES ('11', '1926-02-23', '999-41-5589', 'Mr.', 'Benito209', 'Marks830', 'M', 'white', 'irish', 'M', 'Boston', '192 MacGyver Dam', 'Boston', 'Massachusetts', '02108');
INSERT INTO synthea_test.[encounters](id, start, stop, patient, encounterclass, code, description, cost) VALUES ('12', '2004-09-26', '2004-09-27', '11', 'inpatient', '185349003', 'Encounter for check up (procedure)', '129.16');
INSERT INTO synthea_test.[encounters](id, start, stop, patient, encounterclass, code, description, cost) VALUES ('13', '2004-09-27', '2004-09-30', '11', 'inpatient', '185349003', 'Encounter for check up (procedure)', '129.16');
-- 14: Collapse OP claims that occur within an IP visit, id is PERSON_SOURCE_VALUE
INSERT INTO synthea_test.[patients](id, birthdate, ssn, prefix, first, last, marital, race, ethnicity, gender, birthplace, address, city, state, zip) VALUES ('14', '1926-02-23', '999-41-5589', 'Mr.', 'Benito209', 'Marks830', 'M', 'white', 'irish', 'M', 'Boston', '192 MacGyver Dam', 'Boston', 'Massachusetts', '02108');
INSERT INTO synthea_test.[encounters](id, start, stop, patient, encounterclass, code, description, cost) VALUES ('15', '2009-03-01', '2009-03-04', '14', 'inpatient', '185349003', 'Encounter for check up (procedure)', '129.16');
INSERT INTO synthea_test.[encounters](id, start, stop, patient, encounterclass, code, description, cost) VALUES ('16', '2009-03-02', '2009-03-02', '14', 'outpatient', '185349003', 'Encounter for check up (procedure)', '129.16');
-- 17: ER visit occurs on the first day of the IP visit, two visits created, id is PERSON_SOURCE_VALUE
INSERT INTO synthea_test.[patients](id, birthdate, ssn, prefix, first, last, marital, race, ethnicity, gender, birthplace, address, city, state, zip) VALUES ('17', '1926-02-23', '999-41-5589', 'Mr.', 'Benito209', 'Marks830', 'M', 'white', 'irish', 'M', 'Boston', '192 MacGyver Dam', 'Boston', 'Massachusetts', '02108');
INSERT INTO synthea_test.[encounters](id, start, stop, patient, encounterclass, code, description, cost) VALUES ('18', '2010-05-01', '2010-05-04', '17', 'inpatient', '185349003', 'Encounter for check up (procedure)', '129.16');
INSERT INTO synthea_test.[encounters](id, start, stop, patient, encounterclass, code, description, cost) VALUES ('19', '2010-05-01', '2010-05-01', '17', 'emergency', '185349003', 'Encounter for check up (procedure)', '129.16');
-- 20: OP visit starts before IP visit but ends during IP, two visits created, id is PERSON_SOURCE_VALUE
INSERT INTO synthea_test.[patients](id, birthdate, ssn, prefix, first, last, marital, race, ethnicity, gender, birthplace, address, city, state, zip) VALUES ('20', '1926-02-23', '999-41-5589', 'Mr.', 'Benito209', 'Marks830', 'M', 'white', 'irish', 'M', 'Boston', '192 MacGyver Dam', 'Boston', 'Massachusetts', '02108');
INSERT INTO synthea_test.[encounters](id, start, stop, patient, encounterclass, code, description, cost) VALUES ('21', '1990-03-06', '1990-03-08', '20', 'inpatient', '185349003', 'Encounter for check up (procedure)', '129.16');
INSERT INTO synthea_test.[encounters](id, start, stop, patient, encounterclass, code, description, cost) VALUES ('22', '1990-03-05', '1990-03-06', '20', 'ambulatory', '185349003', 'Encounter for check up (procedure)', '129.16');
-- 23: Two ER visits start on the same day, one visit created, id is PERSON_SOURCE_VALUE
INSERT INTO synthea_test.[patients](id, birthdate, ssn, prefix, first, last, marital, race, ethnicity, gender, birthplace, address, city, state, zip) VALUES ('23', '1926-02-23', '999-41-5589', 'Mr.', 'Benito209', 'Marks830', 'M', 'white', 'irish', 'M', 'Boston', '192 MacGyver Dam', 'Boston', 'Massachusetts', '02108');
INSERT INTO synthea_test.[encounters](id, start, stop, patient, encounterclass, code, description, cost) VALUES ('24', '1994-11-24', '1994-11-24', '23', 'emergency', '185349003', 'Encounter for check up (procedure)', '129.16');
INSERT INTO synthea_test.[encounters](id, start, stop, patient, encounterclass, code, description, cost) VALUES ('25', '1994-11-24', '1994-11-25', '23', 'urgentcare', '185349003', 'Encounter for check up (procedure)', '129.16');