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

# Or search within R
besceaSearch("guitar tune", 5)

# Or use DT 
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



### NEED TO GO THROUGH ALL SCENARIOS BELOW AGAIN

# V2 Tested successfully ----------------------------------------------------

source("besceaBuildModel.R")
source("besceaLoadData.R")
source("besceaSearch.R")

# Import small sample of data
data_for_search <- read.csv('C:/Users/hahla/Desktop/github/polyseis/data/sneap_text.csv')
sample_rows <- sample(1:nrow(data_for_search), 200)

# This can run on its own. Need to try with model as well
besceaLoadData(data = data_for_search[sample_rows,], 
               text_field = "thread_text",
               unique_id = "textid")

# Or search within R
besceaSearch("guitar tune", 5)


# V3 Tested successfully ----------------------------------------------------

source("besceaBuildModel.R")
source("besceaLoadData.R")
source("besceaSearch.R")

# Import small sample of data
data_for_search <- read.csv('C:/Users/hahla/Desktop/github/polyseis/data/sneap_text.csv')
sample_rows <- sample(1:nrow(data_for_search), 200)

# Load data and create model
besceaBuildModel(data = data_for_search[sample_rows,], 
                 text_field = "thread_text",
                 unique_id = "textid", 
                 min_word_count = 1,
                 epochs = 1, 
                 modelname = "buildmodelfirst")

# This can run on its own. Need to try with model as well
besceaLoadData(data = data_for_search[sample_rows,], 
               text_field = "thread_text",
               unique_id = "textid", 
               modelname = "buildmodelfirst", searchname = "usingbuildmodelfirst")

# Or search within R
besceaSearch("guitar tune", 5)


#Test Run app from scratch - Tested successfully -------------------------------

# Import small sample of data
data_for_search <- read.csv('C:/Users/hahla/Desktop/github/polyseis/data/sneap_text.csv')
sample_rows <- sample(1:nrow(data_for_search), 2000)

#source("besceaApp.R")

besceaApp(data = data_for_search[sample_rows,], 
          text_field = "thread_text",
          unique_id = "textid",
          epochs = 25,
          min_word_count = 3)


#Test Run app from scratch and specify arguments in app call - NOT Tested successfully -------------------------------

# Import small sample of data
data_for_search <- read.csv('C:/Users/hahla/Desktop/github/polyseis/data/sneap_text.csv')
sample_rows <- sample(1:nrow(data_for_search), 200)

source("besceaApp.R")

besceaApp(data = data_for_search[sample_rows,], 
          text_field = "thread_text",
          unique_id = "textid",
          min_word_count = 6,
          epochs = 3)


# Run app on previously saved model - Tested successfully ----------------------

# Import small sample of data
data_for_search <- read.csv('C:/Users/hahla/Desktop/github/polyseis/data/sneap_text.csv')
sample_rows <- sample(1:nrow(data_for_search), 200)

sneapsters <- data_for_search %>% 
  select(textid, post_text = thread_text) %>% 
  sample_n(2000)

sneapsters2 <- data.frame(sneapsters)

usethis::use_data(sneapsters, overwrite = T)
# source("besceaApp.R")

besceaApp(data = data_for_search[sample_rows,], 
          text_field = "thread_text",
          unique_id = "textid",
          modelname = "my_model", searchname = "test_search")


# Run app and switch count of output rows - Tested successfully ----------------

# Import small sample of data
data_for_search <- read.csv('C:/Users/hahla/Desktop/github/polyseis/data/sneap_text.csv')
sample_rows <- sample(1:nrow(data_for_search), 200)

besceaApp(data = sneapsters, 
          text_field = "post_text",
          unique_id = "textid",
          modelname = "buildmodelfirst",
          results_count = 30)



# Load a different spacy model from different location' - Tested successfully --

source("besceaBuildModel.R")
source("besceaLoadData.R")
source("besceaSearch.R")

# Import small sample of data
data_for_search <- read.csv('C:/Users/hahla/Desktop/github/polyseis/data/sneap_text.csv')
sample_rows <- sample(1:nrow(data_for_search), 200)

# Load data and create model
besceaBuildModel(data = data_for_search[sample_rows,], 
                 text_field = "thread_text",
                 unique_id = "textid", 
                 min_word_count = 1,
                 epochs = 1, 
                 modelname = "buildmodelfirst", 
                 spacy_nlp_model = "C:\\Users\\hahla\\Desktop\\Toss\\en_core_web_sm\\en_core_web_sm-2.3.1")

