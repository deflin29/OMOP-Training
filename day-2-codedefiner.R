sinusitis_codes <- getCandidateCodes(
  cdm = cdm,
  keywords = "sinusitis",
  domains = "Condition"
)
nrow(sinusitis_codes)

sinusitis_codes_2 <- getCandidateCodes(
  cdm = cdm,
  keywords = "sinusitis",
  domains = c("Condition", "Observation")
)
nrow(sinusitis_codes_2)