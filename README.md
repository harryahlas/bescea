# bescea: Instant search engine for text

**Author:** Harry Ahlas

**License:** [MIT](https://opensource.org/licenses/MIT)

In a matter of a few minutes, build a quick, smart Shiny app to search through your own text data. Ideal for short user comments. Input data should be an R data frame with one id column and one text column. 

## Installation

If you have not used R's *reticulate* package, please see the requirements section below prior to installing.

```r
devtools::install_github("harryahlas/bescea")
```

## Run buscea

```r
library(bescea)
besceaApp(data = sneapsters, 
          text_field = "post_text",
          unique_id = "textid",
          results_count = 30)
```

![buscea search example](images/search2.png)

## Requirements

Requires RStudio (*reticulate* and *tidyverse* packages) and Python (*pandas*, *re*, *spacy*, *rank_bm25*, *tqdm*, *pickle*, *numpy*, *gensim*, and *nmslib* modules). 

## Acknowledgements

Based heavily on the work of Josh Taylor (https://twitter.com/josh_taylor_01):

https://towardsdatascience.com/how-to-build-a-search-engine-9f8ffa405eac

https://towardsdatascience.com/how-to-build-a-smart-search-engine-a86fca0d0795

