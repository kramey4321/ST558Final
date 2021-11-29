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

    #Filtering the data based on price range
    housesubED <- reactive({
        housesub %>% filter((SalePrice >= input$priceED[2]) & 
                                          (SalePrice <= input$priceED[1]))
    
    
    output$summaryDset <- renderPrint({
        summary(housesubED[[input$var]])
    })
    
    output$distPlot <- renderPlot({
        var <- input$var
        ggplot(data = housesubED) + 
        geom_histogram(aes_string(x = var), color = 'black', fill = 'blue')
    })
  
    output$scatterPlotmodel <- renderPlot({
        var <- input$var
        price <- housesubED$SalePrice
        ggplot(data = housesubED, aes(x = !!sym(var), y = SalePrice)) +
            geom_point()

        
    })
    
    })
    
    # Server stuff for Modeling:

   # f <- reactive({
       #as.formula(paste(SalePrice ~ , data = house))
    #})

    
    
    output$Model <- renderPrint({
        GeneralLinearModel <- glm(SalePrice ~ LotArea + OverallCond, data = house)
        summary(GeneralLinearModel)
        })
    
    
    #Server stuff for Data
    output$tab <- renderDataTable({
        #Extract the selected houses, costs, and columns
        selectedHouses <- unlist(input$selectedhouses)
        selectedCols <- unlist(input$selectedvar)
        #Filter the data based on the user input
        housesub %>% select(selectedCols)
    })
    output$downloadData <- downloadHandler(
        
        ###
        # Make the possibly subsetted data downloadable.
        ###
        
        filename = function() {
            paste("data.csv")
        },
        content = function(file) {
            write.csv(
                housesub %>%
                    select(input$selectedCols), 
                file, 
                row.names = FALSE
            )
        }
    )
    
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

