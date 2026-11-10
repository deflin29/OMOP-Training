
# 1. Vocabulary version
vocabularyVersion(cdm = cdm)


# 2. Total concepts and standard concepts
cdm$concept |>
  summarise(
    total_concepts = n(),
    standard_concepts = sum(
      standard_concept == "S",
      na.rm = TRUE
    )
  ) |>
  collect()


# Concept type breakdown
cdm$concept |>
  count(standard_concept) |>
  collect()


# 3. Available domains
availableDomains(cdm = cdm)


# Number of concepts in each domain
cdm$concept |>
  count(domain_id, sort = TRUE) |>
  collect()

cdm$concept



availableRelationshipIds(
  cdm = cdm,
  standardConcept1 = "Standard",
  standardConcept2 = "Non-standard",
  domains1 = "condition",
  domains2 = "condition"
)


# Drug Dose Forms

availableDoseForms(cdm = cdm)

ingredients <- getDrugIngredientCodes(cdm = cdm, nameStyle = "{concept_name}")
ingredients


ingredients$warfarin


cdm$concept |>
  filter(concept_id %in% c(1310149, 40163554))

cdm_mock <- cdm

atc <- getATCCodes(cdm = cdm, nameStyle = "{concept_name}")
atc