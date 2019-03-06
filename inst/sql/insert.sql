TRUNCATE TABLE blah.[allergies.csv];
TRUNCATE TABLE blah.[careplans.csv];
TRUNCATE TABLE blah.[conditions.csv];
TRUNCATE TABLE blah.[encounters.csv];
TRUNCATE TABLE blah.[imaging_studies.csv];
TRUNCATE TABLE blah.[immunizations.csv];
TRUNCATE TABLE blah.[medications.csv];
TRUNCATE TABLE blah.[observations.csv];
TRUNCATE TABLE blah.[patients.csv];
TRUNCATE TABLE blah.[procedures.csv];
-- 1: Drop patients with no gender
INSERT INTO blah.[patients.csv](birthdate, ssn, prefix, first, last, marital, race, ethnicity, birthplace, address, city, state, zip) VALUES ('1926-02-23', '999-41-5589', 'Mr.', 'Benito209', 'Marks830', 'M', 'white', 'irish', 'Boston', '192 MacGyver Dam', 'Boston', 'Massachusetts', '02108');