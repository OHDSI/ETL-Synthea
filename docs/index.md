---
layout: default
title: Home
nav_order: 1
description: "This document is meant to describe the ETL process for the synthea dataset"

---

# Synthea ETL Documentation

This guide is meant to show the process by which the synthetic data set [Synthea](https://synthetichealth.github.io/synthea/) was converted to the [OMOP Common Data Model](https://github.com/OHDSI/CommonDataModel). The SyntheticHealth team is continually adding new tables to Synthea, however, we chose to map the following: 

	* Patients
	* Encounters
	* Conditions
	* Medications
	* Observations
	* Procedures
	* Allergies
	* Immunizations

The below image illustrates how each Synthea table was mapped to its corresponding OMOP CDM table(s). Some of the native tables were mapped to more than one CDM table and that is largely due to vocabulary and domain movement. 

![](syntheaETL_files/image1.png) 
