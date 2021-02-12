source("besceaLoad.R")
source("besceaApp.R")
source("besceaSearch.R")

# Import small sample of data
data_for_search <- read.csv('C:/Users/hahla/Desktop/github/polyseis/data/sneap_text.csv')
sample_rows <- sample(1:nrow(data_for_search), 2000)

# Load data and create model
besceaLoad(data = data_for_search[sample_rows,], 
           text_field = "thread_text",
           unique_id = "textid", 
           min_word_count = 3,
           epochs = 1)

# Run shiny app. 
# Run only in your browser and close from your browser as it may cause R to crash if you close it in R/RStudio
besceaApp(50) 

# Or do a manual run
besceaSearch("guitar tune", 5)

DT::datatable(besceaSearch("amp cab speaker cone"))



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
py_run_string("fasttext_epochs = 1")


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
