#' Load new data to bescea model
#'
#' Load new data to bescea model for searching
#' @param data Data frame, each document is a row/observation.
#' @param text_field Text field from data, unquoted
#' @param unique_id Unique identifier from data, unquoted
#' @param modelname Defaults to NULL. If you are loading data to a FastText model built using besceaBuildModel, put the name of model here.  The model should be saved as 3 different files in the 'models' folder.
#' @param searchname Optional name that appears at the top of the Shiny app
#' @param spacy_nlp_model Defaults to *NULL*.  When Python is run, SpaCy will load "en_core_web_sm" unless this argument is present. In that case, SpaCy will look for an nlp model in the location you provide. 
#' @param ... Arguments passed from other functions
#' @keywords text search engine
#' @export
#' @examples
#' # Build model called "my_model" first
#' besceaBuildModel(data = sneapsters[1:100,], 
#'   text_field = post_text,
#'   unique_id = textid, 
#'   min_word_count = 1,
#'   epochs = 1, 
#'   modelname = "my_model")
#'   
#' # Then load data and run using "my_model"  
#' besceaLoadData(data = sneapsters[1:100,], 
#'   text_field = post_text,
#'   unique_id = textid,
#'   modelname = "my_model")

besceaLoadData <- function(data, 
                           text_field = text_field,
                           unique_id = unique_id,
                           modelname = NULL, 
                           searchname = "my_search", 
                           spacy_nlp_model = NULL, ...) {

  text_field_for_py <- text_field # Used to identify text column name for python
  unique_id_for_py <- unique_id # Used to identify text column name for python
  
  text_field <- rlang::enquo(text_field)
  unique_id <- rlang::enquo(unique_id)
  
  print("Checking Python modules...")

  pythonModulesCheck() # Check python modules
  
  dir.create("models")
  
  if (!exists("text_field")) { stop("you need to provide a text_field argument")}
  if (!exists("unique_id")) { stop("you need to provide a unique_id argument")}
  
  # If running through app this may be needed, cannot have null search name
  if (is.null(searchname)) {searchname = "my_search"}
  
  # If no model is named, run the model on this data and use the default name "my_model"
  if(is.null(modelname)) {
    modelname <- "my_model" 
    besceaBuildModel(data, 
                     text_field = text_field,
                     unique_id = unique_id,
                     spacy_nlp_model = spacy_nlp_model,
                     ...)
  }
  
  library(reticulate)
  
  # If user supplies a location for spacy then use it, otherwise use "en_core_web_sm"
  if (!is.null(spacy_nlp_model)) {py$spacy_nlp_model <- reticulate::r_to_py(spacy_nlp_model)
  
  print("Custom spacy model:")
  print(spacy_nlp_model)
  print("loading...")
  
  } else {py$spacy_nlp_model <- reticulate::r_to_py("en_core_web_sm") 
  print("Loading en_core_web_sm...")
  }
  
  # Required Parameters
  py$df_docs <- reticulate::r_to_py(data)
  py$text_column_name <- reticulate::r_to_py(gsub("~", "",(deparse(substitute(text_field_for_py)))))
  py$id_column_name <- reticulate::r_to_py(gsub("~", "",(deparse(substitute(unique_id_for_py)))))
  #py$id_column_name <- reticulate::r_to_py(unique_id)
  
  # Optional Parameters
  py$modelname <- reticulate::r_to_py(modelname)
  py$searchname <- reticulate::r_to_py(searchname)
  

  print("Loading new data...")
  reticulate::source_python("inst/python/besceaLoadData.py")
  
  print("Loading search function...")
  reticulate::source_python("inst/python/besceaSearch.py")
    
  # reticulate::source_python(paste0(system.file(package = utils::packageName()), "/python/besceaLoadData.py"))
  # reticulate::source_python(paste0(system.file(package = utils::packageName()), "/python/besceaSearch.py"))

}

