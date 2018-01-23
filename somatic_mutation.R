library(tidyverse)
source("./utils.R")

GetSomaticMutationData <- function(proj, pipelines = c("muse", "varscan2", "somaticsniper", "mutect")) {
  results <- pipelines %>% 
    map(function(pipeline) QueryMutationData(proj, pipeline))
  
  names(results) <- lapply(pipelines, function(pipeline) paste0("somatic_mutation_", pipeline))
  return(results)
}