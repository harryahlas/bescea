# bescea
#### Quick Smart Search Engine

Do a quick, smart search on texts of your choice. Ideal for survey comments. Input data should be an R data frmae with one id column and one text column.

```r
source("besceaApp.R")

besceaApp(data = data_for_search[sample_rows,], # data frame containing a text field and a unique id field 
          text_field = "thread_text",           # name of field containing text data
          unique_id = "textid")                 # name of unique id field
```

Requires RStudio (*reticulate* and *tidyverse* packages) and Python (*pandas*, *re*, *spacy*, *rank_bm25*, *tqdm*, *pickle*, *numpy*, *gensim*, and *nmslib* modules). 

Based heavily on the work of Josh Taylor:

https://towardsdatascience.com/how-to-build-a-search-engine-9f8ffa405eac
https://towardsdatascience.com/how-to-build-a-smart-search-engine-a86fca0d0795

