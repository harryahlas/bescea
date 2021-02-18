#' Load new data to bescea model
#'
#' Load new data to bescea model for searching
#' @param data
#' @param text_field
#' @param unique_id
#' @param modelname
#' @param searchname
#' @keywords text
#' @export
#' @examples
#' # Build model called "my_model" first
#' besceaBuildModel(data = sneapsters[1:100,], 
#'   text_field = "post_text",
#'   unique_id = "textid", 
#'   min_word_count = 1,
#'   epochs = 1, 
#'   modelname = "my_model")
#'   
#' # Then load data and run using "my_model"  
#' besceaLoadData(data = sneapsters[1:100,], 
#'   text_field = "post_text",
#'   unique_id = "textid",
#'   modelname = "my_model")


besceaLoadData <- function(data, 
                           text_field = text_field,
                           unique_id = unique_id, 
                           modelname = NULL, 
                           searchname = "my_search", 
                           spacy_nlp_model = NULL, ...) {
  
  pythonModulesCheck() # Check python modules
  
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
  
  print("this is the spacy model:")
  print(spacy_nlp_model)
  print("move on")
  
  }
  else {py$spacy_nlp_model <- reticulate::r_to_py("en_core_web_sm") 
  print("acutally this")
  }
  
  # Required Parameters
  py$df_docs <- reticulate::r_to_py(data)
  py$text_column_name <- reticulate::r_to_py(text_field)
  py$id_column_name <- reticulate::r_to_py(unique_id)
  
  # Optional Parameters
  py$modelname <- reticulate::r_to_py(modelname)
  py$searchname <- reticulate::r_to_py(searchname)
  
  reticulate::source_python(paste0(system.file(package = packageName()), "/python/besceaLoadData.py"))
  reticulate::source_python(paste0(system.file(package = packageName()), "/python/besceaSearch.py"))

}

