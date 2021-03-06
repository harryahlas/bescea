#' Build bescea model
#'
#' Build bescea model from a data frame containing a single text column and unique identifier column.
#' @param data Data frame, each document is a row/observation.
#' @param text_field Text field from data, unquoted
#' @param unique_id Unique identifier from data, unquoted
#' @param modelname Your model name, to be referred to when loading new data. The model will be saved as 3 different files in the 'models' folder.  This value will be the *modelname* arguement when running this model with *besceaLoadData()* or *besceaApp()*. 
#' @param min_word_count Only consider tokens with at least n occurrences in the corpus
#' @param epochs Number of FastText epochs. More is generally better but takes longer.
#' @param spacy_nlp_model Defaults to *NULL*.  When Python is run, SpaCy will load "en_core_web_sm" unless this argument is present. In that case, SpaCy will look for an nlp model in the location you provide. 
#' @param ... Arguments passed from other functions
#' @keywords text search engine
#' @export
#' @examples
#' besceaBuildModel(data = sneapsters[1:100,], 
#'   text_field = post_text,
#'   unique_id = textid, 
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
#print(text_field)
  text_field <- rlang::enquo(text_field)
  unique_id <- rlang::enquo(unique_id)

  text_field_for_py <- gsub("~|\"", "",deparse(substitute(text_field))) # Used to identify text column name for python
  unique_id_for_py <- gsub("~|\"", "",deparse(substitute(unique_id))) # Used to identify text column name for python

  dir.create("models")
  library(reticulate)
  
  # If SpaCy model is already loaded, juse it.
  # If user supplies a location for SpaCy then use it, 
  # otherwise use "en_core_web_sm"
  if (reticulate::py_eval("'spacy_nlp_model' in locals() or 'spacy_nlp_model' in globals()")) {
    print("SpaCy model already loaded")
    NULL
  } else if (!is.null(spacy_nlp_model)) {
    print("Loading SpaCy from custom location...")
    py$spacy_nlp_model <- reticulate::r_to_py(spacy_nlp_model)
  } else {py$spacy_nlp_model <-  reticulate::r_to_py("en_core_web_sm") }
  print("Loading Spacy model...")
  print(spacy_nlp_model)
  
  print("Checking Python modules...")
  pythonModulesCheck() # Check python modules
  
  # Required Parameters
  # Though gsub has already been used once above, we need it here again for when besceaBuildModel() is run standalone.
  py$df_docs <- reticulate::r_to_py(data)
  py$text_column_name <- reticulate::r_to_py(gsub("~|\"", "",(deparse(substitute(text_field_for_py))))) 
  py$id_column_name <- reticulate::r_to_py(gsub("~|\"", "",(deparse(substitute(unique_id_for_py)))))

  # Optional Parameters
  py$modelname <- reticulate::r_to_py(modelname)
  py$min_fasttext_word_count <- reticulate::r_to_py(as.integer(min_word_count))
  py$fasttext_epochs <- reticulate::r_to_py(as.integer(epochs))
  
  print("Building model...")
  # reticulate::source_python("inst/python/besceaBuildModel.py")
  reticulate::source_python(paste0(system.file(package = utils::packageName()), "/python/besceaBuildModel.py"))
  
}