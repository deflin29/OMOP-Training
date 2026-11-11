# 1. Load packages
library(PatientProfiles)
library(CDMConnector)
library(CohortConstructor)
library(duckdb)
library(dplyr)
library(here)
library(omock)
library(DBI)

# 2. Create the CDM object - reload if missing OR its connection is dead
if (!exists("cdm") || !DBI::dbIsValid(CDMConnector::cdmCon(cdm))) {
  cdm <- omock::mockCdmFromDataset(source = "duckdb", datasetName = "synpuf-1k")
}


# 3. Create the cohorts from the slides
cdm$my_cohort <- conceptCohort(
  cdm = cdm,
  conceptSet = list(arthritis = c(80180, 80809)),
  name = "my_cohort"
)

cdm$medications <- conceptCohort(        # needed for the next Your Turn
  cdm = cdm,
  conceptSet = list(heparin = 1367571),
  name = "medications"
)

cdm$my_cohort

# 4. Your Turn 1: add demographics (index date = cohort_start_date)
my_cohort_demographics <- cdm$my_cohort |>
  addDemographics(
    age = FALSE,                    # don't keep numeric age
    ageGroup = list(                # -> "age_group" column
      "<18"   = c(0, 17),
      "18-64" = c(18, 64),
      "65+"   = c(65, Inf)
    ),
    sex = TRUE,                     # -> "sex" column
    priorObservation = TRUE,        # -> "prior_observation"
    priorObservationType = "days",
    futureObservation = TRUE,       # -> "future_observation"
    futureObservationType = "days"
  )

my_cohort_demographics |> glimpse()

my_cohort_demographics |>
  count(sex, age_group) |>
  collect()


# 5. Your Turn 2: year before index = window c(-365, -1) days
my_cohort_prior <- cdm$my_cohort |>
  addCohortIntersectFlag(
    targetCohortTable = "medications",
    targetCohortId = "heparin",
    window = c(-365, -1),
    nameStyle = "prior_{cohort_name}"   # -> "prior_heparin" (1 = yes, 0 = no)
  ) |>
  addTableIntersectCount(
    tableName = "condition_occurrence",
    window = c(-365, -1),
    nameStyle = "prior_conditions"      # -> number of condition records
  )

my_cohort_prior |> glimpse()

my_cohort_prior |>
  count(prior_heparin) |>
  collect()



