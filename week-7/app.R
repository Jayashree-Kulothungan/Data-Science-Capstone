library(tidyverse)
library(stringr)
library(dplyr)
library(ngram)
library(tidyr)
library(shiny)

source("function.r")

ui <- fluidPage(
        
        # Application title
        titlePanel("Text Prediction Model"),
        p("This app that takes an input phrase (multiple words) in a text box and outputs a prediction of the next word."),
        
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
                sidebarPanel(
                        h3("Data Science Capstone"), 
                        h5("Week 7- Prediction Model"),
                        h5("The goal of this exercise is to create a product to highlight the prediction algorithm that you have built and to provide an interface that can be accessed by others."),
                        h5("For this project you must submit"),
                        h5("1.Shiny app that takes as input a phrase (multiple words) in a text box input and outputs a prediction of the next word"),
                        h5("2. A slide deck consisting of no more than 5 slides created with R Studio Presenter"),
                        br(),
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                        tabsetPanel(
                                tabPanel("predict",
                                         textInput("user_input", h3("Your Input:"), 
                                                   value = "Your words"),
                                         h3("Predicted Next Word:"),
                                         h4(em(span(textOutput("ngram_output"), style="color:blue")))),
                                
                                tabPanel("Instructions",
                                         br(),
                                         h3('1. Enter ont to 3 words in the box below'),
                                         h3('2. The predicted next Word will be printed below'),
                                         h3('3. If a word cannot be predicted usually because of spelling errors, ? will be printed'),
                                ),
                                
                                tabPanel("Source Code",
                                         br(), 
                                         a("1.loading and cleaning data", href = "https://github.com/Jayashree-Kulothungan/Data-Science-Capstone/blob/main/week-7/loadingData.R"),
                                         br(),
                                         a("2. Exploratory Data Analysis", href="https://github.com/Jayashree-Kulothungan/Data-Science-Capstone/blob/main/Week%202/Week2-ngrams.R"),
                                         br(),
                                         a("3. Analysis-Report", href="https://rpubs.com/Jayasree_Kulothungan/Data-SCience-Capstone-Week-2-Assignment"),
                                         br(),
                                         a("4. creating n-gram function ", href="https://github.com/Jayashree-Kulothungan/Data-Science-Capstone/blob/main/week-7/n-grams.R"),
                                         br(),
                                         a("5. Prediction Model", href="https://github.com/Jayashree-Kulothungan/Data-Science-Capstone/blob/main/week-7/function.R"),
                                         br(),
                                         a("6. ShinyApp" , href = "https://github.com/Jayashree-Kulothungan/Data-Science-Capstone/blob/main/week-7/shinyApp.R"),
                                         
                                ),
                                
                                tabPanel("Data",
                                         br(),
                                         h5("Data were downloaded from following link"),
                                         a("Data source", href="https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"),
                                         )
                        )   
                )
        )
)

server <- function(input, output) {
        
        output$ngram_output <- renderText({
                ngrams(input$user_input)
        })
        
}

shinyApp(ui = ui, server = server)
