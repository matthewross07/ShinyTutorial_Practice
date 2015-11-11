
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage( fluidRow(
  
  # Application title
  titlePanel("Calculate Q from a Salt Slug"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose .csv File',
                accept=c('.csv')),
      uiOutput("chooseX"),
      numericInput("int",
                   "Sampling Interval (in seconds)",
                   value=2),
      #fileInput(inputId = "Salt Slug File", label="upload file"),
      sliderInput("cf",
                  "Corrective Factor (to convert SC to g NaCL)",
                  min = .45,
                  max = .55,
                  value = .5,
                  step=.01
      ),
      numericInput("mass",
                   "Mass of salt slug (in grams)",
                   value=500),
    
      uiOutput("chooseY")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      #tableOutput("contents"),
      column(12,
             plotOutput("subset")),
      column(12,
             plotOutput("series", height = 150,
                        brush = brushOpts(
                          id = "series_brush",
                          resetOnNew = TRUE))
             ),
      column(12, textOutput("results"))
      )
  
  ))))

