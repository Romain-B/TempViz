library(shiny)
library(shinyTime)
library(shinyjqui)

# Define UI for data upload app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("TempViz - plot incubator temperature over time"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select a file ----
      fileInput("file1", "Select your input file",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # Horizontal line ----
      tags$hr(),
      
      # plot options appear only after a file has been loaded
      uiOutput("plot_options"),
      
      # Horizontal line ----
      tags$hr()
    ),
    
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Data file ----
      jqui_resizable(plotOutput("temp_plot"))
      
    )
    
  )
)
