# Select Factor Dropdown
output$select_factor_global <- renderUI({
  if (is.null(input$project_id_selected)) return()
  shiny::selectizeInput(
    inputId="selected_factor_global", label="Select Factor", 
    choices=colnames(metadata_file()), selected =colnames(metadata_file())[1]) 
})

# Select Color Dropdown
output$select_color_global <- renderUI({
  if (is.null(input$project_id_selected)) return()
  shiny::selectizeInput(
    inputId="selected_color_global", label="Select 2nd Factor (Color)", 
    choices=colnames(metadata_file()), selected =colnames(metadata_file())[1]) 
})

# Select Shape Dropdown
output$select_shape_global <- renderUI({
  if (is.null(input$project_id_selected)) return()
  shiny::selectizeInput(
    inputId="selected_shape_global", label="Select 3rdFactor (Shape)", 
    choices=colnames(metadata_file()), selected =colnames(metadata_file())[1]) 
})

metadata_file <- reactive({
  metadata_file = readxl::read_excel(paste0(projects,input$project_id_selected, metadata_dir, metadata_file_name))
})

# Full Taxonomy All Samples 
combined_file <- reactive({
  combined_file_path = paste0(projects, input$project_id_selected, combined_kraken_dir, input$project_id_selected, ".csv")
  if (!file.exists(combined_file_path)){
    combined_file = combine_dataframes(paste0(projects, input$project_id_selected, individual_kraken_dir), input$project_id_selected)
  }
  else{
    combined_file = readr::read_csv(combined_file_path)
  }

})

amp_vis_load <- reactive({
  amp_vis_load = amp_vis_workflow(
    combined_file(), metadata_file(), input$taxonomic_level_global)
})


# Heatmap of Samples with Taxonomy 
output$heatmap_taxonomy_global <-renderPlotly({
  if (is.null(combined_file())) return()
  amp_vis_heatmap(
    amp_vis_load(), input$selected_factor_global, input$taxonomic_level_global)
  
})

# CCA of Samples with Taxonomy 
output$cca_taxonomy_global <-renderPlotly({
  if (is.null(combined_file())) return()
  amp_vis_ordinate_cca(
    amp_vis_load(), input$selected_color_global, input$selected_shape_global, input$selected_factor_global)

  
})
