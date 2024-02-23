

insert into @cdm_schema.care_site (
care_site_id,
care_site_name,
place_of_service_concept_id,
location_id,
care_site_source_value,
place_of_service_source_value
)

select
row_number()over(order by o.id)     care_site_id,
o.name                              care_site_name,
0                                   place_of_service_concept_id,
cast(null as integer)               location_id,
o.id                                care_site_source_value,
cast(null as varchar)               place_of_service_source_value

from @synthea_schema.organizations o
;
