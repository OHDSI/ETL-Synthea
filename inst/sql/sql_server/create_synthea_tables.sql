
--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.allergies (
start         date,
stop          date,
patient       varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(255)
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.careplans (
id            varchar(1000),
start         date,
stop          date,
patient       varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(255),
reasoncode   varchar(255),
reasondescription   varchar(255)
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.conditions (
start         date,
stop          date,
patient       varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(255)
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.encounters (
id            		varchar(1000),
start         		date,
stop							date,
patient       		varchar(1000),
organization   		varchar(1000),
provider			varchar(1000),
payer			varchar(1000),
encounterclass		varchar(1000),
code          		varchar(100),
description   		varchar(255),
base_encounter_cost numeric,
total_claim_cost		numeric,
payer_coverage		numeric,
reasoncode   			varchar(100),
reasondescription varchar(255)
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.immunizations (
"date"        date,
patient       varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(255),
base_cost	numeric
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.imaging_studies (
id			  varchar(1000),
"date"        date,
patient					varchar(1000),
encounter				varchar(1000),
series_uid			varchar(1000),
bodysite_code			varchar(100),
bodysite_description		varchar(255),
modality_code			varchar(100),
modality_description		varchar(255),
instance_uid			varchar(1000),
SOP_code					varchar(100),
SOP_description			varchar(255),
procedure_code			varchar(255)
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.medications (
start         date,
stop          date,
patient       varchar(1000),
payer		varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(1000),
base_cost	  numeric,
payer_coverage		numeric,
dispenses			int,
totalcost			numeric,
reasoncode   	varchar(100),
reasondescription   varchar(255)
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.observations (
"date"         date,
patient       varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(255),
value     		varchar(1000),
units         varchar(100),
type					varchar(100)
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.organizations (
id			  varchar(1000),
"name"	      varchar(1000),
address       varchar(1000),
city		  varchar(100),
state     	  varchar(100),
zip           varchar(100),
lat		numeric,
lon 		numeric,
phone		  varchar(100),
revenue		numeric,
utilization	  varchar(100)
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.patients (
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
county		varchar(100),
zip						varchar(100),
lat		numeric,
lon		numeric,
healthcare_expenses	numeric,
healthcare_coverage	numeric
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.procedures (
"date"         date,
patient       varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(255),
base_cost		numeric,
reasoncode	varchar(1000),
reasondescription	varchar(1000)
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.providers (
id varchar(1000),
organization varchar(1000),
name varchar(100),
gender varchar(100),
speciality varchar(100),
address varchar(255),
city varchar(100),
state varchar(100),
zip varchar(100),
lat numeric,
lon numeric,
utilization numeric
);


