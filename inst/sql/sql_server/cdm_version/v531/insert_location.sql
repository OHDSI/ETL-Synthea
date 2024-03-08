

insert into @cdm_schema.location (
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
row_number() over () as location_id,
locations.*
from
(select distinct
cast(null as varchar)               address_1,
cast(null as varchar)               address_2,
p.city                              city,
states_map.state_abbreviation       state,
cast(null as varchar)               county,
p.zip                               zip,
p.zip                               location_source_value
from @synthea_schema.patients p
left join @cdm_schema.states_map states_map on p.state=states_map.state) locations
;
