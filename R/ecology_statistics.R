complete_bray_curtis_workflow <- function(df, metadata){
  matrix_metadata <- create_site_by_species_matrix(df, metadata)
  bray_dm <- bray_curtis_diversity(matrix_metadata$matrix)
  return(list("bray_dm" = bray_dm, "metadata" = matrix_metadata$metadata))
}

amp_vis_workflow <- function(dataframe_filtered, metadata, taxonomy){
  dataframe_reshaped <- transform_dataframe(dataframe_filtered, taxonomy)
  amp_data<- amp_load(dataframe_reshaped, metadata)
  return(amp_data)
}


amp_vis_heatmap <- function(amp_data, factor, taxonomy){
  amp_vis_heatmap <- amp_heatmap(amp_data, group_by = factor, tax_aggregate = taxonomy)
  amp_vis_heatmap <- ggplotly(amp_vis_heatmap) %>%
    layout(plot_bgcolor='rgba(0,0,0,0)') %>%
    layout(paper_bgcolor='rgba(0,0,0,0')
  return(amp_vis_heatmap)
}

amp_vis_ordinate_cca <- function(amp_data, color_by, shape_by, factor_by){
  cca_amp_vis <- ggplotly(amp_ordinate(
    amp_data, type='CCA', transform= 'Hellinger', opacity = 0.4, 
    sample_point_size = 4, constrain=factor_by, sample_color_by = color_by, 
    sample_shape_by = shape_by)) %>%
    layout(plot_bgcolor='rgba(0,0,0,0)') %>%
    layout(paper_bgcolor='rgba(0,0,0,0')
  return(cca_amp_vis)
  
}

amp_vis_ordinate_pcoa <- function(amp_data, factor_by, color_by){
  amp_ordinate(amp_data, type='pcoa', distmeasure ='bray', constrain=factor_by, sample_color_by = color_by)
  
}



