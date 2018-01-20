library(tidyverse)
source("./utils.R")

# get all clinical XML data as dataframes from TCGA by project
GetClinicalData <- function(proj) {
  QueryData(proj, "Clinical") %>%
    PrepareClinicalXMLData(c("admin", "patient", "stage_event", "radiation", "follow_up", "drug", "new_tumor_event"))
}