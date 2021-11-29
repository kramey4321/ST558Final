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
 # PriceRange <- reactive({
 #   input$priceED
#  })
  
 # housesub %>% filter((SalePrice >= PriceRange[1]) & (SalePrice <= PriceRange[2]))
  
    #housesub %>% filter((housesub$SalePrice >= sliderValues[1]) & 
                       # (housesub$SalePrice <= sliderValues[2]))
  myHouse <- reactive({
    housesub %>% filter((SalePrice >= input$priceED[1]) & (SalePrice <= input$priceED[2]))
  })
  
  
      output$summaryDset <- renderPrint({
        summary(housesub[[input$var]])
    })
    
 output$usergraph <- renderPlot({
   
   if(input$type == 1) {
        var <- input$var
        ggplot(data = housesub) + 
        geom_histogram(aes_string(x = var), color = 'black', fill = 'blue')
   }
   else{
    
#This one works:
      var <- input$var
     price <- housesub$SalePrice
      ggplot(data = housesub, aes(x = !!sym(var), y = SalePrice)) + 
         geom_point()  + ylim(as.numeric(input$priceED[1]), as.numeric(input$priceED[2]))
   }
 })
  #  output$scatterPlotmodel <- renderPlot({
   #   var <- input$var
    #  myHouse <- reactive({
     #   housesub %>% filter((SalePrice >= input$priceED[1]) & (SalePrice <= input$priceED[2]))
      #})
      #range <- input$priceED
      #price <- myHouse$SalePrice
      #ggplot(data = myHouse, aes(x = !!sym(var), y = SalePrice), ylim = range()) +
       # geom_point()
  #  })
    
    
    # Server stuff for Modeling:

   # f <- reactive({
       #as.formula(paste(SalePrice ~ , data = house))
    #})

    
    
    output$Model <- renderPrint({
        GeneralLinearModel <- glm(SalePrice ~ LotArea + OverallCond, data = house)
        summary(GeneralLinearModel)
        })
    
    # Seeing if the slider is talking to the UI and server...
    output$PriceRange <- renderText({
      paste0("The Price Range you selected is ", input$priceED[1], " to ", input$priceED[2])
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

