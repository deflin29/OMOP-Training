# 1. Load packages
library(duckdb)
library(CDMConnector)
library(CohortConstructor)
library(PatientProfiles)
library(CohortCharacteristics)
library(CodelistGenerator)
library(dplyr)
library(here)
library(omock)
library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)
library(grid)
library(png)

# 2. Create the CDM object - reload only if missing OR its connection is dead
if (!exists("cdm") || !DBI::dbIsValid(CDMConnector::cdmCon(cdm))) {
  cdm <- omock::mockCdmFromDataset(source = "duckdb", datasetName = "synpuf-1k")
}

# 3. Create the cohorts from the slides (one cohort per codelist)
x <- c(list(anemia = 439777,
            rheumatoid_arthritis = 80809,
            osteoarthritis = 80180,
            pneumonia = 255848),
       getDrugIngredientCodes(cdm, c("heparin", "clopidogrel"),
                              nameStyle = "{concept_name}")) |>
  newCodelist()

cdm[["my_cohort"]] <- conceptCohort(cdm = cdm,
                                    conceptSet = x,
                                    name = "my_cohort")

settings(cdm$my_cohort)   # cohort names: osteoarthritis, heparin, pneumonia, ...


# 4. Your Turn ---------------------------------------------------

# 4a. Only demographics (the default of summariseCharacteristics)
result_demo <- summariseCharacteristics(
  cohort = cdm$my_cohort,
  cohortId = "osteoarthritis"
)

tableCharacteristics(result = result_demo, header = "cohort_name")

# 4b. Demographics + heparin (prior 180 days) + pneumonia (prior 2 years)
#     window c(-180, 0)  = 180 days before up to and INCLUDING the index date
#     window c(-730, -1) = 2 years before up to the day BEFORE the index date
result <- summariseCharacteristics(
  cohort = cdm$my_cohort,
  cohortId = "osteoarthritis",
  cohortIntersectFlag = list(
    "Heparin prescriptions during the prior 180 days" = list(
      targetCohortTable = "my_cohort",
      targetCohortId = "heparin",
      window = c(-180, 0)
    ),
    "Pneumonia diagnosis during the prior 2 years" = list(
      targetCohortTable = "my_cohort",
      targetCohortId = "pneumonia",
      window = c(-730, -1)
    )
  )
)






result <- cdm$my_cohort |>
  summariseCharacteristics() |>
  filter(variable_name == "Age")

plotCharacteristics(result = result, plotStyle = "boxplot", colour = "cohort_name")

tableCharacteristics(result = result, header = "cohort_name")




result <- cdm$my_cohort |>
  summariseCharacteristics(cohortId = "osteoarthritis") |>
  filter(variable_name == "Sex" & estimate_name == "percentage")

plotCharacteristics(result = result,
                    plotStyle = "barplot",
                    facet = "cohort_name",
                    colour = "variable_level")



result <- cdm$my_cohort |>
  summariseLargeScaleCharacteristics(
    window = list(c(-Inf, -1), c(1, Inf)),
    eventInWindow = "condition_occurrence",
    minimumFrequency = 0.05
  )

glimpse(result)



