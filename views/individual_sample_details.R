# Taxonomy File 
individual_taxonomy_file <- reactive({
  if (is.null(input$selected_kraken_file)) return()
  file_path = paste0(projects, input$project_id_selected, individual_kraken_dir, input$selected_kraken_file)
  domain_subsets_df(file_path)
})


# MetaData File
output$metadata_table <- DT::renderDataTable({
  if (is.null(input$selected_kraken_file)) return()
  metadata_file = readxl::read_excel(paste0(projects,input$project_id_selected, metadata_dir, metadata_file_name))
  library_number = unlist(strsplit(input$selected_kraken_file, "\\."))[[1]]
  metadata <- metadata_file %>%
    filter(sample_id ==  library_number)
  t(metadata)
  
}, selection = 'single')

# Pie Chart 
output$overview_taxonomy <- renderPlot({
  if (is.null(input$selected_kraken_file)) return()
  df_file = pie_chart_formatted_taxonomy(individual_taxonomy_file())
  ggplot(df_file, 
         aes(x="", y=`Percentage of Reads`, fill=`Scientific Name`)) + 
    geom_bar(width=1, stat="identity") + 
    coord_polar("y") + 
    theme_void() + 
    geom_text(aes(label = paste0(round(`Percentage of Reads`, 1), "%")), 
              position = position_stack(vjust = 0.5)) + 
    scale_fill_manual(name = "Domains", values = df_file$color, limits = df_file$`Scientific Name`) 
  }, bg="transparent")

# Bar Plot
output$inDepth_taxonomy <- renderPlotly({
  if (is.null(input$selected_kraken_file)) return()
  df_file = taxonomic_abundance_filtered(individual_taxonomy_file(), input$taxonomic_level)
  color_list <- colorRampPalette(
    wes_palette(n = 5, name = "Moonrise3"))(length(df_file$`Scientific Name`))
  plot <- ggplotly(ggplot(
    df_file,
    aes(x=`Domain`, y=`Percentage of Reads`, fill = `Scientific Name`)) +
    geom_bar(width=1, stat="identity", position="stack") +
    scale_fill_manual(values = color_list) + 
    facet_grid(~`Domain`, scales='free') +
    theme(legend.position = 'none') + 
    theme_void()) %>%
    layout(xaxis = list(showgrid=F), yaxis = list(showgrid=F)) %>%
    layout(plot_bgcolor='rgba(0,0,0,0)') %>%
    layout(paper_bgcolor='rgba(0,0,0,0')
  hide_legend(plot)
})


