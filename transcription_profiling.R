library(tidyverse)
source("./utils.R")

GetTranscriptionProfileData <- function(proj) {
  workflow.types = c("HTSeq - Counts", "HTSeq - FPKM")
  
  dfs <- workflow.types %>%
    map(function(workflow.type) {
      QueryData(proj, "Transcriptome Profiling", workflow.type)
    }) %>%
    map(Prepare)
  names(dfs) <- workflow.types
  
  return(dfs)
}