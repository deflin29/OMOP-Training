options(
  repos = c(CRAN = "https://cloud.r-project.org"),
  timeout = 3600  # large downloads need more than the default 60 seconds
)

# 1. pak - a fast package installer -------------------------------------------
if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak")

# 2. OmopTrainer - the trainers' environment checker (from GitHub) -------------
if (!requireNamespace("OmopTrainer", quietly = TRUE)) {
  pak::pak("oxford-pharmacoepi/OmopTrainer")
}

# 3. Packages used in the training ---------------------------------------------
training_packages <- c(
  # Day 1 - tools for conducting studies
  "OmopStudyBuilder", "OmopViewer", "visOmopResults",
  "devtools", "usethis", "here", "gh",
  "gt", "flextable", "officer", "ggplot2", "scales",
  # Day 2 - phenotyping
  "CodelistGenerator", "CohortConstructor", "PhenotypeR", "MeasurementDiagnostics",
  # Day 3 - characterising a study population
  "PatientProfiles", "CohortCharacteristics",
  # OMOP data + database plumbing
  "duckdb", "omock", "OmopConstructor", "OmopSketch",
  # Other analytic packages required by the training spec
  "IncidencePrevalence", "DrugUtilisation", "CohortSurvival",
  "CohortSymmetry", "OmopIndices", "EpiStandard"
)
missing <- training_packages[!vapply(training_packages, requireNamespace,
                                     logical(1), quietly = TRUE)]
if (length(missing) > 0) install.packages(missing, type = "binary")

# 4. Mock OMOP datasets (fake patients) -----------------------------------------
# Saved into OMOP_DATA_FOLDER. Skipped if already downloaded.
for (ds in c("synpuf-1k", "delphi-100k")) {
  if (!omock::isMockDatasetDownloaded(ds)) omock::downloadMockDataset(ds)
}

# 5. Check everything ------------------------------------------------------------
OmopTrainer::validateSetup()
