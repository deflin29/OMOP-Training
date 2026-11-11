
# ============================================================
# HDS OMOP TRAINING
# Exercise 2: Requirement and Filtering
# Exercise 3: Update Cohort Entry and Exit
# Dataset: Delphi 100K
# ============================================================


# ============================================================
# STEP 1: INSTALL AND LOAD REQUIRED PACKAGES
# ============================================================

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
  "here",
  "omopgenerics"
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

# Load packages
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
library(omopgenerics)


# ============================================================
# STEP 2: DOWNLOAD AND PREPARE DELPHI 100K DATASET
# ============================================================

# If you previously encountered a corrupted Parquet download,
# run this once to replace the existing dataset.

downloadMockDataset(
  datasetName = "delphi-100k_5.4",
  overwrite = TRUE
)

# Create CDM
cdm <- mockCdmFromDataset(
  datasetName = "delphi-100k_5.4",
  source = "duckdb"
)

# Check person table
cdm$person |>
  tally() |>
  collect()


# ============================================================
# STEP 3: CREATE BASE CONDITION COHORT
# ============================================================

# Define Rheumatoid Arthritis and Pneumonia concepts

codes <- list(
  "ra" = c(80809L),
  "pneumonia" = c(255848L)
) |>
  newCodelist()

# Create base cohort

cdm$base_conditions_cohort <- conceptCohort(
  cdm = cdm,
  conceptSet = codes,
  name = "base_conditions_cohort"
)

# Check base cohort counts

summariseCohortCount(
  cohort = cdm$base_conditions_cohort
) |>
  tableCohortCount()


# ============================================================
# EXERCISE 2: REQUIREMENT AND FILTERING
# ============================================================

# Define Osteoarthritis concept codes

osteoarthritisCodes <- list(
  "osteoarthritis" = c(80180L)
) |>
  newCodelist()

# Apply date range and exclude prior/concurrent
# Osteoarthritis diagnoses from the RA cohort

cdm$study_cohort <- cdm$base_conditions_cohort |>
  
  requireInDateRange(
    dateRange = as.Date(
      c("1990-01-01", "2011-12-31")
    ),
    name = "study_cohort"
  ) |>
  
  requireConceptIntersect(
    conceptSet = osteoarthritisCodes,
    cohortId = "ra",
    window = list(c(-Inf, 0)),
    intersections = 0,
    name = "study_cohort"
  )

# Display Exercise 2 attrition

summariseCohortAttrition(
  cohort = cdm$study_cohort
) |>
  tableCohortAttrition()


# ============================================================
# EXERCISE 3: UPDATE COHORT ENTRY AND EXIT
# ============================================================

cdm$study_cohort <- cdm$study_cohort |>
  
  # 1. Rheumatoid Arthritis:
  # Extend cohort exit to the end of observation
  
  exitAtObservationEnd(
    cohortId = "ra",
    persistAcrossObservationPeriods = TRUE,
    name = "study_cohort"
  ) |>
  
  # 2. Pneumonia:
  # Extend cohort end date by 60 days
  
  padCohortDate(
    days = 60,
    cohortDate = "cohort_end_date",
    cohortId = "pneumonia",
    name = "study_cohort"
  )


# ============================================================
# STEP 4: FINAL COHORT ATTRITION
# ============================================================

cat("\nFINAL COHORT ATTRITION\n")

summariseCohortAttrition(
  cohort = cdm$study_cohort
) |>
  tableCohortAttrition()


# ============================================================
# STEP 5: FINAL COHORT COUNTS
# ============================================================

cat("\nFINAL COHORT COUNTS\n")

summariseCohortCount(
  cohort = cdm$study_cohort
) |>
  tableCohortCount()


cdm$study_cohort <- cdm$study_cohort |>
  intersectCohorts(
    keepOriginalCohorts = TRUE,
    name = "study_cohort",
  ) |>
  renameCohort(
    newCohortName = c("aki", "ckd", "aki_ckd")
  )

summariseCohortAttrition(cohort = cdm$study_cohort) |>
  tableCohortAttrition() 
