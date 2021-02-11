library(reticulate)


# Required Parameters
#py_run_string("csv_file_location = 'data/sneap_sample_text.csv'")
py_run_string("csv_file_location = 'C:/Users/hahla/Desktop/github/polyseis/data/sneap_text.csv'")
py_run_string("searchname = 'sample_search4'")
py_run_string("text_column_name = 'thread_text'")
py_run_string("id_column_name = 'textid'")

# Optional Parameters
py_run_string("return_results_count = 10")
py_run_string("min_fasttext_word_count = 3") # only consider tokens with at least n occurrences in the corpus
py_run_string("fasttext_epochs = 25")


source_python("bescea.py")
# py$besceaSearch("post music guitar amp settings")
# py$besceaSearch("music download online")

library(tidyverse)
py$besceaSearch("mic position cone") %>% 
  DT::datatable()


zz <- py$weighted_doc_vects 
repl_python()

library(tidyverse)

x <- read_csv("C:\\Users\\hahla\\Desktop\\github\\polyseis\\data\\sneap_text.csv") %>% 
  #select(text_id = X1, thread_text) %>% 
  filter(!is.na(thread_text),
         nchar(thread_text) > 10) 
dir.create("data")

write_csv(x, "C:\\Users\\hahla\\Desktop\\github\\polyseis\\data\\sneap_text.csv")


repl_python()
