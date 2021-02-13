besceaApp <- function(results_count = NULL) {

  if(!exists("bescea_loaded")) {stop("You need to successfully run besceaLoad() first")}#; break}
  
  library(shiny)
  library(reticulate)
  library(DT)
  
  if(!is.null(results_count)) {
    py$return_results_count <- r_to_py(as.integer(results_count))
  }
  

  ui <- shinyUI(fluidPage(
    
    # Application title
    titlePanel("Bescea"),
   
    sidebarLayout(
      
      # Side panel
      sidebarPanel(textInput("query", label = h4("Query"), value = ""),
                   actionButton("resultsButton", "Show Results"),
                   width = 3),
      
      # Main Panel
      mainPanel(h4("Documents"),
                DT::dataTableOutput("resultsTable"),
                width = 9)
    )))
  
  server <- function(input, output, session) {
    
    queryInput <- eventReactive(input$resultsButton,{
      
      documents_retrieved <- data.frame(besceaSearch(input$query))
      documents_retrieved$score <- round(documents_retrieved$score,3)
      documents_retrieved
      
    })
    
    output$resultsTable <- DT::renderDataTable(
        queryInput() , 
        filter = "top",
        rownames= FALSE,
        # Dropdown for how many rows to display
        options = list(pageLength = 7, info = FALSE, lengthMenu = list(c(25, 20, 15, 10, 5, -1), c("25", "20", "15", "10", "5", "All"))) #)
    )
   
    session$onSessionEnded(function() {
      stopApp()
    })
  }
  
  shinyApp(ui, server)  
  
}

