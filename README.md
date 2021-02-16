# bescea
#### Instant Search Engine

In a matter of a few minutes, build a quick, smart search on texts of your choice. Ideal for short user comments. Not suitable for long documents unless they are split out into smaller sections. Input data should be an R data frame with one id column and one text column.

```r
besceaApp(data = sneapsters, 
          text_field = "post_text",
          unique_id = "textid",
          results_count = 30)
```

![buscea search example](images/search2.png)

Requires RStudio (*reticulate* and *tidyverse* packages) and Python (*pandas*, *re*, *spacy*, *rank_bm25*, *tqdm*, *pickle*, *numpy*, *gensim*, and *nmslib* modules). 

Based heavily on the work of Josh Taylor (https://twitter.com/josh_taylor_01):

https://towardsdatascience.com/how-to-build-a-search-engine-9f8ffa405eac

https://towardsdatascience.com/how-to-build-a-smart-search-engine-a86fca0d0795

