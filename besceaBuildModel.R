# Build bescea model

besceaBuildModel <- function(data, 
                             text_field,
                             unique_id, 
                             modelname = "my_model",
                             min_word_count = 1,
                             epochs = 25) {

  library(reticulate)
  
  # Required Parameters
  py$df <- r_to_py(data)
  py$text_column_name <- r_to_py(text_field)
  py$id_column_name <- r_to_py(unique_id)
  
  # Optional Parameters
  py$modelname <- r_to_py(modelname)
  py$min_fasttext_word_count <- r_to_py(as.integer(min_word_count))
  py$fasttext_epochs <- r_to_py(as.integer(epochs))
  
  print("building model")
  
  source_python("besceaBuildModel.py")
  
}