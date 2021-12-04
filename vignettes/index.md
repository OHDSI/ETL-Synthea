---
layout: default
title: Home
nav_order: 1
description: "This document is meant to describe the ETL process for the synthea dataset"

---

# Synthea ETL Documentation

This guide is meant to show the process by which the synthetic data set [Synthea](https://synthetichealth.github.io/synthea/) was converted to the [OMOP Common Data Model](https://github.com/OHDSI/CommonDataModel). The SyntheticHealth team is continually adding new tables to Synthea, however, we chose to map the following: 

* [Patients](https://github.com/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary#patients)
* [Encounters](https://github.com/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary#encounters)
* [Conditions](https://github.com/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary#conditions)
* [Medications](https://github.com/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary#medications)
* [Observations](https://github.com/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary#observations)
* [Procedures](https://github.com/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary#procedures)
* [Allergies](https://github.com/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary#allergies)
* [Immunizations](https://github.com/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary#immunizations)
