library(TCGAbiolinks)
library(tidyverse)

QueryData <- function(proj, category, workflow, data.type) {
  result <- tryCatch({
    query <- GDCquery(project = proj, data.category = category, workflow.type = workflow, data.type = data.type)
    GDCdownload(query)
    return(query)
  }, error = function(e) {
    message(paste("Error:", proj, category, e, sep = " "))
  })
  
  return(result)
}

QueryMutationData <- function(proj, pipeline) {
  # Creates a dataframe from the somatic mutation query results for the pipeline
  
  projs <- getGDCprojects()
  rownames(projs) <- projs$id
  tumor <- projs[proj, "tumor"]
  
  GDCquery_Maf(tumor, pipelines = pipeline)
}

ProjectIds <- function() {
  getGDCprojects()$project_id %>%
    str_subset("TCGA")
}

PrepareClinicalXMLData <- function(query.result, clinical.info.type) {
  # Create a dataframe from the clinical and biospecimen XML query results
  #
  # Args:
  #   query.results: the output of QueryData for categories of "Clinical" or "Biospecimen"
  #   clinical.info.type: clinical.info in the XML to be extracted into dataframes;
  #     relation between one patient and other clinical information is 1:n
  # Returns:
  #   a dataframe of the clinical.info
  
  GDCprepare_clinic(query.result, clinical.info = clinical.info.type)
}

Prepare <- function(query.result) {
  GDCprepare(query.result, summarizedExperiment = FALSE)
}