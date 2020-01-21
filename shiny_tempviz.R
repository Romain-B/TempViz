library(shiny)
library(shinyTime)

load_df <- function(filename){
  tryCatch(
    {
      df <- read.csv(filename,
                     header = T, sep = ";", 
                     skip = 3, as.is = T)
    },
    error = function(e) {
      # return a safeError if a parsing error occurs
      stop(safeError(e))
    }
  )
  df$date <- as.POSIXct(df$date, format = "%Y.%m.%d %H:%M")
  return(df)
}

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
      
      uiOutput("plot_options"),
      # Input: select datetime from,
      
      # Input: Select separator ----
      # radioButtons("sep", "Separator",
      #              choices = c(Comma = ",",
      #                          Semicolon = ";",
      #                          Tab = "\t"),
      #              selected = ","),
      
      # Input: Select quotes ----
      # radioButtons("quote", "Quote",
      #              choices = c(None = "",
      #                          "Double Quote" = '"',
      #                          "Single Quote" = "'"),
      #              selected = '"'),
      
      # Horizontal line ----
      tags$hr()
    ),

    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Data file ----
      # tableOutput("contents"),
      plotOutput("temp_plot")
      
    )
    
  )
)

# Define server logic to read selected file ----
server <- function(input, output) {
  
  # output$contents <- renderTable({
  #   
  #   # input$file1 will be NULL initially. After the user selects
  #   # and uploads a file, head of that data file by default,
  #   # or all rows if selected, will be shown.
  #   
  #   req(input$file1)
  #   
  #   # when reading semicolon separated files,
  #   # having a comma separator causes `read.csv` to error
  #   load_df(input$file1$datapath)
  #   
  #   return(df)
  #   
  #   
  # })
  

  
  output$plot_options <- renderUI({
    req(input$file1)
    
    suppressWarnings(df <- load_df(input$file1$datapath))
    
    
    init_vals <- list(datfrom = min(df$date),
                      datto = max(df$date),
                      ylim = range(df$temp.)
                      )
    
    tagList(
    fluidRow(
      column(6,dateInput("date_from", label = "from", value = init_vals$datfrom)),
      column(6,timeInput("time_from", "H:M", value = init_vals$datfrom, minute.steps = 10))
    ),
    
    fluidRow(
      # Input: select datetime to
      column(6,dateInput("date_to", label = "to", value = init_vals$datto)),
      column(6,timeInput("time_to", "H:M", value = init_vals$datto, minute.steps = 10))
    ),
    
    
    
    # Horizontal line ----
    tags$hr(),
    
    fluidRow(
      # Input: set temperature and confidence range
      column(6,numericInput("set_temp", "Set temp. (°C)", 20)),
      column(6,numericInput("conf_int", "Conf. interval (°C)", .1))
    ),
    
    # Horizontal line ----
    tags$hr(),
    sliderInput("ylims", label = "Slider Range", min = 0, 
                max = 50, value = init_vals$ylim*c(.9, 1.1)),
    
    # Horizontal line ----
    tags$hr(),
    tags$h3("Save plot"),
    textInput("plot_name", "Plot name", value = paste0(Sys.Date(),".png")),
    downloadButton("save_plot", "Save plot")
    )
  })
  
  plotInput <- reactive({
    req(input$file1)
    suppressWarnings(df <- load_df(input$file1$datapath))
    
    
    tit <- gsub("\\d+-\\d+-\\d+_(\\w+_\\w+)_DataRecord.csv", "\\1", input$file1$name)
    if(nchar(tit)<1){
      tit <- input$plot_name
    }
    datefrom <- paste(strftime(input$date_from, format = "%Y-%m-%d"), 
                      strftime(input$time_from, format = "%H:%M:%S"))
    dateto <- paste(strftime(input$date_to, format = "%Y-%m-%d"), 
                    strftime(input$time_to, format = "%H:%M:%S"))
    
    df <- df[df$date > as.POSIXct(datefrom) & df$date < as.POSIXct(dateto), ]
    df$status <- factor(df$status, levels = c(" set temp.", " wait"," ramp"), labels = c("set temp.", "wait", "ramp"))
    
    p <- ggplot(df, aes(x = date, y = temp., col = status)) + 
      geom_point() + geom_line() + ggtitle(tit) +
      geom_hline(yintercept = input$set_temp, col = "firebrick", linetype = "dashed", size = 1) +
      geom_hline(yintercept = input$set_temp + c(-1, 1)*input$conf_int, 
                 col = "royalblue", linetype = "dotted", size = 1) +
      coord_cartesian(ylim = input$ylims)
    
  })
  
  output$temp_plot <- renderPlot({
    print(plotInput())
  })
  
  output$save_plot <- downloadHandler(
    filename = input$plot_name,
    content = function(file) {
      device <- function(..., width, height) {
        grDevices::png(..., width = width, height = height,
                       res = 300, units = "in")
      }
      ggsave(file, plot = plotInput(), device = device)
    })
  
}

# Create Shiny app ----
shinyApp(ui, server)

