
library(bescea)
setwd("C:/Users/hahla/Desktop/github/bescea")

# Run normal
besceaApp(data = sneapsters[1:100,], 
          text_field = "post_text",
          unique_id = "textid",
          epochs = 1,
          min_word_count = 1,
          searchname = "test_search")

# Run without default spacy install
file.rename("C:\\Users\\hahla\\miniconda3\\Lib\\site-packages\\en_core_web_sm", "C:\\Users\\hahla\\miniconda3\\Lib\\site-packages\\en_core_web_smxxxx")
besceaApp(data = sneapsters[1:100,], 
          text_field = "post_text",
          unique_id = "textid",
          modelname = "my_model", 
          searchname = "test_search",
          spacy_nlp_model = "C:\\Users\\hahla\\Desktop\\Toss\\en_core_web_sm\\en_core_web_sm-2.3.1")
file.rename("C:\\Users\\hahla\\miniconda3\\Lib\\site-packages\\en_core_web_smxxxx", "C:\\Users\\hahla\\miniconda3\\Lib\\site-packages\\en_core_web_sm")

# Run from scratch with different spacy model
besceaApp(data = sneapsters[1:100,], 
          text_field = "post_text",
          unique_id = "textid",
          #modelname = "my_model", 
          searchname = "test_search",
          epochs = 1,
          spacy_nlp_model = "C:\\Users\\hahla\\Desktop\\Toss\\en_core_web_sm\\en_core_web_sm-2.3.1")

# Run data load only
besceaLoadData(data = sneapsters[1:100,], 
               text_field = "post_text",
               unique_id = "textid",
               modelname = "my_model", 
               searchname = "test_search",
               spacy_nlp_model = "C:\\Users\\hahla\\Desktop\\Toss\\en_core_web_sm\\en_core_web_sm-2.3.1")


