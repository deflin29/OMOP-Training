
# ============================================
# HDS OMOP Training
# OMOP CDM - Memantine Drug Concept Exercise
# Dataset: GiBleed
# ============================================

# 1. Load packages
library(omock)
library(duckdb)
library(CDMConnector)
library(dplyr)
library(CodelistGenerator)

# 2. Create GiBleed CDM
cdm <- mockCdmFromDataset(
  datasetName = "GiBleed",
  source = "duckdb"
)

# 3. Get drug ingredient codes for Memantine
ingredients <- getDrugIngredientCodes(
  cdm = cdm,
  name = "memantine",
  nameStyle = "{concept_name}"
)

# 4. Display Memantine concept IDs
cat("\nMemantine concept IDs:\n")
print(ingredients$memantine)

# Count the number of Memantine codes
number_of_codes <- length(ingredients$memantine)

cat("\nNumber of Memantine codes:", number_of_codes, "\n")

# 5. Extract Memantine concept IDs
# Note: ingredients$memantine is an atomic vector,
# so do not use $concept_id.
memantine_codes <- ingredients$memantine

# 6. Count Memantine records in drug_exposure
memantine_exposure <- cdm$drug_exposure |>
  filter(drug_concept_id %in% memantine_codes) |>
  summarise(
    total_records = n()
  ) |>
  collect()

cat("\nTotal Memantine drug exposure records:\n")
print(memantine_exposure)

# 7. Display all matching drug exposure records
memantine_records <- cdm$drug_exposure |>
  filter(drug_concept_id %in% memantine_codes) |>
  collect()

cat("\nMatching Memantine drug exposure records:\n")
print(memantine_records)

# 8. Final answers
cat("\n========== FINAL ANSWERS ==========\n")
cat("1. Number of Memantine codes:", number_of_codes, "\n")
cat("2. Number of drug exposure records:",
    memantine_exposure$total_records, "\n")
cat("===================================\n")
