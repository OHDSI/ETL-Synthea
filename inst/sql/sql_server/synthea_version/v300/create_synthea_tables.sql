
--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.allergies (
start        date,
stop         date,
patient      varchar(1000),
encounter    varchar(1000),
code         varchar(100),
system       varchar(255),
description  varchar(255),
"type"       varchar(255),
category     varchar(255),
reaction1    varchar(255),
description1 varchar(255),
severity1    varchar(255),
reaction2    varchar(255),
description2 varchar(255),
severity2    varchar(255)
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
category      varchar(1000),
code          varchar(100),
description   varchar(255),
value     		varchar(1000),
units         varchar(100),
"type"		  	varchar(100)
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
start         date,
stop          date,
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

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.devices (
start         date,
stop          date,
patient       varchar(1000),
encounter     varchar(1000),
code          varchar(100),
description   varchar(255),
udi           varchar(255)
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.claims (
  id                           varchar(1000),
  patientid                    varchar(1000),
  providerid                   varchar(1000),
  primarypatientinsuranceid    varchar(1000),
  secondarypatientinsuranceid  varchar(1000),
  departmentid                 varchar(1000),
  patientdepartmentid          varchar(1000),
  diagnosis1                   varchar(1000),
  diagnosis2                   varchar(1000),
  diagnosis3                   varchar(1000),
  diagnosis4                   varchar(1000),
  diagnosis5                   varchar(1000),
  diagnosis6                   varchar(1000),
  diagnosis7                   varchar(1000),
  diagnosis8                   varchar(1000),
  referringproviderid          varchar(1000),
  appointmentid                varchar(1000),
  currentillnessdate           date,
  servicedate                  date,
  supervisingproviderid        varchar(1000),
  status1                      varchar(1000),
  status2                      varchar(1000),
  statusp                      varchar(1000),
  outstanding1                 numeric,
  outstanding2                 numeric,
  outstandingp                 numeric,
  lastbilleddate1              date,
  lastbilleddate2              date,
  lastbilleddatep              date,
  healthcareclaimtypeid1       numeric,
  healthcareclaimtypeid2       numeric
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.claims_transactions (
  id                     varchar(1000),
  claimid                varchar(1000),
  chargeid               numeric,
  patientid              varchar(1000),
  "type"                 varchar(1000),
  amount                 numeric,
  method                 varchar(1000),
  fromdate               date,
  todate                 date,
  placeofservice         varchar(1000),
  procedurecode          varchar(1000),
  modifier1              varchar(1000),
  modifier2              varchar(1000),
  diagnosisref1          numeric,
  diagnosisref2          numeric,
  diagnosisref3          numeric,
  diagnosisref4          numeric,
  units                  numeric,
  departmentid           numeric,
  notes                  varchar(1000),
  unitamount             numeric,
  transferoutid          numeric,
  transfertype           varchar(1000),
  payments               numeric,
  adjustments            numeric,
  transfers              numeric,
  outstanding            numeric,
  appointmentid          varchar(1000),
  linenote               varchar(1000),
  patientinsuranceid     varchar(1000),
  feescheduleid          numeric,
  providerid             varchar(1000),
  supervisingproviderid  varchar(1000)
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.payer_transitions (
 patient           varchar(1000),
  memberid         varchar(1000),
  start_year       date,
  end_year         date,
  payer            varchar(1000),
  secondary_payer  varchar(1000),
  ownership        varchar(1000),
  ownername       varchar(1000)
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.payers (
  id                       varchar(1000),
  name                     varchar(1000),
  address                  varchar(1000),
  city                     varchar(1000),
  state_headquartered      varchar(1000),
  zip                      varchar(1000),
  phone                    varchar(1000),
  amount_covered           numeric,
  amount_uncovered         numeric,
  revenue                  numeric,
  covered_encounters       numeric,
  uncovered_encounters     numeric,
  covered_medications      numeric,
  uncovered_medications    numeric,
  covered_procedures       numeric,
  uncovered_procedures     numeric,
  covered_immunizations    numeric,
  uncovered_immunizations  numeric,
  unique_customers         numeric,
  qols_avg                 numeric,
  member_months            numeric
);

--HINT DISTRIBUTE_ON_RANDOM
create table @synthea_schema.supplies (
  "date"       date,
  patient      varchar(1000),
  encounter    varchar(1000),
  code         varchar(1000),
  description  varchar(1000),
  quantity     numeric
);

