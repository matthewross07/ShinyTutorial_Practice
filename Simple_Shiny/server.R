
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#


library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  data <- reactive({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(read.csv("HB_2-7.10.2015NEW.csv"))
    
    read.csv(inFile$datapath)
  })
  
  formatX<- reactive({ 
    d<- data()
    d$Mins<- seq(0,input$int*nrow(data())-1,by=input$int)/60
    return(d)
    })
  
  output$contents<- renderTable({head(formatX())})
  
  output$chooseX<- renderUI({
    selectInput(inputId = "xaxis", label="Select X Axis", choices=names(formatX()), selected="Mins")
  })  

  bounds <- reactiveValues(x = NULL, y = NULL)
  
  output$chooseY<- renderUI({
    selectInput(inputId = "yaxis", label="Select Y Axis", choices=names(formatX()), selected="SC")
  })
  
  output$subset <- renderPlot({
    ggplot(formatX(), aes_string('Mins', input$yaxis)) +
      geom_line() +
      coord_cartesian(xlim = bounds$x, ylim = bounds$y)
  })
  
  output$series <- renderPlot({
    ggplot(formatX(), aes_string('Mins', input$yaxis)) +
      geom_point()
  })
  
  subsetX<- reactive({ 
    d<- formatX()
    d <- d[d$Mins < bounds$x,]
    return(d)
  })
  
  observe({
    brush <- input$series_brush
    
    if (!is.null(brush)) {
      bounds$x <- c(brush$xmin, brush$xmax)
      bounds$y <- c(brush$ymin, brush$ymax)
      
    } else {
      bounds$x <- NULL
      bounds$y <- NULL
    }
  })
  
  output$results<- renderText({
    d <-subsetX()
    mass.dat <- input$mass
    cf <- input$cf
    int <- input$int
    start.ec <- mean(head(d$SC))
    end.ec <- mean(tail(d$SC))
    d$zero.sc <- d$SC - seq(start.ec,end.ec,length.out=nrow(d))
    d[which(d$zero.sc <= 0),'zero.sc'] <- 0
    Q <- round(mass.dat/sum(d$zero.sc*cf*int)*1000,3)#lps
    print(paste("Discharge is",Q,'Liters/Second'))
  }
  )
  
})
