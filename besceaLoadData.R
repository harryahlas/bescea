besceaLoadData <- function(data, 
                           text_field = text_field,
                           unique_id = unique_id, 
                           modelname = NULL, 
                           searchname = "my_search") {
  
  if (!exists("text_field")) { stop("you need to provide a text_field argument")}
  if (!exists("unique_id")) { stop("you need to provide a unique_id argument")}
  
  # If running through app this may be needed, cannot have null search name
  if (is.null(searchname)) {searchname = "my_search"}
  
  # If no model is named, run the model on this data and use the default name "my_model"
  if(is.null(modelname)) {
    modelname <- "my_model" 
    besceaBuildModel(data, 
                     text_field = text_field,
                     unique_id = unique_id)
  }
  
  # # If no searchname then call it "my_search"
  # if(is.null(searchname)) {searchname = "my_search"}
  
  library(reticulate)
  
  # Required Parameters
  py$df_docs <- r_to_py(data)
  py$text_column_name <- r_to_py(text_field)
  py$id_column_name <- r_to_py(unique_id)
  
  # Optional Parameters
  py$modelname <- r_to_py(modelname)
  py$searchname <- r_to_py(searchname)
  #py$return_results_count <- r_to_py(as.integer(results_count))
  # py$min_fasttext_word_count <- r_to_py(as.integer(min_word_count))
  # py$fasttext_epochs <- r_to_py(as.integer(epochs))
  
  source_python("besceaLoadData.py")
  source_python("besceaSearch.py")
  
}

