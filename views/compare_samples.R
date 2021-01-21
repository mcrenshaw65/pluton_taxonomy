# Select Factor Dropdown
output$select_factor <- renderUI({
  if (is.null(input$project_id_selected)) return()
  shiny::selectizeInput(
    inputId="selected_factor", label="Select Factor", 
    choices=colnames(metadata_file()), selected =colnames(metadata_file())[1]) 
})

# Select Color Dropdown
output$select_color <- renderUI({
  if (is.null(input$project_id_selected)) return()
  shiny::selectizeInput(
    inputId="selected_color", label="Select 2nd Factor (Color)", 
    choices=colnames(metadata_file()), selected =colnames(metadata_file())[1]) 
})

# Select Shape Dropdown
output$select_shape <- renderUI({
  if (is.null(input$project_id_selected)) return()
  shiny::selectizeInput(
    inputId="selected_shape", label="Select 3rdFactor (Shape)", 
    choices=colnames(metadata_file()), selected =colnames(metadata_file())[1]) 
})

# Metadata File
metadata_file <- reactive({
  metadata_file = readxl::read_excel(paste0(projects,input$project_id_selected, metadata_dir, metadata_file_name))
})

# Reactives used for the graphs
combined_file_filtered_samples <- reactiveValues(
  df = NULL, heatmap = NULL, cca_ordinate = NULL)

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

# Metadata that will be selected to use for comaparing samples
output$metadata_table_full <- DT::renderDataTable({
  metadata_file()
}, selection = list(mode = 'multiple'))


# Heatmap of Samples with Taxonomy 
output$heatmap_taxonomy_comparison <-renderPlotly({
  if (is.null(input$metadata_table_full_rows_selected)) return()
  combined_file_filtered_samples$heatmap
  
})

# CCA of Samples with Taxonomy 
output$cca_taxonomy_comparison <-renderPlotly({
  if (is.null(input$metadata_table_full_rows_selected)) return()
    combined_file_filtered_samples$cca_ordinate
  
})


# select rows and build visuzliations based on that 
observeEvent(
  input$metadata_table_full_rows_selected, {
    selected <- input$metadata_table_full_rows_selected
    metadata_filtered <- metadata_file()[selected,]
    sample_list <- pull(metadata_filtered, sample_id)
    combined_file_filtered_samples$df <- filter_dataframe_by_sample(combined_file(), sample_list)
    amp_vis_load <- amp_vis_workflow(
      combined_file_filtered_samples$df, 
      metadata_filtered, input$taxonomic_level_comparison)
    combined_file_filtered_samples$heatmap <- amp_vis_heatmap(
      amp_vis_load, input$selected_factor, input$taxonomic_level_comparison)
    if (length(input$metadata_table_full_rows_selected) > 3){
      if(length(unique(as.factor(pull(metadata_filtered[input$selected_factor])))) >= 2){
        combined_file_filtered_samples$cca_ordinate <- amp_vis_ordinate_cca(amp_vis_load, input$selected_color, input$selected_shape, input$selected_factor)
      }
      else{
        notification <- showNotification(paste("Need 3 factors to display the CCA graph"), type="message", duration = 10)

      }
    }
    })



