library(tidyverse)
source("./utils.R")

# get all Biospecimen XML data as dataframes from TCGA by project
GetBiospecimenData <- function(proj) {
  QueryData(proj, "Biospecimen") %>%
    PrepareClinicalXMLData(c("sample", "bio_patient", "analyte", "aliquot", "protocol", "portion", "slide"))
}