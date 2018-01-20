library(TCGAbiolinks)
library(tidyverse)

QueryData <- function(proj, category, workflow) {
  result <- tryCatch({
    query <- GDCquery(project = proj, data.category = category, workflow.type = workflow)
    GDCdownload(query)
    return(query)
  }, error = function(e) {
    message(paste("Error:", proj, category, e, sep = " "))
  })
  
  return(result)
}

ProjectIds <- function() {
  getGDCprojects()$project_id %>%
    str_subset("TCGA")
}

PrepareClinicalXMLData <- function(query.result, clinical.info.types) {
  # Creates dataframes from the clinical and biospecimen XML query results
  #
  # Args:
  #   query.results: the output of QueryData for categories of "Clinical" or "Biospecimen"
  #   clinical.info.types: list of characters. clinical.info in the XML to be extracted into dataframes;
  #     relation between one patient and other clinical information is 1:n
  # Returns:
  #   a named list of dataframes by clinical info types
  
  clinical.dfs <- clinical.info.types %>%
    map(function(info.type) {
      GDCprepare_clinic(query.result, clinical.info = info.type)
    })
  names(clinical.dfs) <- clinical.info.types
  
  return(clinical.dfs)
}

Prepare <- function(query.result) {
  GDCprepare(query.result, summarizedExperiment = FALSE)
}