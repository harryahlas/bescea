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
#' besceaBuildModel(...)

besceaBuildModel <- function(data, 
                             text_field,
                             unique_id, 
                             modelname = "my_model",
                             min_word_count = 1,
                             epochs = 25,
                             spacy_nlp_model = "en_core_web_sm") {

  library(reticulate)
  
  # Required Parameters
  py$df <- reticulate::r_to_py(data)
  py$text_column_name <- reticulate::r_to_py(text_field)
  py$id_column_name <- reticulate::r_to_py(unique_id)
  
  # Optional Parameters
  py$modelname <- reticulate::r_to_py(modelname)
  py$min_fasttext_word_count <- reticulate::r_to_py(as.integer(min_word_count))
  py$fasttext_epochs <- reticulate::r_to_py(as.integer(epochs))
  py$spacy_nlp_model <- reticulate::r_to_py(spacy_nlp_model)
  
  print("building model")
  
  reticulate::source_python(paste0(system.file(package = packageName()), "/python/besceaBuildModel.py"))
  
}