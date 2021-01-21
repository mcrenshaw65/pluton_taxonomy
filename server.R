shinyServer(function(input, output, session){
  options(shiny.trace = TRUE)
  source("views/individual_sample_details.R", local = T)
  source("views/global_view_details.R", local = T)
  source("views/compare_samples.R",local=T)
  source("views/selected_files_by_project.R", local=T)
})