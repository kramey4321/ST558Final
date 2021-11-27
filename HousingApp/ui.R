# ST558 Kristi Ramey
# Final project of blood, sweat, tears...and fun!

library(shiny)


data("train.csv")
house <- read_csv("train.csv")


# Define UI for application with tabbies that do stuff 
shinyUI(fluidPage(
  navbarPage(
  # Application title
    title = "Housing Prices",
    
    tabPanel("About",
      h1("This is the about page")
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
          list("Histogram" = "1", "Numeric Summary" = "2", "Scatterplot" = "3"), 
        selected = "1"),
        br(),
        minY <- min(house$SalePrice),
        maxY <- max(house$SalePrice),
        minX <- min(house$input.var),
        maxX <- max(house$input.var),
        sliderInput("rangeY", "Price Range:",
                    min = minY,
                    max = maxY,
                    value = 30
                     ),
        sliderInput("rangeX", "Variable Range",
                    min = minX,
                    max = maxX,
                    value = 30
                    )), # This ends Side Panel ED
                     
    # Show a plot of the generated distribution
                     mainPanel(
                         plotOutput("distPlot"),
                         plotOutput("scatterPlotmodel"),
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
              width="100%")
                     ), #This ends sidebarPanel
                     mainPanel(
                         plotOutput("distPlotmodel")
                     )#This ends mainPanel
                 ) #This ends sidebarLayout
                 
        ), #This ends Modeling tab
        
        tabPanel("Data",
                 sidebarLayout(
                     sidebarPanel(
                         h1("Words!")
                     ), #This ends sidebarPanel
                     mainPanel(
                         h1("More words!")
                     )#This ends mainPanel
                 ) #This ends sidebarLayout
                 
        ) #This ends Data tab         
        #This ends navbarPage
    )
    #This ends ShinyUI Fluidpage
))

