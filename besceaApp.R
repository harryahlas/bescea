besceaApp <- function(data,
                      text_field,
                      unique_id,
                      modelname = NULL,
                      searchname = NULL,
                      results_count = 50) {

  source("besceaBuildModel.R")
  source("besceaLoadData.R")
  source("besceaSearch.R")
  
  # If you are running this on its own without a prior model, then use besceaLoadData to build a model and then load data
  if(is.null(modelname)) {
    besceaLoadData(data = data, 
                   text_field = text_field,
                   unique_id = unique_id)
  } 
  
  # Else if you want to load an old model then do so and then load your new data
  else if(!is.null(modelname)) {
    besceaLoadData(data = data, 
                   text_field = text_field,
                   unique_id = unique_id,
                   modelname = modelname,
                   searchname = searchname)
  } 
  
  # This shouldn't occur
  else {stop("Error of otherworldly origin")}
  
  library(shiny)
  library(reticulate)
  library(DT)
  library(writexl)
  
  if(!is.null(results_count)) {
    py$return_results_count <- r_to_py(as.integer(results_count))
  }
  

  ui <- shinyUI(fluidPage(
    
    # Application title
    titlePanel("Bescea"),
   
    sidebarLayout(
      
      # Side panel
      sidebarPanel(textInput("query", label = h4("Query"), value = ""),
                   HTML("<br>"),
                   actionButton("resultsButton", "Show Results"),
                   HTML("<br>"),
                   downloadButton("dl", "Download"),
                   width = 3),
      
      # Main Panel
      mainPanel(h4("Documents"),
                DT::dataTableOutput("resultsTable"),
                width = 9)
    )))
  
  server <- function(input, output, session) {
    
    queryInput <- eventReactive(input$resultsButton,{
      
      documents_retrieved <- data.frame(besceaSearch(input$query, results_count))
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
    
    # Print to excel file
    output$dl <- downloadHandler(
      filename = function() { "ae.xlsx"},
      content = function(file) {write_xlsx(queryInput(), path = file)}
    )
    
    session$onSessionEnded(function() {
      stopApp()
    })
  }
  
  shinyApp(ui, server)  
  
}

