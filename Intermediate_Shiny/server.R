library(dygraphs)
library(datasets)
library(xts)
library(lubridate)

load("MegaWideOct2015.RData") 
mega.merge <- z


shinyServer(function(input, output) {

  output$feedback<- reactive({
    validate( need(input$password, "Enter the password"))
    if (input$password=="water"){answer<-"Password is correct"}
    else{answer<-"Password is incorrect"}
    return(answer)
    }) 
  
  data <- reactive({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(load("MegaWideOct2015.RData"))
    
    load(inFile$datapath)
  })
  
  subset<- reactive({
    if (!is.null(data())){
    getVars<- c(input$choosex, input$choosey)
    vars<-mega.merge[getVars]
    plot<- xts(vars, order.by=mega.merge$min10)
    return(plot)}
  })
  
  output$dygraph<- renderDygraph({
    if (input$axisNumber==F){
      dygraph(subset(), main = paste("min10","vs.", input$choosey)) %>%
        dyOptions(drawPoints=T,strokeWidth=.5,pointSize=1.5,stepPlot=F) %>%
        dyAxis("x", label=paste(input$choosex))%>%
        dyAxis("y", label=paste(input$choosey[1]))%>%
        dyRangeSelector()
    }
    else{
      dygraph(subset(), main = paste(input$choosex,"vs.", input$choosey)) %>%
        dyOptions(drawPoints=T,strokeWidth=.5,pointSize=1.5,stepPlot=F) %>%
        dySeries(subset()$vars[,2], axis='y2')%>%
        dyAxis("x", label=paste(input$choosex))%>%
        dyAxis("y", label=paste(input$choosey[1]))%>%
        dyAxis("y2", label=paste(input$choosey[2]))%>%
        dyRangeSelector()
    }
  })

 })