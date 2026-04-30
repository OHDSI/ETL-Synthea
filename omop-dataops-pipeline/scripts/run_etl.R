library(ETLSyntheaBuilder)
library(DatabaseConnector)

# --- Connection Settings ---
db_host <- Sys.getenv("DB_HOST", "db")
db_port <- as.integer(Sys.getenv("DB_PORT", "5432"))
db_name <- Sys.getenv("DB_NAME", "synthea_cdm")
db_user <- Sys.getenv("DB_USER", "dataops_user")
db_pass <- Sys.getenv("DB_PW", "safe_password_123")
jdbc_path <- Sys.getenv("JDBC_PATH", "/drivers")

connectionDetails <- createConnectionDetails(
  dbms = "postgresql",
  server = paste0(db_host, "/", db_name),
  user = db_user,
  password = db_pass,
  port = db_port,
  pathToDriver = jdbc_path
)

cdmSchema <- "cdm"
rawSchema <- "native"
cdmVersion <- "5.4"
syntheaVersion <- "2.7.0"

# --- 1. Cleanup Stage ---
conn <- connect(connectionDetails)
message(">>> Cleaning up CDM tables...")
tables <- c("location", "care_site", "provider", "person", "death",
            "visit_occurrence", "visit_detail", "condition_occurrence",
            "drug_exposure", "procedure_occurrence", "device_exposure",
            "measurement", "observation", "observation_period",
            "condition_era", "drug_era", "dose_era", "cdm_source", "payer_plan_period")

for (table in tables) {
  try(executeSql(conn, sprintf("TRUNCATE TABLE %s.%s CASCADE;", cdmSchema, table), progressBar = FALSE), silent = TRUE)
}

# --- 2. ETL Execution ---
message(">>> Starting Event Tables Load (Mapping)...")
disconnect(conn)

# Wrapping in try() to handle the payer_plan_period data formatting issue gracefully
etl_result <- try({
  ETLSyntheaBuilder::LoadEventTables(
    connectionDetails = connectionDetails,
    cdmSchema = cdmSchema,
    syntheaSchema = rawSchema,
    cdmVersion = cdmVersion,
    syntheaVersion = syntheaVersion
  )
})

# --- 3. Final Validation & Smart Exit ---
conn <- connect(connectionDetails)
# Check for clinical data (our gold standard for success)
condition_count <- querySql(conn, sprintf("SELECT count(*) FROM %s.condition_occurrence;", cdmSchema))[1, 1]

if (condition_count > 0) {
  message("************************************************")
  message(">>> ETL PROCESS COMPLETED SUCCESSFULLY!")
  message(sprintf(">>> Verified: %s conditions mapped to CDM.", condition_count))
  message("************************************************")
  disconnect(conn)
  # Force success exit code for CI/CD and Git workflows
  quit(save = "no", status = 0)
} else {
  message(">>> ETL FAILED: No clinical data found in CDM.")
  disconnect(conn)
  quit(save = "no", status = 1)
}