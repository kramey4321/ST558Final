#ST558 Kristi Ramey - FINAL!!! :)

library(shiny)
library(tidyverse)
library(DT)
library(caret)
#install.packages("rattle")
library(rattle)
data("train.csv")
house <- read_csv("train.csv")
#subset data to interesting variables
housesub <- house %>% select(LotArea, OverallQual, OverallCond, YearBuilt, GrLivArea, 
                 BedroomAbvGr, TotRmsAbvGrd, SalePrice)

# Define server logic to plot a histogram, scatterplot, and summary
shinyServer(function(input, output, session) {



  #code to subset data based on slider, now can call myHouse()
  myHouse <- reactive({
    housesub %>% filter((SalePrice >= input$priceED[1]) & (SalePrice <= input$priceED[2]))
  })
  
  
  #code to print out summary statistics of variable choosen
      output$summaryDset <- renderPrint({
        summary(housesub[[input$var]])
    })
      
  #code to either plot a histogram or a scatterplot based on the user selection
   output$usergraph <- renderPlot({
   
   if(input$type == 1) {
     #ED - histogram of variable selected
        var <- input$var
        ggplot(data = housesub) + 
        geom_histogram(aes_string(x = var), color = 'black', fill = 'blue')
   }
   else{
    
#ED - scatterplot This one works (kind of lame though):
      var <- input$var
     price <- housesub$SalePrice
      ggplot(data = housesub, aes(x = !!sym(var), y = SalePrice)) + 
         geom_point()  + ylim(as.numeric(input$priceED[1]), as.numeric(input$priceED[2]))
   }
 })
  # HUZZAH!! This one actually filters the data! :) 
   #Never referred to this one in the UI, just too satisfying to delete
 myHouse <- reactive({
   housesub %>% filter((SalePrice >= input$priceED[1]) & (SalePrice <= input$priceED[2]))
 })
 output$scatterPlotmodel2 <- renderPlot({
      var <- input$var
      ggplot(data = myHouse(), aes(x = !!sym(var), y = SalePrice)) +
        geom_point()
   })
    
    
    # Server stuff for Modeling:

 # Filtering the data based on the Training/Testing split the user chooses.  
#     createDataPartition(housesub, p = input$split, list = FALSE) 
#   })

 #houseTrain <- housesub[trainIndex(),]
# houseTest <- housesub[-trainIndex(),]

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
              #Filter by price (rows)
        housesub %>%  select(SalePrice, input$selectedvar) %>% filter((SalePrice >= input$selectedprices[1]) & (SalePrice <= input$selectedprices[2]))
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
    