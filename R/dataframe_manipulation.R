# Dataframe filtered with U(nclassified) and D(omain) as 
# Columns https://genomics.sschmeier.com/ngs-taxonomic-investigation/index.html#investigate-taxa

# Adding Biologial Classifications to the dataframe
domain_subsets_df <- function(df_file){
  df_file = readr::read_delim(df_file, delim="\t", 
                              col_names= kraken_headers)
  df_file[,1] <-  sapply(df_file[,1],as.numeric)
  df_file <- df_file %>%
    mutate(`Scientific Name` = gsub(" ", "", `Scientific Name`)) 
  empty_list_tax <- list(NULL, NULL, NULL, NULL, NULL, NULL, NULL)
  
  for (row in 1:nrow(df_file)){
    for (i in 1:length(tax_list)){
      if (df_file[row, "Rank Code"] == substr(tax_list[[i]], 1, 1)){
          empty_list_tax[[i]] <- df_file[[row,"Scientific Name"]]
          if (substr(tax_list[[i]], 1, 1) == "D"){
            empty_list_tax[2:7] <- list(NULL)
          }
          if (substr(tax_list[[i]], 1, 1) == "K"){
            empty_list_tax[3:7] <- list(NULL)
          }
          if (substr(tax_list[[i]], 1, 1) == "P"){
            empty_list_tax[4:7] <- list(NULL)
          }
          if (substr(tax_list[[i]], 1, 1) == "C"){
            empty_list_tax[5:7] <- list(NULL)
          }
          
          if (substr(tax_list[[i]], 1, 1) == "O"){
            empty_list_tax[6:7] <- list(NULL)
          }
          if (substr(tax_list[[i]], 1, 1) == "F"){
            empty_list_tax[7] <- list(NULL)
          }
          df_file[[row, tax_list[[i]]]] <- empty_list_tax[[i]] 
          
      }
        else if (!is.null(empty_list_tax[[i]])) {
          df_file[[row, tax_list[[i]]]] <- empty_list_tax[[i]] 
        }
    }
  }
  df_file <- df_file %>%
    filter(`Percentage of Reads` > 0)
    
  return(df_file)
}

pie_chart_formatted_taxonomy <- function(df_file){
  overview_filtered <- df_file %>%
    filter(`Rank Code` == "U" | `Rank Code` == "D") %>%
    filter(`Percentage of Reads` > 0.1) %>%
    left_join(taxonomy_overview_colors, by = c("Scientific Name" = "taxon")) %>%
    droplevels()
  return(overview_filtered)
}


taxonomic_abundance_filtered <- function(df_file, taxonomic_level){
  taxonomy = substr(taxonomic_level, 1, 1)
  df_file <- df_file %>%
    filter(`Rank Code` == taxonomy) 
  return(df_file)
}


combine_dataframes<- function(directory, project_id){
  kraken_files = list.files(path = directory, pattern=".tsv$")
  for (i in 1:length(kraken_files)){
    if (i == 1){
      combined <- domain_subsets_df(paste0(directory, kraken_files[i]))
      combined <- combined %>%
        mutate(Sample_Id = unlist(strsplit(kraken_files[i], "\\."))[[1]])
    }
    else{
      next_df <- domain_subsets_df(paste0(directory, kraken_files[i]))
      next_df <- next_df %>% 
        mutate(Sample_Id = unlist(strsplit(kraken_files[i], "\\."))[[1]])
      combined = bind_rows(combined, next_df)
    }
  }

  write.csv(combined, file = paste0(
    projects, project_id, combined_kraken_dir, project_id, '.csv'), row.names= FALSE)
  return(combined)
}

filter_dataframe_by_sample <- function(combined_dataframe, sample_list){
  combined_dataframe <- combined_dataframe %>%
    filter(`Sample_Id` %in% sample_list) 
  return(combined_dataframe)
}
  
