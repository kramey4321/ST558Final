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



  #code to subset data based on slider, now can call myHouse() - just playing around
  myHouse <- reactive({
    housesub %>% filter((SalePrice >= input$priceED[1]) & (SalePrice <= input$priceED[2]))
  })
  
  
  #code to print out summary statistics of variable chosen
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

        
        observeEvent(input$trainStart, {
          
          ###
          # Test the performance of the three models.
          ###
          
          # Create a Progress object
          progress <- Progress$new()
          # Make sure it closes when we exit this reactive, even if there's an error.
          on.exit(progress$close())
          # Set the message to the user while cross-validation is running.
          progress$set(message = "Performing Cross-Validation", value = 0)
          
          # Get the variables to use for each model.
          glmVars <- unlist(input$glmVars)
          treeVars <- unlist(input$treeVars)
          randForVars <- unlist(input$randForVars)
          
          # Get the proportion of testing:
          propTesting <- input$propTesting
        
         
          # Get the random forest mtrys.
          randForMtry <- as.numeric(input$randForMtry)
          
        
          # Get the testing indexes.
          testInd <- sample(
            seq_len(nrow(housesub)), 
            size=floor(nrow(housesub)*propTesting)
          )
          
          # Split into training and testing sets.
          train <- housesub[-testInd, ]
          test <- housesub[testInd, ]
          
          # Suppress any warning in the fitting process.
          suppressWarnings(library(caret))
          
          # Set the repeated CV params.
          TrControl <- trainControl(
            method="cv",
            number=5
          )
          
          # Evaluate the General Linear Model through CV.
          glmModel = train(
            SalePrice ~ ., 
            data=train[, c(c("SalePrice"), glmVars)],
            method = "glm",
           # family = "binomial",
            metric="Accuracy",
            trControl=TrControl
          )
          
          # Increment the progress bar, and update the detail text.
          progress$inc(0.4, detail = "Classification Tree")
          
          # Let caret choose the best tree through CV.
          treeModel = train(
            SalePrice ~ ., 
            data=train[, c(c("SalePrice"), treeVars)],
            method="rpart", 
            metric="Accuracy",
            #tuneGrid=expand.grid(cp = Cps),
            trControl=TrControl
          )
          
          # Increment the progress bar, and update the detail text.
          progress$inc(0.6, detail = "Random Forest")
          
          # Let caret choose the best random forest through CV.
          rfModel = train(
            SalePrice ~ ., 
            data=train[, c(c("SalePrice"), randForVars)],
            method="rf", 
            metric="Accuracy",
            tuneGrid=expand.grid(mtry = randForMtry),
            trControl=TrControl
          )
          
          # Increment the progress bar, and update the detail text.
          progress$inc(0.8, detail = "Evaluating Test Set Performance")
          
          # Get test set predictions.
          glmPreds <- predict(glmModel, test, type="raw")
          treePreds <- predict(treeModel, test, type="raw")
          randForPreds <- predict(rfModel, test, type="raw")
          

          # Create an output for the logistic regression model rounding to 4 decimals.
          output$logRegSummary <- renderDataTable({
            round(as.data.frame(summary(logRegModel)$coef), 4)
          })
          
          # Create a nice tree diagram.
          output$treeSummary <- renderPlot({
            fancyRpartPlot(treeModel$finalModel)
          })
          
          # Create an output for the feature importance plot for random forest model.
          output$rfVarImpPlot <- renderPlot({
            ggplot(varImp(rfModel, type=2)) + 
              geom_col(fill="purple") + 
              ggtitle("Most Important Features by Decrease in Gini Impurity")
          })
#output$Model <- renderPrint({
       # GeneralLinearModel <- glm(SalePrice ~ LotArea + OverallCond, data = house)
      #  summary(GeneralLinearModel)
       # })
    
    # Seeing if the slider is talking to the UI and server...
    output$PriceRange <- renderText({
      paste0("The Price Range you selected is ", input$priceED[1], " to ", input$priceED[2])
          })
    
    #Server stuff for Data
    # Creating data of subset columns
    
    output$tablesub <- renderTable({
        #Extract the selected houses, costs, and columns
        selectedHouses <- unlist(input$selectedhouses)
        selectedCols <- unlist(input$selectedvar)
        #Filter the data based on the user input
              #Filter by price (rows)
        housesub %>%  select(SalePrice, input$selectedvar) %>% 
          filter((SalePrice >= input$selectedprices[1]) & (SalePrice <= input$selectedprices[2]))
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
})
    