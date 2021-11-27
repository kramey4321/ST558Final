#ST558 Kristi Ramey - FINAL!!! :)

library(shiny)
library(tidyverse)
library(DT)
data("train.csv")
house <- read_csv("train.csv")

# Define server logic to plot a histogram, scatterplot, and summary
shinyServer(function(input, output, session) {
    
   # output$summaryDset <- renderPrint({
        #summary(house[[input$var]])
    #})
    
    output$distPlot <- renderPlot({
        var <- input$var
        ggplot(data = house) +
        geom_histogram(aes_string(x = input$var), color = 'black', fill = 'blue')
    })
    
   # output$distPlotmodel <- renderPlot({
        #var <- input$var
       # ggplot(data = house, aes(x = YrSold, y = SalePrice)) +
         #   geom_point()
        
  #  })
    
    
})