transform_dataframe <- function(combined_dataframe, taxonomic_level){
  taxonomy = substr(taxonomic_level, 1, 1)
  if (taxonomy == "G"){
    combined_dataframe <- combined_dataframe %>%
      filter(`Rank Code` == taxonomy) 
    combined_reshaped <- reshape2::dcast(
      combined_dataframe, Domain + Phylum + Class + Order + Family + Genus ~ Sample_Id, value.var = "Percentage of Reads" ,
      fun.aggregate=mean)
    combined_reshaped = relocate(combined_reshaped, 'Domain', 'Phylum', 'Class', 'Order', "Family", "Genus", .after=last_col())
    combined_reshaped[['Species']] <- 'NA'
  }
  else if(taxonomy == "F"){
    combined_dataframe <- combined_dataframe %>%
      filter(`Rank Code` == taxonomy) 
    combined_reshaped <- reshape2::dcast(
      combined_dataframe, Domain + Phylum + Class + Order + Family  ~ Sample_Id, value.var = "Percentage of Reads" ,
      fun.aggregate=mean)
    combined_reshaped = relocate(combined_reshaped, 'Domain', 'Phylum', 'Class', 'Order', "Family", .after=last_col())
    combined_reshaped[['Genus']] <- 'NA'
    combined_reshaped[['Species']] <- 'NA'
  }
  else if (taxonomy == "O"){
    combined_dataframe <- combined_dataframe %>%
      filter(`Rank Code` == taxonomy) 
    combined_reshaped <- reshape2::dcast(
      combined_dataframe, Domain + Phylum + Class + Order  ~ Sample_Id, value.var = "Percentage of Reads" ,
      fun.aggregate=mean)
    combined_reshaped = relocate(combined_reshaped, 'Domain', 'Phylum', 'Class', 'Order', .after=last_col())
    combined_reshaped[['Family']] <- 'NA'
    combined_reshaped[['Genus']] <- 'NA'
    combined_reshaped[['Species']] <- 'NA'
  }
  else if (taxonomy == "C"){
    combined_dataframe <- combined_dataframe %>%
      filter(`Rank Code` == taxonomy) 
  combined_reshaped <- reshape2::dcast(
    combined_dataframe, Domain + Phylum + Class  ~ Sample_Id, value.var = "Percentage of Reads" ,
    fun.aggregate=mean)
  combined_reshaped = relocate(combined_reshaped, 'Domain', 'Phylum', 'Class', .after=last_col())
  combined_reshaped[['Order']] <- 'NA'
  combined_reshaped[['Family']] <- 'NA'
  combined_reshaped[['Genus']] <- 'NA'
  combined_reshaped[['Species']] <- 'NA'
  }
  else if (taxonomy == "P"){
    combined_dataframe <- combined_dataframe %>%
      filter(`Rank Code` == taxonomy) 
    combined_reshaped <- reshape2::dcast(
      combined_dataframe, Domain + Phylum ~ Sample_Id, value.var = "Percentage of Reads" ,
      fun.aggregate=mean)
    combined_reshaped = relocate(combined_reshaped, 'Domain', 'Phylum', .after=last_col())
    combined_reshaped[['Class']] <- 'NA'
    combined_reshaped[['Order']] <- 'NA'
    combined_reshaped[['Family']] <- 'NA'
    combined_reshaped[['Genus']] <- 'NA'
    combined_reshaped[['Species']] <- 'NA'
  }
  combined_reshaped <- plyr::rename(combined_reshaped, c("Domain" = "Kingdom"))
  combined_reshaped[is.na(combined_reshaped)] <- 0
  combined_reshaped[['OTU']] <- 0
  for (row in 1:nrow(combined_reshaped)){
    combined_reshaped[row, "OTU"] <- paste0("OTU","_", row)
  }
  combined_reshaped <- combined_reshaped %>% 
    column_to_rownames(var = "OTU")
  return(combined_reshaped)
  
}

convert_metadata <- function(metadata, combined_dataframe){
  metadata <- metadata %>% 
    filter(sample_id %in% colnames(combined_dataframe)) %>%
  return(metadata)
}
