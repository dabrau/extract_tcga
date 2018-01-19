library(TCGAbiolinks)
library(tidyverse)

# get all clinical XML as dataframes from TCGA by project
GetClinical <- function(proj) {
  message(proj)
  
  # list of clinical inofo types, relation between one patient and other clinical information are 1:n
  clinical.info.types <- c("admin", "patient", "stage_event", "radiation", "follow_up", "drug", "new_tumor_event")
    
    clinical.data <- tryCatch({
      
      # query and download clinical data for TCGA project
      query <- GDCquery(project = proj, data.category = "Clinical")
      GDCdownload(query)
      
      # create a list of clinical info dataframes
      clinical.dfs <- clinical.info.types %>%
        map(function(clinical.info.type) {
          clinical.df <- GDCprepare_clinic(query, clinical.info = clinical.info.type)
          return(clinical.df)
        })
      names(clinical.dfs) <- clinical.info.types
      
      return(clinical.dfs)
      
      }, error = function(e) {
      message(paste0("Error clinical: ", proj, e))
    })
    
    return(clinical.data)
}

# create csv's for every clinical info type
DownloadClinicalTCGA <- function(dir = ".") {
  # get clinical data for every tcga project
  clinical.dfs <- getGDCprojects()$project_id %>% 
    # only tcga projects
    str_subset("TCGA") %>%
    map(GetClinical) %>%
    
    # reduce list of list of clinical data dataframes by project to 
    # named list of clinical data dataframes by clinical info type 
    reduce(function(data.by.type, project.data) {
      for (info.type in names(project.data)) {
        data.by.type[info.type] <- append(data.by.type[info.type], project.data[info.type])
      }
      return(data.by.type)
    }, .init = c()) %>%
    
    # combine the clinical info type dataframes
    map(bind_rows)
  
  # create csv's
  for (df.name in names(clinical.dfs)) {
    write_csv(clincal.dfs[df.name], file.path(dir, paste0(df.name, ".csv")))
  }
}
