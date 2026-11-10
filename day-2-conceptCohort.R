# 1. Install required packages if missing
required_packages <- c(
  "omock",
  "CDMConnector",
  "CodelistGenerator",
  "CohortConstructor",
  "CohortCharacteristics",
  "duckdb",
  "DBI",
  "dplyr",
  "gt",
  "here"
)

missing_packages <- required_packages[
  !vapply(
    required_packages,
    requireNamespace,
    quietly = TRUE,
    FUN.VALUE = logical(1)
  )
]

if (length(missing_packages) > 0) {
  install.packages(missing_packages)
}

# 2. Load packages
library(omock)
library(CDMConnector)
library(CodelistGenerator)
library(CohortConstructor)
library(CohortCharacteristics)
library(duckdb)
library(DBI)
library(dplyr)
library(gt)
library(here)

# 3. Update omock
install.packages("omock")

# 4. Download a fresh Delphi 100K dataset
downloadMockDataset(
  datasetName = "delphi-100k_5.4",
  overwrite = TRUE
)

# 5. Verify dataset download
if (!isMockDatasetDownloaded("delphi-100k_5.4")) {
  stop("Delphi 100K dataset download failed. Check disk space and permissions.")
}

cat("\nDelphi 100K dataset is available.\n")

# 6. Create CDM
cdm <- mockCdmFromDataset(
  datasetName = "delphi-100k_5.4",
  source = "duckdb"
)

cat("\nCDM created successfully.\n")

# 7. Check person table
cat("\nPerson table count:\n")

cdm$person |>
  tally() |>
  collect() |>
  print()

# 8. Define condition concept codes
codes <- list(
  "ra" = c(80809L),
  "pneumonia" = c(255848L)
) |>
  newCodelist()

# 9. Display concept codes
print(codes)

# 10. Create condition cohorts
cdm$base_conditions_cohort <- conceptCohort(
  cdm = cdm,
  conceptSet = codes,
  name = "base_conditions_cohort"
)

cat("\nCondition cohorts created successfully.\n")

# 11. Summarise cohort counts
cohort_counts <- summariseCohortCount(
  cohort = cdm$base_conditions_cohort
)

# 12. Display cohort count table
cohort_counts |>
  tableCohortCount()