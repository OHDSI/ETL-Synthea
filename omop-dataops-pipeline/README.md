# 🏥 OMOP-DataOps-Pipeline: Synthea to CDM Mapping

This project is a high-performance, automated ETL pipeline designed to transform synthetic medical records (**Synthea**) into the **OMOP Common Data Model (CDM) v5.4**. 

It is built with a **DataOps** mindset: focusing on reproducibility, speed, and data integrity.

## 🚀 Key Features

* **Infrastructure as Code (IaC):** Entire environment (PostgreSQL 15 + R Runtime) is managed via Docker Compose.
* **Sub-Second Performance:** Custom SQL indexing on vocabulary mapping tables reduces clinical event transformation time from hours to **less than 1 second**.
* **Data Resiliency:** Integrated regex-based cleaning logic to handle inconsistent date formats in source synthetic data (e.g., fixing the `-01-01` date error).
* **Smart Validation:** The pipeline includes a verification step that confirms clinical data integrity (e.g., Condition mapping) even if non-critical domains have source-level issues.
* **Idempotency:** Safe re-runs guaranteed by `TRUNCATE CASCADE` logic.

## 🛠 Tech Stack

* **ETL Engine:** R (`DatabaseConnector`, `ETLSyntheaBuilder`)
* **Database:** PostgreSQL 15
* **Orchestration:** GNU Make, Docker Compose
* **Source Data:** Synthea (CSV)

## 📦 Prerequisites

1.  **Vocabularies:** Download from [Athena](https://athena.ohdsi.org/) and extract to `data/vocab/`.
2.  **Raw Data:** Place Synthea CSV files in `data/synthea/csv/`.

## 🚦 Quick Start

Run the entire pipeline with one command:

```bash
make full-cycle

Or run only the ETL process:
make run-etl

📊 Performance & Verification
The pipeline is optimized to handle mapping lookups instantly. Below is the typical result of a successful run:
Final Record Counts (Verified Run)

Domain,Record Count,Standard
Patients,117,Person
Conditions,"1,840",SNOMED
Measurements,"72,854",LOINC
Drugs,"9,133",RxNorm
Condition Eras,"1,811",Derived Logic

Verification Log Output

************************************************
>>> ETL PROCESS COMPLETED SUCCESSFULLY!
>>> Verified: 1840 conditions mapped to CDM.
************************************************
omop_etl_runner exited with code 0

📂 Project Structure
├── data/
│   ├── synthea/    # Raw CSV input
│   └── vocab/      # OMOP Vocabularies
├── docs/
│   └── screenshots/# Verification images
├── scripts/
│   ├── setup_db.sql# Schema and Indexing
│   └── run_etl.R   # Main ETL & Validation Logic
├── Makefile        # Orchestration
└── docker-compose.yml

Developed for OHDSI-based research environments. Focused on turning raw data into evidence-ready assets.
"""

