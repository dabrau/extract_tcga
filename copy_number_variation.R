library(tidyverse)
source("./utils.R")

CopyNumberVariationData <- function(proj) {
  QueryData(proj, "Copy Number Variation", data.type = 'Copy Number Segment') %>% Prepare
}