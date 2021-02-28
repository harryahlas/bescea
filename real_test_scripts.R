library(bescea)
besceaBuildModel(data = sneapsters[1:100,], 
                 text_field = post_text,
                 unique_id = textid, 
                 min_word_count = 1,
                 epochs = 1, 
                 modelname = "my_model")

besceaLoadData(data = sneapsters[1:100,], 
               text_field = post_text,
               unique_id = textid,
               modelname = "my_model")

besceaSearch("hello")

besceaApp(data = sneapsters[1:100,], 
          text_field = post_text,
          unique_id = textid,
          searchname = "test_search",
          epochs = 1)


library(tidyverse)
besceaApp(data = bescea::sneapsters %>% 
            add_row(textid = 9999998, post_text = NA)%>% 
            add_row(textid = 9999999, post_text = " "), 
          text_field = post_text,
          unique_id = textid,
          modelname = "sneaplargeREAL")
