# Load data, build bescea model
# Data should have a single text column and unique identifier
# text_field and unique_id are both required and should be in quotes
# results_count  is the number of results to be returned for each search.  Can also be specified in besceaSearch() function
# min_word_count  only consider tokens with at least n occurrences in the corpus
# epochs is the number of epochs to train the fasttext model



besceaLoad <- function(data, 
                       text_field,
                       unique_id,
                       search_name = "sample_search",
                       results_count = 25,
                       min_word_count = 3,
                       epochs = 20) {
  
  library(reticulate)
  
  # Required Parameters
  py$df <- r_to_py(data)
  py$text_column_name <- r_to_py(text_field)
  py$id_column_name <- r_to_py(unique_id)
  
  # Optional Parameters
  py$searchname <- r_to_py(search_name)
  py$return_results_count <- r_to_py(as.integer(results_count))
  py$min_fasttext_word_count <- r_to_py(as.integer(min_word_count))
  py$fasttext_epochs <- r_to_py(as.integer(epochs))
  
  # #py_run_string("csv_file_location = 'C:/Users/hahla/Desktop/github/polyseis/data/sneap_text.csv'")
  # py_run_string("searchname = 'sample_search4'")
  # py_run_string("text_column_name = 'thread_text'")
  # py_run_string("id_column_name = 'textid'")
  # 
  # py_run_string("return_results_count = 10")
  # py_run_string("min_fasttext_word_count = 3") # only consider tokens with at least n occurrences in the corpus
  # py_run_string("fasttext_epochs = 1")
  
  py_run_file("bescea.py") # Run model
  
}
