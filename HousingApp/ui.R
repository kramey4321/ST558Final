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
                       
                      
                         plotOutput("usergraph"),
                         textOutput("PriceRange"),
                         # Don't need this plot, but so excited it worked!
                        #plotOutput("scatterPlotmodel2"),
                         #box(title = "Data Summary",
                           #solidHeader = TRUE,
                           verbatimTextOutput("summaryDset")
                         )
                     ) # This ends DE mainPanel 
                 ), # This ends Data Exploration tab
        
        tabPanel("Modeling",
        sidebarLayout(
          sidebarPanel(
            h1("Let's model some variables!"),
            h4("Pick the variables you want to add to the model"),
            checkboxGroupInput("CBG",h3("Select From the Choices Below"),
            choices=list("Lot Size"="LotArea", "Quality" = "OverallQual",
                         "Condition" = "OverallCond", "Year Built" = 
                          "YearBuilt", "Square Footage" = "GrLivArea", 
                        "# of Bedrooms" = "BedroomAbvGr", "Total # of Rooms" = 
                             "TotRmsAbvGrd"),
              width="100%"),
                     
          #Online code to add a train/test split 
          
           sliderInput("split", h3("Train/Test Split %"),
              min = 0, 
              max = 100,
              value = 75
            ),
          textOutput("cntTrain"),
          textOutput("cntTest")
          ), #This ends sidebarPanel

                     mainPanel(
                      
                       verbatimTextOutput("Model")
                     )#This ends mainPanel
                 ) #This ends sidebarLayout
                 
        ), #This ends Modeling tab
        
        tabPanel("Data",
                   sidebarPanel(
                     # Create a filter for houses - seems silly, taking out
                     #selectInput(
                      # inputId = "selectedhouses",
                       #label = "Filter by house(s)",
                      # choices = unique(housesub),
                      # selected = unique(housesub),
                      # multiple = TRUE,
                       #selectize = TRUE
                   #  ),
                     # Create a filter for Price - hmm...How can I do a range?...
                     # A slider!!!
                     
                     minY <- min(housesub$SalePrice),
                     maxY <- max(housesub$SalePrice),
                     sliderInput("selectedprices", "Price Range:",
                                             min = minY,
                                             max = maxY,
                                             value = c(minY, maxY)
                     ),
                     # Create a filter for the variables.
                     selectInput(
                      inputId = "selectedvar",
                     label = "Filter by variable(s)",
                     choices = c("Lot Size"="LotArea", "Quality" = "OverallQual",
                            "Condition" = "OverallCond", "Year Built" = 
                             "YearBuilt", "Square Footage" = "GrLivArea", 
                            "# of Bedrooms" = "BedroomAbvGr", "Total # of Rooms" = 
                              "TotRmsAbvGrd"),
                     selected =  c("Lot Size"="LotArea"),
                     #"Quality" = "OverallQual",
                                  #"Condition" = "Ove,rallCond", "Year Built" = 
                               #   "YearBuilt", "Square Footage" = "GrLivArea", 
                               #"# of Bedrooms" = "BedroomAbvGr", "Total # of Rooms" = 
                               #  "TotRmsAbvGrd"),
                      multiple = TRUE,
                     selectize = TRUE
                     ),
                     # Create a filter for the columns to display.
                     #selectInput(
                     #inputId = "selectedCols",
                      #label = "Filter Columns",
                       #choices = colnames(countyData),
                       #elected = colnames(countyData),
                      # multiple = TRUE,
                      # selectize = TRUE
                    # ),
                     # Create a download button to download the data set.
                     sidebarPanel(downloadButton("downloadData", "Download"))
                   ),
                   # Display the filtered data on the main panel.
                   mainPanel(
                    dataTableOutput(outputId = "tab")
                 #sidebarLayout(
                  #   sidebarPanel(
                   #      h1("Pick what you want")
                    # ), #This ends sidebarPanel
                     #mainPanel(
                      #   h1("Code to give it to you")
                     )#This ends mainPanel
                 ) #This ends sidebarLayout
                 
        ) #This ends Data tab         
        #This ends navbarPage
    )
    #This ends ShinyUI Fluidpage
)

