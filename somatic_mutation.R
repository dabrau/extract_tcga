library(tidyverse)
source("./utils.R")

GetSomaticMutationData <- function(proj, pipelines) {
  dfs <- pipelines %>%
    map(function(pipeline) QueryMutationData(proj, pipeline))
  
  names(dfs) <- pipelines
  return(dfs)
}