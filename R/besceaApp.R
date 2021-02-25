#' Bescea Shiny App
#'
#' Instant search engine
#' @param data Data frame, each document is a row/observation.
#' @param text_field Text field from data
#' @param unique_id Unique identifier from data
#' @param modelname Defaults to NULL. If you are loading data to a FastText model built using besceaBuildModel, put the name of model here.  The model should be saved as 3 different files in the 'models' folder.
#' @param searchname Optional name that appears at the top of the Shiny app
#' @param results_count Number of results to load to the Shiny app. This is also the number of results that will be exported to Excel if the data is downloaded. This number can be changed in the app as well.  You may be able to speed up performance by choosing a lower number.
#' @param ... Arguments passed from other functions
#' @keywords text
#' @export
#' @examples
#' besceaApp(data = sneapsters[1:100,], 
#'           text_field = "post_text",
#'           unique_id = "textid",
#'           searchname = "test_search")

besceaApp <- function(data,
                      text_field,
                      unique_id,
                      modelname = NULL,
                      searchname = "Bescea",
                      results_count = 50, ...) {
  
  dir.create("models")
  
  # If you are running this on its own without a prior model, then use besceaLoadData to build a model and then load data
  if(is.null(modelname)) {
    besceaLoadData(data = data, 
                   text_field = text_field,
                   unique_id = unique_id, ...)
  } 
  
  # Else if you want to load an old model then do so and then load your new data
  else if(!is.null(modelname)) {
    besceaLoadData(data = data, 
                   text_field = text_field,
                   unique_id = unique_id,
                   modelname = modelname,
                   searchname = searchname, ...)
  } 
  
  # This shouldn't occur
  else {stop("Error of otherworldly origin")}
  
  # library(shiny)
  library(reticulate)
  # library(DT)
  # library(writexl)
  
  if(!is.null(results_count)) {
    py$return_results_count <- reticulate::r_to_py(as.integer(results_count))
  }
  

  ui <- shiny::shinyUI(shiny::fluidPage(
    
    # Application title
    shiny::titlePanel(paste(searchname, "Search")),
    
    shiny::sidebarLayout(
      
      # Side panel
      shiny::sidebarPanel(shiny::textInput("query", label = shiny::h4("Query"), value = ""),
                          shiny::textInput("resultsCountButton", 
                                           label = "# Results", 
                                           width = '75px',
                                           value = results_count),
                          shiny::actionButton("resultsButton", "Show Results"),
                          shiny::HTML("<br><br>"),
                          shiny::downloadButton("dl", "Download to Excel"),
                          # shiny::textInput("fastTextStrengthInput", 
                          #                  label = "FastText Strength", 
                          #                  width = '75px',
                          #                  value = .5)
                          shiny::sliderInput("fastTextStrengthInput", 
                                           label = "FastText Strength", 
                                           #width = '75px',
                                           value = .5,
                                           min = 0,
                                           max = 1),
                          width = 3
      ),
      
      # Main Panel
      shiny::mainPanel(shiny::h4("Documents"),
                       DT::dataTableOutput("resultsTable"),
                       width = 9)
    )))
  
  server <- function(input, output, session) {
    
    # Number of results to show
    resultsCountInput <- shiny::eventReactive(input$resultsCountButton,{
      
      input$resultsCountButton
      
    })
    
    fastTextStrength <- shiny::eventReactive(input$fastTextStrengthInput,{
      
      input$fastTextStrengthInput
      
    })
    
    queryInput <- shiny::eventReactive(input$resultsButton,{
      
      documents_retrieved <- data.frame(besceaSearch(input$query, as.integer(resultsCountInput()), fastTextStrength()))
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
    output$dl <- shiny::downloadHandler(
      filename = function() { "ae.xlsx"},
      content = function(file) {writexl::write_xlsx(queryInput(), path = file)}
    )
    
    session$onSessionEnded(function() {
      shiny::stopApp()
    })
  }
  
  shiny::shinyApp(ui, server, options = list(launch.browser = TRUE))  
  
}

