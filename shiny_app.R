library(shiny)
library(reticulate)
library(DT)


# Required Parameters
py_run_string("csv_file_location = 'C:/Users/hahla/Desktop/github/polyseis/data/sneap_text.csv'")
py_run_string("searchname = 'sample_search4'")
py_run_string("text_column_name = 'thread_text'")
py_run_string("id_column_name = 'textid'")

# Optional Parameters
py_run_string("return_results_count = 10")
py_run_string("min_fasttext_word_count = 3") # only consider tokens with at least n occurrences in the corpus
py_run_string("fasttext_epochs = 1")
py_run_file("bescea.py") # Run model


ui <- shinyUI(fluidPage(
  verticalLayout(
    h2("Bescea"),
    textInput("query", label = h4("Query"), value = ""),
    submitButton("Submit"),
    actionButton("resultsButton", "Show Results")
  ),
  mainPanel(h4("Documents"),
            tableOutput("resultsTable"))

))

server <- function(input, output, session) {

  queryInput <- eventReactive(input$resultsButton,{
    
    data.frame(py$besceaSearch(input$query))
  })
  

  output$resultsTable <- renderTable({
    queryInput()
  })
  
  session$onSessionEnded(function() {
    stopApp()
  })
}

shinyApp(ui, server)