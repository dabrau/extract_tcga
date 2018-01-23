library(tidyverse)
source("./utils.R")

GetXMLData <- function(proj, data.category, clinical.info) {
  query.result <- QueryData(proj, data.category)
  
  results <- clinical.info %>%
    map(function(info.type) PrepareClinicalXMLData(query.result, info.type))
  
  names(results) <- clinical.info
  return(results)
}

# get all clinical XML data as dataframes from TCGA by project
GetClinicalData <- function(proj, clinical.info = c("admin", "patient", "stage_event", 
                                              "radiation", "follow_up", "drug",
                                              "new_tumor_event")) {
  GetXMLData(proj, "Clinical", clinical.info)
}

# get all Biospecimen XML data as dataframes from TCGA by project
GetBiospecimenData <- function(proj, clinical.info = c("sample", "bio_patient", "analyte",
                                                 "aliquot", "protocol", "portion",
                                                 "slide")) {
  GetXMLData(proj, "Biospecimen", clinical.info)
}