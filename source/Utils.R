save_results <- function(results, settings){
  
  suppressMessages(suppressWarnings(library(rdflib)))
  suppressMessages(suppressWarnings(library(jsonlite)))
  
  # Write the RDF file
  write_rdf(object = results$results_rdf,
            file = paste(settings$OutputDataDirectory,
                         sprintf("%s.ttl", digest::digest(
                           results$key,
                           algo = "sha256", serialize = T)), sep="/"))
  
  # Write the JSON files (time series)
  for(i in 1:length(results$results_ts)){
    write(jsonlite::toJSON(
      setNames(list(results$results_ts[[i]]$basic),names(results$results_ts)[i]),
      dataframe = "rows",na = "null"),
      file=paste(settings$OutputDataDirectory,
                 sprintf("%s.json",names(results$results_ts)[i]),
                 sep="/") )
  }
}

run_EEMs_assessment <- function(buildingsRdf, timeseriesObject, settings){
  library(biggr)
  allBuildingSubjects <- get_all_buildings_list(buildingsRdf)
  for (buildingSubject in allBuildingSubjects){
    tryCatch(
      {
        building_results <- EEMs_assessment(buildingSubject, buildingsRdf, timeseriesObject, settings,
                                            libraryPath = "")
        building_results$key <- buildingSubject
        save_results(building_results, settings)
      }, 
      error=function(e){NULL}
    )
  }
}