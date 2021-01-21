shinyUI(dashboardPage(
    skin = "yellow",
    dashboardHeader(title = "Taxonomy Dashboard for Pilot Data"),
    dashboardSidebar(
        sidebarMenu(id = "sidebar",
            uiOutput("project_id"),
            menuItem(
                "Individual Samples",
                tabName = "individual_sample",
                icon = icon("vial")
            ),
            conditionalPanel(
                condition = "input.sidebar == 'individual_sample'",
                uiOutput("select_file"),
                selectizeInput(
                    "taxonomic_level",
                    "Taxonomy Classification",
                    choices = taxonomic_levels,
                    selected = taxonomic_levels[5]
                )),
            menuItem(
                "Compare Samples",
                tabName = "compare_samples",
                icon = icon("vials")),
            conditionalPanel(
                condition = "input.sidebar == 'compare_samples'",
                selectizeInput(
                    "taxonomic_level_comparison",
                    "Taxonomy Classification",
                    choices = taxonomic_levels,
                    selected = taxonomic_levels[6]
                ), 
                uiOutput("select_factor"), 
                uiOutput("select_color"), 
                uiOutput("select_shape")
            ),
            menuItem("Global View", tabName = "global_view", icon = icon("globe")),
            conditionalPanel(
                condition = "input.sidebar == 'global_view'",
                selectizeInput(
                    "taxonomic_level_global",
                    "Taxonomy Classification",
                    choices = taxonomic_levels,
                    selected = taxonomic_levels[6]
                ), 
                uiOutput("select_factor_global"), 
                uiOutput("select_color_global"), 
                uiOutput("select_shape_global")
                )
        )
    ),
    
    dashboardBody(tabItems(
        tabItem(tabName = "individual_sample",
                fluidRow(
                    column(width = 5, DT::dataTableOutput("metadata_table") %>% withSpinner(color="#efcc00")),
                    column(width = 4, plotOutput("overview_taxonomy") %>% withSpinner(color="#efcc00"))
                ),
                fluidRow(column(
                    width = 12, align = "center" ,plotlyOutput("inDepth_taxonomy") %>% withSpinner(color="#efcc00")
                ))),
        tabItem(tabName = "compare_samples",
                fluidRow(column(
                    width = 12, DT::dataTableOutput("metadata_table_full")  %>% withSpinner(color="#efcc00")
                    )),
                fluidRow(column(
                    width = 12, align="center", plotlyOutput("heatmap_taxonomy_comparison") %>% withSpinner(color="#efcc00")
                )),
                fluidRow(column(
                    width = 12, align = "center", plotlyOutput("cca_taxonomy_comparison") %>% withSpinner(color="#efcc00")
                ))
                ),
        tabItem(tabName = "global_view",
                tabItem(tabName = "global_view",
                        fluidRow(column(
                            width = 12, align="center", plotlyOutput("heatmap_taxonomy_global") %>% withSpinner(color="#efcc00")
                        )),
                        fluidRow(column(
                            width = 12, align = "center", plotlyOutput("cca_taxonomy_global") %>% withSpinner(color="#efcc00")
                        ))
                )
        )
    ))))
                
