
insert into @cdm_schema.cost (
  cost_id,
  cost_event_id,
  cost_domain_id,
  cost_type_concept_id,
  currency_concept_id,
  total_charge,
  total_cost,
  total_paid,
  paid_by_payer,
  paid_by_patient,
  paid_patient_copay,
  paid_patient_coinsurance,
  paid_patient_deductible,
  paid_by_primary,
  paid_ingredient_cost,
  paid_dispensing_fee,
  payer_plan_period_id,
  amount_allowed,
  revenue_code_concept_id,
  revenue_code_source_value,
  drg_concept_id,
  drg_source_value
)

select row_number()over(order by pr.procedure_occurrence_id) cost_id,
       pr.procedure_occurrence_id                            cost_event_id,
	   'Procedure'                                           cost_domain_id,
	   32814                                                 cost_type_concept_id,
	   44818668                                              currency_concept_id,
	   e.total_claim_cost + p.base_cost                      total_charge, 
	   e.total_claim_cost + p.base_cost                      total_cost, 
       e.payer_coverage   + p.base_cost                      total_paid,
	   e.payer_coverage                                      paid_by_payer,
	   e.total_claim_cost + p.base_cost - e.payer_coverage   paid_by_patient,
	   CAST(NULL AS NUMERIC)                                 paid_patient_copay,
	   CAST(NULL AS NUMERIC)                                 paid_patient_coinsurance,
	   CAST(NULL AS NUMERIC)                                 paid_patient_deductible,
	   CAST(NULL AS NUMERIC)                                 paid_by_primary,
	   CAST(NULL AS NUMERIC)                                 paid_ingredient_cost,
	   CAST(NULL AS NUMERIC)                                 paid_dispensing_fee,
	                                                         payer_plan_period_id,
	   0                                                     revenue_code_concept_id,
       'UNKNOWN / UNKNOWN'                                   revenue_code_source_value,
       0                                                     drg_concept_id,
       '000'                                                 drg_source_value	   
from @synthea_schema.procedures p
join @synthea_schema.encounters e 
  on p.encounter = e.id and p.patient = e.patient
join @cdm_schema.procedure_occurrence po
  on po.procedure_source_value = p.code
;

  
  