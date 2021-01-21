output$project_id <- renderUI({
  shiny::selectizeInput(
    inputId="project_id_selected", 
    label="Project ID", choices = project_list, selected=project_list[1])
})

output$select_file <- renderUI({
  if (is.null(input$project_id_selected)) return()
  kraken_dir = paste0(projects,input$project_id_selected, "/Individual_Kraken_Files/")
  kraken_files = list.files(path = kraken_dir)
  shiny::selectizeInput(
    inputId="selected_kraken_file", label="Select Kraken File", choices=kraken_files)
})


