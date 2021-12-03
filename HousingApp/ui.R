# ST558 Kristi Ramey
# Final project of blood, sweat, tears...and fun!

library(shiny)
library(tidyverse)
library(DT)


data("train.csv")
house <- read_csv("train.csv")
housesub <- house %>% select(LotArea, OverallQual, OverallCond, YearBuilt, GrLivArea, 
                             BedroomAbvGr, TotRmsAbvGrd, SalePrice)

# Define UI for application with tabbies that do stuff 
shinyUI(fluidPage(
  navbarPage(
  # Application title
    title = "Housing Prices",
    
    tabPanel("About",
      h1("Predicting Housing Prices"),
      h3("Hello, and welcome to my app that lets you explore different 
         variables that can contribute to the sale price of a house.  This project
         is an offshoot of a Kaggle competition my students recently attempted.  
         After two weeks of amazing lessons from our dear Professor, Craig and my 
        students tried their hand at predicting the sale price.  They were proud of
        their results, but then (of course) asked what our ranking in the competition
        was, so the idea was born to kill two birds with one stone."),
      h3("The dataset comes from this ", 
    a(href = "https://www.kaggle.com/c/house-prices-advanced-regression-techniques", 
      code("kaggle competion")), "along with its discription."), 
    h3("At the top, you will see the following tabs:"),
    h3(strong("Data Exploration")),
    h4("This section let's you play around with the data. You get 
        to select a variable, see its distribution and see it's relationship to 
       the sale price."),
    h3(strong("Modeling")),
    h4("Here you can look at different models for sale price depending on which
       exploratory variables you select."),
    h3(strong("Data")),
    h4("In theory, this is where you can select what data you want to take with you"),
    img(src = "houses.jpg", height = 140, width = 400)
    
      #End the about panel
        ),
    
    tabPanel("Data Exploration",
      # Let the user look at different variables
      sidebarLayout(
        sidebarPanel(
        h3("Come take a look at different variables that go into the sale price
            of a home"),
        br(),
        h4("Pick from the options below"),
        selectInput("var", label = "Housing Variable", 
                    choices = c("Lot Size"="LotArea", "Quality" = "OverallQual",
                                "Condition" = "OverallCond", "Year Built" = 
                                "YearBuilt", "Square Footage" = "GrLivArea", 
                                "# of Bedrooms" = "BedroomAbvGr", "Total # of Rooms" = 
                                "TotRmsAbvGrd")),
        br(),
        h4("Type of presentation"),
        radioButtons("type", "Select the Type", choices = 
          c("Histogram" = "1", "Scatterplot" = "2"), 
        selected = "1"),
        br(),
        minY <- min(housesub$SalePrice),
        maxY <- max(housesub$SalePrice),
        sliderInput("priceED", "Price Range:",
                    min = minY,
                    max = maxY,
                    value = c(50000, 400000)
                     )
        ), # This ends Side Panel ED
                     
    # Show a plot of the generated distribution
                     mainPanel(
                       
                      # Plot the histogram or scatterplot
                         plotOutput("usergraph"),
                         
                         #Show the price range that was selected
                         textOutput("PriceRange"),
                         
                         # Don't need this plot, but so excited it worked!
                        #plotOutput("scatterPlotmodel2"),
                        
                        #Print out Summary of variable selected
                            verbatimTextOutput("summaryDset")
                         )
                     ) # This ends DE mainPanel 
                 ), # This ends Data Exploration tab
        
    # Create the Modeling tab with 3 sub-tabs.
    navbarMenu(
      
      # Add a title.
      title="Modeling",
      
      # Add the Modeling Info tab.
      tabPanel(
        # Give it a title,
        title = "Modeling Info",
        mainPanel(fluidPage(
          # Give an overview of the modeling excercise.
          br(),
          h4("Modeling Info"),
          "The goal of the modeling section is to find an equation that best",
          "fits housing prices based on the variables you choose",
          "We will use 3 types of models: general linear regression, ",
          "classification trees, and random forests.",
          br(),
          br(),
          # Give an overview of general linear regression.
          h4("General Linear Regression"),
          "General Linear Regression is a regression model that takes the whole",
          "data set and models the response variable using multiple linear",
          "regression models.  It uses the sum of square errors to find the parameters",
          
          # Code for sum of square error
            withMathJax(
              helpText("$$\\sum_{i=1}^n (y_i-\\hat{y_i})^2$$")
            
          ),
          
          "Its linear form allows for interpretation of the parameters, and the signs ",
          "tell us if increasing values of a variable makes an ",
          "outcome more or less likely.  However, the model is not very flexible",
          "and can not fit extreme values very well.",
          br(),
          br(),
          #Equation - if possible - uiOutput("logRegEx"),
          "Its linear form allows for interpretation, as the signs ",
          "tell us if increasing values of a variable makes an ",
          "outcome more or less likely.",
          # Give an overview of trees.
          h4("Trees"),
          "Unlike General Linear Regression that looks at the entire data, a",
          "tree based method splits up predictor spaces into regions and ",
          "creates different predictions for each region. ",
          br(),
          br(),
          "The upside of trees is that it is very user friendly and",
          "the tree diagram is very easy for a laymen to understand the splits",
          "The downside is the with all of these branches, this model is more",
          "suited for prediction not inference.",

          
          # Give an overview of random forests.
          h4("Random Forests"),
          "Random forests average across many fitted tress.", 
          "It can decreases varaince over an individual tree and often",
          "uses bootstrapping to get multiple samples to fit on.",
          "This modeling is much more flexible, however, because of",
          "the way it is created (averaging other trees), what you gain",
          "in prediction power, you lose in interpretability.",
 
          br(),
          br()
        ))
      ),


    # Tab for fitting the models
    tabPanel("Customize your Model",
        sidebarLayout(
          sidebarPanel(
            h1("Let's model some Prices!"),
            
            # Create a section for the general linear regression parameters.
            h3("General Linear Regression Parameters"),
            # Let the user set which variables to use.
            selectInput(
              inputId = "glmVars",
              label = "Variables to Include:",
              choices = c(
                "Lot Size"="LotArea",
              "Quality" = "OverallQual",
              "Condition" = "OverallCond", 
              "Year Built" = "YearBuilt",
              "Square Footage" = "GrLivArea", 
              "# of Bedrooms" = "BedroomAbvGr", 
              "Total # of Rooms" = "TotRmsAbvGrd"),
              
              selected = c(
                "Lot Size"="LotArea"
                ),
              multiple = TRUE,
              selectize = TRUE
            ),
                     
            # Create a section for the tree parameters.
            h3("Tree Parameters"),
            # Let the user set which variables to use.
            selectInput(
              inputId = "treeVars",
              label = "Variables to Include:",
              choices = c(
                "Lot Size"="LotArea",
                "Quality" = "OverallQual",
                "Condition" = "OverallCond", 
                "Year Built" = "YearBuilt",
                "Square Footage" = "GrLivArea", 
                "# of Bedrooms" = "BedroomAbvGr", 
                "Total # of Rooms" = "TotRmsAbvGrd"),
              
              selected = c(
                "Lot Size"="LotArea"
              ),
              multiple = TRUE,
              selectize = TRUE
            ),
           
            # Create a section for the random forest parameters.
            h3("Random Forest Parameters"),
            # Let the user select which variables to use.
            selectInput(
              inputId = "randForVars",
              label = "Variables to Include:",
              choices = c(
                "Lot Size"="LotArea",
                "Quality" = "OverallQual",
                "Condition" = "OverallCond", 
                "Year Built" = "YearBuilt",
                "Square Footage" = "GrLivArea", 
                "# of Bedrooms" = "BedroomAbvGr", 
                "Total # of Rooms" = "TotRmsAbvGrd"),
              
              selected = c(
                "Lot Size"="LotArea"
              ),
              multiple = TRUE,
              selectize = TRUE
            ),
               
              
              # Add a button for fitting models.
              actionButton(
                inputId = "trainStart",
                label = "Fit Models"
              )
            ),

          # Create the main panel to hold model performances and 
          # summaries.
          mainPanel(
            # Show test/train split
            "A really, really cool model!",
            br(),
            
          ) # closes main Panel
        ) #This ends the main page for Customized model.
    ),
        # Create the prediction tab.
        tabPanel(
          # Add a title.
          title = "Prediction",
          # Create a sidebar for the user to play with inputs.
          sidebarPanel(
            # Add buttons to select which model to use.
            radioButtons(
              inputId = "modelType",
              label = "Choose a Model",
              inline = TRUE,
              choiceNames = c(
                "General Linear Regression", 
                "Classification Tree", 
                "Random Forest"
              ),
              choiceValues = c("genlin", "tree", "randFor"),
              selected = "genlin"
            ),
            
            # Add a button for fitting models.
            actionButton(
              inputId = "predStart",
              label = "Predict"
            )
          ), # End of sidebar
          # Create the main panel to show predictions.
          mainPanel(
            "This house probably cost a ton more now...but here's",
             "what your model predicted",

          ), #End of Main Panel for Predictions
)
), #End of the 3 sub tabs
        
        tabPanel("Data",
                   sidebarPanel(
                     # Create a filter for Rows
                     #Price - hmm...How can I do a range?...
                     # A slider!!!
                     
                     minY <- min(housesub$SalePrice),
                     maxY <- max(housesub$SalePrice),
                     sliderInput("selectedprices", "Price Range:",
                                             min = minY,
                                             max = maxY,
                                             value = c(minY, maxY)
                     ),
                     
                     # Create a filter for the columns.
                     selectInput(
                      inputId = "selectedvar",
                     label = "Filter by variable(s)",
                     choices = c("Lot Size"="LotArea", "Quality" = "OverallQual",
                            "Condition" = "OverallCond", "Year Built" = 
                             "YearBuilt", "Square Footage" = "GrLivArea", 
                            "# of Bedrooms" = "BedroomAbvGr", "Total # of Rooms" = 
                              "TotRmsAbvGrd"),
                     selected =  c("Lot Size"="LotArea"),
                      multiple = TRUE,
                     selectize = TRUE
                     ),
                 
                     # Create a download button to download the data set.
                     downloadButton("downloadData", "Download"),

                   ), #This ends sidebarLayout
                   # Display the filtered data on the main panel.
                   mainPanel(
                     "YO- this works, so where's the flippin' table??",

                    dataTableOutput(outputId = "tablesub")
                     )#This ends mainPanel
                 
        ) #This ends Data tab         
        )#This ends navbarPage
    )
    #This ends ShinyUI Fluidpage
)

