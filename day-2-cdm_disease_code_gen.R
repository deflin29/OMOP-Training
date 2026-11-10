asthma_codes <- getCandidateCodes(
  cdm = cdm,
  keywords = "asthma",
  domains = "Condition"
)
asthma_codes |> glimpse()
asthma_codes