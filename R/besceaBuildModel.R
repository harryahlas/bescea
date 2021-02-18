#' Build bescea model
#'
#' Build bescea model
#' @param data
#' @param text_field
#' @param unique_id
#' @param modelname
#' @param min_word_count
#' @param epochs
#' @param spacy_nlp_model
#' @keywords text
#' @export
#' @examples
#' besceaBuildModel(data = sneapsters[1:100,], 
#'   text_field = "post_text",
#'   unique_id = "textid", 
#'   min_word_count = 1,
#'   epochs = 1, 
#'   modelname = "my_model")



besceaBuildModel <- function(data, 
                             text_field,
                             unique_id, 
                             modelname = "my_model",
                             min_word_count = 1,
                             epochs = 25,
                             spacy_nlp_model = NULL,
                             ...
                             ) {
  library(reticulate)
  
  # If SpaCy model is already loaded, juse it.
  # If user supplies a location for SpaCy then use it, 
  # otherwise use "en_core_web_sm"
  if (py_eval("'spacy_nlp_model' in locals() or 'spacy_nlp_model' in globals()")) {
    print("e1")
    NULL
  } else if (!is.null(spacy_nlp_model)) {
    print("e2")
    py$spacy_nlp_model <- reticulate::r_to_py(spacy_nlp_model)
  } else {py$spacy_nlp_model <-  reticulate::r_to_py("en_core_web_sm") }
  print("e3")
  print(spacy_nlp_model)
  
  pythonModulesCheck() # Check python modules
  
  library(reticulate)
  
  # Required Parameters
  py$df <- reticulate::r_to_py(data)
  py$text_column_name <- reticulate::r_to_py(text_field)
  py$id_column_name <- reticulate::r_to_py(unique_id)
  
  # Optional Parameters
  py$modelname <- reticulate::r_to_py(modelname)
  py$min_fasttext_word_count <- reticulate::r_to_py(as.integer(min_word_count))
  py$fasttext_epochs <- reticulate::r_to_py(as.integer(epochs))
  
  print("building model")
  
  reticulate::source_python(paste0(system.file(package = packageName()), "/python/besceaBuildModel.py"))
  
}