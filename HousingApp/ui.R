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
                                "# of Bedrooms" = "Bedroom", "Total # of Rooms" = 
                                "TotRmsAbvGrd")),
        br(),
        h4("Type of presentation"),
        radioButtons("type", "Select the Type", choices = 
          list("Histogram" = "1", "Numeric Summary" = "2", "Scatterplot" = "3"), 
        selected = "1"),
        br(),
        
        sliderInput("range", "Range of Variable:",
                    min = 1,
                    max = 50,
                    value = 30)
                     ),
                     
    # Show a plot of the generated distribution
                     mainPanel(
                         plotOutput("distPlot")
                         #br(),
                         #plotOutput("disPlotmodel"),
                         #dataTableOutput("summary"),
                         #box(
                          # title = "Data Summary",
                           #solidHeader = TRUE,
                           #width = 6,
                           #height = 142,
                           #verbatimTextOutput("summaryDset")
                         )
                     )# This ends DE SidebarPanel 
                 ) # This ends Data Exploration tab
        ),
        tabPanel("Modeling",
                 sidebarLayout(
                     sidebarPanel(
                         h1("Words!")
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
)

