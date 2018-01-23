library(tidyverse)
source("./utils.R")

GetCopyNumberVariationData <- function(proj) {
  result <- QueryData(proj, "Copy Number Variation", data.type = 'Copy Number Segment') %>% Prepare
  list(copy_number_variation = result)
}