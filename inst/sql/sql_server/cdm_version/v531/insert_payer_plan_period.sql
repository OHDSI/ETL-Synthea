
insert into @cdm_schema.payer_plan_period (
  payer_plan_period_id,
  person_id,
  payer_plan_period_start_date,
  payer_plan_period_end_date,
  payer_concept_id,
  payer_source_value,
  payer_source_concept_id,
  plan_concept_id,
  plan_source_value,
  plan_source_concept_id,
  sponsor_concept_id,
  sponsor_source_value,
  sponsor_source_concept_id,
  family_source_value,
  stop_reason_concept_id,
  stop_reason_source_value,
  stop_reason_source_concept_id
)

select row_number()over(order by pat.id, pt.start_year) payer_plan_period_id,
       per.person_id                                    person_id,
	   '01-JAN-'||cast(pt.start_year as varchar)        payer_plan_period_start_date,
	   '31-DEC-'||cast(pt.end_year as varchar)          payer_plan_period_end_date,	   
	   0                                                payer_concept_id,
	   pt.payer                                         payer_source_value,
	   0                                                payer_source_concept_id,
	   0                                                plan_concept_id,
	   pay.name                                         plan_source_value,
	   0                                                plan_source_concept_id,
	   0                                                sponsor_concept_id,
	   cast(null as varchar)                            sponsor_source_value,
	   0                                                sponsor_source_concept_id,
	   cast(null as varchar)                            family_source_value,
	   0                                                stop_reason_concept_id,
	   cast(null as varchar)                            stop_reason_source_value,
	   0                                                stop_reason_source_concept_id
  from @synthea_schema.payers pay 
  join @synthea_schema.payer_transitions pt
    on pay.id = pt.payer
  join @synthea_schema.patients pat
    on pt.patient = pat.id  
  join @cdm_schema.person per
    on pat.id = per.person_source_value
;	