library(shiny)
library(shinydashboard)
library(shinythemes)
library(tidyverse)
library(plotly)
library(ggplot2)
library(RColorBrewer)
library(stringr)
library(DT)
library(readxl)
library(reshape2)
library(vegan)
library(wesanderson)
library(ampvis2)
library(plyr)
library(shinycssloaders)

#install.packages("remotes")
#remotes::install_github("MadsAlbertsen/ampvis2")

projects = "/Volumes/One Touch/Pluton_Biosciences/Comp_Bio/Shiny_App_Taxonomy/taxonomy/data/Projects/"
project_list = list.files(path = projects)

combined_kraken_dir = "/Combined_Kraken_File/"
individual_kraken_dir = "/Individual_Kraken_Files/"
metadata_dir = "/Metadata/"
metadata_file_name = "run_metadata.xlsx"

kraken_headers = c('Percentage of Reads', 
                   'Number of Reads Covered By Clade', 
                   'Number of Reads Assigned To Taxon',
                   'Rank Code',
                   'NCBI Taxonomy ID',
                   'Scientific Name')
taxonomic_levels = c('Kingdom', 'Phylum', 'Class', 'Order', 'Family', 'Genus')
tax_list = list(Domain = "Domain",
  Kingdom = "Kingdom", Phylum = "Phylum", 
  Class = "Class", Order = "Order", Family= "Family", Genus="Genus")
set1_colors = brewer.pal(n = 8, name = "Set1")
taxonomy_overview_colors <- tibble(
  taxon = c("unclassified", "Bacteria", "Eukaryota", "Archaea", "Viruses"),
  color = c(set1_colors[1], set1_colors[2], set1_colors[3], set1_colors[4], set1_colors[5])
)


source("R/dataframe_manipulation.R")
source("R/ecology_statistics.R")


