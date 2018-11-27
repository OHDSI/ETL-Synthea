drop table if exists allergies;
create table allergies (
start         date,
stop          date,
patient       varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(100)
);

drop table if exists careplans;
create table careplans (
id            varchar(1000),
start         date,
stop          date,
patient       varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(100),
reason_code   varchar(100),
reason_desc   varchar(100)
);

drop table if exists conditions;
create table conditions (
start         date,
stop          date,
patient       varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(100)
);

drop table if exists encounters;
create table encounters (
id            		varchar(1000),
start         		date,
stop							date,
patient       		varchar(1000),
encounterclass		varchar(1000),
code          		varchar(100),
description   		varchar(100),
cost							numeric,
reasoncode   			varchar(100),
reasondescription varchar(100)
);

drop table if exists immunizations;
create table immunizations (
"date"        date,
patient       varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(100),
cost					numeric
);

drop table if exists medications;
create table medications (
start         date,
stop          date,
patient       varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(1000),
cost					numeric,
dispenses			int,
totalcost			numeric,
reasoncode   	varchar(100),
reasondescription   varchar(100)
);

drop table if exists observations;
create table observations (
"date"         date,
patient       varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(100),
value     		varchar(1000),
units         varchar(100),
type					varchar(100)
);

drop table if exists patients;
create table patients (
id            varchar(1000),
birthdate     date,
deathdate     date,
ssn           varchar(100),
drivers       varchar(100),
passport      varchar(100),
prefix        varchar(100),
first         varchar(100),
last          varchar(100),
suffix        varchar(100),
maiden        varchar(100),
marital       varchar(100),
race          varchar(100),
ethnicity     varchar(100),
gender        varchar(100),
birthplace    varchar(100),
address       varchar(100),
city					varchar(100),
state					varchar(100),
zip						varchar(100)
);

drop table if exists procedures;
create table procedures (
"date"         date,
patient       varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(100),
cost					numeric,
reasoncode   varchar(100),
reasondescription   varchar(100)
);
