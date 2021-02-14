# bescea
#### Quick Smart Search Engine

Do a quick, smart search on texts of your choice. Ideal for survey comments. Not suitable for long documents unless they are split out into smaller sections. Input data should be an R data frame with one id column and one text column.

```r
source("besceaApp.R")

df <- read.csv('data/sneap_sample_text.csv')

besceaApp(data = df,                      # data frame containing a text field and a unique id field 
          text_field = "thread_text",     # name of field containing text data
          unique_id = "textid")           # name of unique id field
```

Requires RStudio (*reticulate* and *tidyverse* packages) and Python (*pandas*, *re*, *spacy*, *rank_bm25*, *tqdm*, *pickle*, *numpy*, *gensim*, and *nmslib* modules). 

Based heavily on the work of Josh Taylor (https://twitter.com/josh_taylor_01):

https://towardsdatascience.com/how-to-build-a-search-engine-9f8ffa405eac

https://towardsdatascience.com/how-to-build-a-smart-search-engine-a86fca0d0795

