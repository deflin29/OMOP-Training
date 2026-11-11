library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)
library(grid)
library(png)

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