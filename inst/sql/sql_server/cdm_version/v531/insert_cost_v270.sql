
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

select row_number()over(order by tmp.cost_event_id) cost_id,
       tmp.*
from (
select distinct 
       po.procedure_occurrence_id                            cost_event_id,
	   'Procedure'                                           cost_domain_id,
	   32814                                                 cost_type_concept_id,
	   44818668                                              currency_concept_id,
	   e.total_claim_cost + pr.base_cost                     total_charge, 
	   e.total_claim_cost + pr.base_cost                     total_cost, 
       e.payer_coverage   + pr.base_cost                     total_paid,
	   e.payer_coverage                                      paid_by_payer,
	   e.total_claim_cost + pr.base_cost - e.payer_coverage  paid_by_patient,
	   cast(null as numeric)                                 paid_patient_copay,
	   cast(null as numeric)                                 paid_patient_coinsurance,
	   cast(null as numeric)                                 paid_patient_deductible,
	   cast(null as numeric)                                 paid_by_primary,
	   cast(null as numeric)                                 paid_ingredient_cost,
	   cast(null as numeric)                                 paid_dispensing_fee,
	   ppp.payer_plan_period_id                              payer_plan_period_id,
	   cast(null as numeric)                                 amount_allowed,
	   0                                                     revenue_code_concept_id,
       'UNKNOWN / UNKNOWN'                                   revenue_code_source_value,
       0                                                     drg_concept_id,
       '000'                                                 drg_source_value	   
from @synthea_schema.procedures pr 
join @synthea_schema.encounters e 
  on pr.encounter = e.id 
 and pr.patient   = e.patient 
join @cdm_schema.person p 
  on pr.patient = p.person_source_value
join @cdm_schema.visit_occurrence 
  vo on p.person_id = vo.person_id 
 and e.id           = vo.visit_source_value
join @cdm_schema.procedure_occurrence po
  on pr.code                = po.procedure_source_value
 and vo.visit_occurrence_id = po.visit_occurrence_id
 and vo.person_id           = po.person_id
left join @cdm_schema.payer_plan_period ppp
  on p.person_id                       = ppp.person_id  
 and ppp.payer_plan_period_start_date <= po.procedure_date
 and ppp.payer_plan_period_end_date   >= po.procedure_date
 
union all

select distinct 
       de.drug_exposure_id                                   cost_event_id,
	   'Drug'                                                cost_domain_id,
	   32814                                                 cost_type_concept_id,
	   44818668                                              currency_concept_id,
	   e.total_claim_cost + i.base_cost                      total_charge, 
	   e.total_claim_cost + i.base_cost                      total_cost, 
       e.payer_coverage   + i.base_cost                      total_paid,
	   e.payer_coverage                                      paid_by_payer,
	   e.total_claim_cost + i.base_cost - e.payer_coverage   paid_by_patient,
	   cast(null as numeric)                                 paid_patient_copay,
	   cast(null as numeric)                                 paid_patient_coinsurance,
	   cast(null as numeric)                                 paid_patient_deductible,
	   cast(null as numeric)                                 paid_by_primary,
	   cast(null as numeric)                                 paid_ingredient_cost,
	   cast(null as numeric)                                 paid_dispensing_fee,
	   ppp.payer_plan_period_id                              payer_plan_period_id,
	   cast(null as numeric)                                 amount_allowed,
	   0                                                     revenue_code_concept_id,
       'UNKNOWN / UNKNOWN'                                   revenue_code_source_value,
       0                                                     drg_concept_id,
       '000'                                                 drg_source_value	   
from @synthea_schema.immunizations i 
join @synthea_schema.encounters e 
  on i.encounter = e.id 
 and i.patient   = e.patient 
join @cdm_schema.person p 
  on i.patient = p.person_source_value
join @cdm_schema.visit_occurrence vo 
  on p.person_id = vo.person_id 
 and e.id        = vo.visit_source_value
join @cdm_schema.drug_exposure de
  on i.code                 = de.drug_source_value
 and vo.visit_occurrence_id = de.visit_occurrence_id
 and vo.person_id           = de.person_id
left join @cdm_schema.payer_plan_period ppp
  on p.person_id                       = ppp.person_id  
 and ppp.payer_plan_period_start_date <= de.drug_exposure_start_date
 and ppp.payer_plan_period_end_date   >= de.drug_exposure_start_date

union all

select distinct 
       de.drug_exposure_id                                   cost_event_id,
	   'Drug'                                                cost_domain_id,
	   32814                                                 cost_type_concept_id,
	   44818668                                              currency_concept_id,
	   e.total_claim_cost + m.base_cost                      total_charge, 
	   e.total_claim_cost + m.base_cost                      total_cost, 
       e.payer_coverage   + m.base_cost                      total_paid,
	   e.payer_coverage                                      paid_by_payer,
	   e.total_claim_cost + m.base_cost - e.payer_coverage   paid_by_patient,
	   cast(null as numeric)                                 paid_patient_copay,
	   cast(null as numeric)                                 paid_patient_coinsurance,
	   cast(null as numeric)                                 paid_patient_deductible,
	   cast(null as numeric)                                 paid_by_primary,
	   cast(null as numeric)                                 paid_ingredient_cost,
	   cast(null as numeric)                                 paid_dispensing_fee,
	   ppp.payer_plan_period_id                              payer_plan_period_id,
	   cast(null as numeric)                                 amount_allowed,
	   0                                                     revenue_code_concept_id,
       'UNKNOWN / UNKNOWN'                                   revenue_code_source_value,
       0                                                     drg_concept_id,
       '000'                                                 drg_source_value	   
from @synthea_schema.medications m 
join @synthea_schema.encounters e 
  on m.encounter = e.id 
 and m.patient   = e.patient 
join @cdm_schema.person p 
  on m.patient = p.person_source_value
join @cdm_schema.visit_occurrence vo 
  on p.person_id = vo.person_id 
 and e.id        = vo.visit_source_value
join @cdm_schema.drug_exposure de
  on m.code                 = de.drug_source_value
 and vo.visit_occurrence_id = de.visit_occurrence_id
 and vo.person_id           = de.person_id
left join @cdm_schema.payer_plan_period ppp
  on p.person_id                       = ppp.person_id  
 and ppp.payer_plan_period_start_date <= de.drug_exposure_start_date
 and ppp.payer_plan_period_end_date   >= de.drug_exposure_start_date 
 
) as tmp
;