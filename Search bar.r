library(shiny)
library(DT)
library(shinydashboard)


# put on line 49? 
#find icon

shinyUI(dashboardPage(
  skin = "yellow",
  dashboardHeader(title = "Taxonomy Dashboard for Pilot Data"),
  dashboardSidebar(
    sidebarSearchForum(textID=searchbar, buttonId=search_button, label="Search Table"),
    uiOutput("word_search")
  )
))



  #make not case sensitive
  #search words out of order
  #use search() instead?
# want to isolate(), so only searches when button pressed
  #autofill
  #change length menu pageLength()
  #start line 82
  
server<-fuction(input, output) {
  output$word_search<-renderDataTable(options=taxonomic_levels)
  tabItems(
    tabItem(tabName = "",
            fluidRow(
              column(width = 5, DT::dataTableOutput("metadata_table") %>% withSpinner(color="#efcc00")),
              column(width = 4) %>% withSpinner(color="#efcc00"))
            ),
            fluidRow(column(
              width = 12, align = "center") %>% withSpinner(color="#efcc00")

}       



shinyApp(server, ui=shinyUI)

###