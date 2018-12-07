library(ggplot2)
library(tidyr)

nt <- 10
set.seed(12345)

dat_lag <- data.frame(
  t=seq(1, 100, 10),
  bug1=sort(rnorm(n=nt, 0,  sd = .1)),
  bug2=sort(rnorm(n=nt, 0,  sd = .1)),
  bug3=sort(rnorm(n=nt, 0, sd = .1))
)

dat_exp <- data.frame(
  t=seq(101, 200, 10),
  bug1=sort(rnorm(n=nt, 1.5)),
  bug2=sort(rnorm(n=nt, 1.5)),
  bug3=sort(rnorm(n=nt, 1.5))
)

dat_stat <- data.frame(
  t=seq(201, 300, 10),
  bug1=sort(rnorm(n=nt, 4, sd = .1)),
  bug2=sort(rnorm(n=nt, 4, sd = .1)),
  bug3=sort(rnorm(n=nt, 4, sd = .1))
)

dat <- rbind(dat_lag, dat_exp, dat_stat)
tdat <- dat %>% gather(sample, value, -t)
ggplot(tdat, aes(x=t, y=value, color=sample)) + geom_point() + geom_smooth(method = "loess") + theme_classic()


#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Plate Reader data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("span",
                  "span:",
                  min = 0.1,
                  max = 2,
                  value = 0.05),
      
      checkboxGroupInput("sample",
                  "sample",
                  choices=unique(tdat$sample)
                  )),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    ggplot(tdat[tdat$sample %in% input$sample, ], aes(x=t, y=value, color=sample)) + 
      geom_point() + 
      geom_smooth(method = "loess", span = input$span)+
      theme_classic()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
