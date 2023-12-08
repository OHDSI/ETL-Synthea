/*
@targetDialect Optional indices to speed up ETL.
*/

CREATE INDEX source_to_standard_vocab_map_sctditvisvitsctir ON @cdmDatabaseSchema.source_to_standard_vocab_map (
	source_code,
	target_domain_id,
 	target_vocabulary_id,
	source_vocabulary_id,
	target_standard_concept,
	target_invalid_reason
);

CREATE INDEX source_to_standard_vocab_map_scsvsd ON @cdmDatabaseSchema.source_to_standard_vocab_map (
	source_code,
	source_vocabulary_id,
	source_domain_id
);

CREATE INDEX source_to_source_vocab_map_scsvisdi ON @cdmDatabaseSchema.source_to_source_vocab_map (
	source_code,
	source_vocabulary_id,
	source_domain_id
);

CREATE INDEX provider_psv ON @cdmDatabaseSchema.provider (
	provider_source_value
);

CREATE INDEX person_psv ON @cdmDatabaseSchema.person (
	person_source_value
);

{@syntheaVersion == '3.0.0'}?{
  CREATE INDEX claims_transactions_cpap ON @syntheaSchema.claims_transactions (
  	claimid,
  	patientid,
  	appointmentid,
  	providerid
  );
}
