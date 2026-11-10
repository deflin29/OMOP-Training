# Packages
library(omock)
library(duckdb)
library(CDMConnector)
library(dplyr)
library(tidyr)
library(DBI)
library(here)
library(CodelistGenerator)

# Check available mock datasets
availableMockDatasets()


# Create GiBleed CDM
cdm <- mockCdmFromDataset(
  datasetName = "GiBleed",
  source = "duckdb"
)

# Inspect person table
cdm$person


# Count conditions
cdm$condition_occurrence |>
  group_by(condition_concept_id) |>
  tally() |>
  left_join(
    cdm$concept |>
      select(concept_id, concept_name),
    by = c("condition_concept_id" = "concept_id")
  ) |>
  collect() |>
  arrange(desc(n))


# Inspect vocabulary tables
cdm$concept_ancestor |> glimpse()
cdm$concept_relationship |> glimpse()
cdm$concept_synonym |> glimpse()


# Vocabulary information
vocabularyVersion(cdm = cdm)

availableVocabularies(cdm = cdm)

availableConceptClassIds(
  cdm = cdm,
  standardConcept = "Standard",
  domain = "Drug"
)

availableDomains(cdm = cdm)


availableConceptClassIds(
  cdm = cdm,
  standardConcept = "Standard",
  domain = "Condition"
)




availableRelationshipIds(
  cdm = cdm,
  standardConcept1 = "Standard",
  standardConcept2 = "Standard",
  domains1 = "condition",
  domains2 = "condition"
)



availableRelationshipIds(
  cdm = cdm,
  standardConcept1 = "Standard",
  standardConcept2 = "Non-standard",
  domains1 = "condition",
  domains2 = "condition"
)


availableDoseForms(cdm = cdm)
