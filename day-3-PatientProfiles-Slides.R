library(PatientProfiles)
library(CDMConnector)
library(CohortConstructor)
library(duckdb)
library(dplyr)
library(here)
library(omock)
library(DBI)



cdm <- omock::mockCdmFromDataset(source = "duckdb", datasetName = "synpuf-1k" )