#ST558 Kristi Ramey - FINAL!!! :)

library(shiny)
library(tidyverse)
library(DT)
data("train.csv")
house <- read_csv("train.csv")
#subset data to interesting variables
housesub <- house %>% select(LotArea, OverallQual, OverallCond, YearBuilt, GrLivArea, 
                 BedroomAbvGr, TotRmsAbvGrd, SalePrice)

# Define server logic to plot a histogram, scatterplot, and summary
shinyServer(function(input, output, session) {

    
    output$summaryDset <- renderPrint({
        summary(house[[input$var]])
    })
    
    output$distPlot <- renderPlot({
        var <- input$var
        ggplot(data = house) + 
        geom_histogram(aes_string(x = var), color = 'black', fill = 'blue')
    })
  
    output$scatterPlotmodel <- renderPlot({
        var <- input$var
        price <- house$SalePrice
        ggplot(data = house, aes(x = !!sym(var), y = SalePrice)) +
            geom_point()

        
    })
    # Server stuff for Modeling:

   # f <- reactive({
       #as.formula(paste(SalePrice ~ , data = house))
    #})

    
    
    output$Model <- renderPrint({
        GeneralLinearModel <- glm(SalePrice ~ LotArea + OverallCond, data = house)
        summary(GeneralLinearModel)
        })
    
})
    #output$Model_new <-
       # renderPrint(
            #stargazer(
                #lm(),
                #type = "text",
               # title = "Model Results",
               # digits = 1,
                #out = "table1.txt"
            #)
        #)
#)

