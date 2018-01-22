library(tidyverse)
source("./utils.R")

GetCopyNumberVariationData <- function(proj) {
  QueryData(proj, "Copy Number Variation", data.type = 'Copy Number Segment') %>% Prepare
}