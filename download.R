library(tidyverse)
library(parallel)

source("./clinical.R")
source("./transcription_profiling.R")
source("./somatic_mutation.R")
source("./copy_number_variation.R")

data.getters <- list(
  clinical = GetClinicalData,
  biospecimen = GetBiospecimenData,
  transcription_profile = GetTranscriptionProfileData,
  somatic_mutation = GetSomaticMutationData,
  copy_number_variation = GetCopyNumberVariationData)

DownloadProjectData <- function(proj, getters = data.getters, dir = ".") {
  # create project directory
  path <- file.path(dir, proj)
  if (!dir.exists(path)) {
    dir.create(path)
  }
  
  # download and prepare the project data
  project.data <- names(getters) %>% map(function(getter) data.getters[[getter]](proj))
  names(project.data) <- names(getters)
  
  for (data.category in names(project.data)) {
    
    # create category dir, e.g. "./TCGA-SKCM/clinical"
    category.dir <- file.path(path, data.category)
    if (!dir.exists(category.dir)) {
      dir.create(category.dir)
    }
    
    # write csv's of dataframes
    project.category.data <- project.data[[data.category]]
    for (df.name in names(project.category.data)) {
      file.name <- paste0(df.name, ".csv")
      df <- project.category.data[[df.name]]
      if (!is.null(df)) {
        write_csv(df, file.path(category.dir, file.name))
      }
    }
  }
}

DownloadAllProjects <- function(folder.name = "TCGA") {
  # Calculate the number of cores
  no_cores <- detectCores() - 1
  # Initiate cluster
  cl <- makeCluster(no_cores)
  
  clusterEvalQ(cl, library(tidyverse))
  clusterEvalQ(cl, source("./clinical.R"))
  clusterEvalQ(cl, source("./transcription_profiling.R"))
  clusterEvalQ(cl, source("./somatic_mutation.R"))
  clusterEvalQ(cl, source("./copy_number_variation.R"))
  clusterEvalQ(cl, source("./download.R"))
  
  # create tcga directory
  dir <- file.path(".", folder.name)
  if (!dir.exists(dir)) {
    dir.create(dir)
  }
  
  # download all project data in parallel
  tryCatch({
    parLapply(cl, ProjectIds(), function(project.id) DownloadProjectData(project.id, dir = dir))
  }, error = function(e) {
    stopCluster(cl)
    message(paste("Error:", e, sep = " "))
  })
  
  stopCluster(cl)
}