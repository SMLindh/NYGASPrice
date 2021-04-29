#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(ggplot2)
library(rsconnect)
gas =read.csv('gas.csv')
#Gets list of factor levels for County
#Will use this for the dropdown menu in UI
levels(gas$County)
count_choices = levels(gas$County)
count_choices = count_choices[-c(3,31)]

?h3
?column
ui <-
    
    fluidPage(theme = shinytheme("slate"),
    titlePanel("NY Gas Revenue by County from 1995-2016"),
    fluidRow(
        column(9,
               h3("Kaggle Description"),
               p("'Estimated gasoline sales data is derived from New York State
                 Department of Taxation and Finance data on gasoline sales and 
                 gasoline sales tax collections. Gasoline sales data is estimated 
                 for eachcounty with the exception that individual county data 
                 for New YorkCity is not available. Data is weighted for regional 
                 price differencesand differing county tax rates.'"),
               p("Data taken from Kaggle"),
               p("https://www.kaggle.com/tunguz/estimated-gasoline-sales")
               
               
                 )
    ),
      
  
    fluidRow(
        column(3,
               selectInput("County", 
                           h3("County"),
                           choices = count_choices),
               selected = "A"),
        column(3,
               numericInput("Start_year", 
                            h3("Start Year"), 
                            value = 1995)),
        column(3,
               numericInput("End_year", 
                            h3("End Year"), 
                            value = 2016)) 
    ),
    mainPanel(
       
            plotOutput("gasplot")
    )

   
)


server <- function(input, output) {
    output$gasplot = renderPlot({
        gas2= subset(gas, gas$Year >= input$Start_year & gas$Year<=input$End_year & gas$County == input$County )
        ggplot(gas2, aes(x = gas2$Year, y = gas2$Estimated.Sales..Thousands.of.Gallons)) + 
            geom_point()+
            geom_smooth(method = 'lm')+
            ggtitle("Gas Revenue by Year")+ xlab("Year") + ylab("Estimated Sales")
       
    })

    
}

# Run the application 
shinyApp(ui = ui, server = server)
