drop sequence if exists location_id_seq;
create sequence location_id_seq start 1;

insert into location (
location_id,
address_1,
address_2,
city,
state,
zip,
county,
location_source_value
)
select
nextval('location_id_seq'),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
substring(address from 1 for 50)
from patients;
