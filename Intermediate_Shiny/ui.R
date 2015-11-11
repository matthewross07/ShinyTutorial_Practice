

library(dygraphs)

shinyUI(fluidPage(
  
  #titlePanel("Interactive Data"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("password", "Please Enter the Password (Case Sensitive)", value = ""),
      textOutput("feedback"), br(),br(),
      conditionalPanel("output.feedback=='Password is correct'",
      fileInput(inputId = "data", label="upload RData", accept=c('.RData')),
      #selectInput("choosex", "Choose X", choices = names(mega.merge)),
      selectInput("choosey", "Choose Y (up to 2)", choices = names(mega.merge), multiple = T),
      checkboxInput("axisNumber", "Plot with 2 Axes", value = F),
      helpText("Click and drag to zoom in (double click to zoom back out).")
    )),
    mainPanel(
      textOutput("test"),
      dygraphOutput("dygraph")
    )
  )
))
