# bescea: Instant text search engine

**Author:** Harry Ahlas

**License:** [MIT](https://opensource.org/licenses/MIT)

In a matter of a few minutes, build a quick, smart Shiny app to search through your own text data. Ideal for short user comments. Input data should be an R data frame with one id column and one text column. 

## Installation

```r
devtools::install_github("harryahlas/bescea")
```

If you have not used R's *reticulate* package, please see the requirements section below prior to installing.

## Run buscea

```r
library(bescea)
besceaApp(data = sneapsters,         # data frame. each document is a row/observation.
          text_field = "post_text",  # text field from data frame
          unique_id = "textid")      # unique identifier from data frame
```

## Shiny App

The code above first tokenizes your text using [SpaCy](https://spacy.io/), then generates a [fastText](https://fasttext.cc/) model. It uses [BM25Okapi](https://github.com/dorianbrown/rank_bm25) as a searching tool.  Finally, it generates a [Shiny](https://shiny.rstudio.com/) app in your browser to search your text.  You can download an .xlsx file of your results by clicking the *Download* button.

![buscea search example](images/search2.png)

## Build Model

You have the option to run and save your own *fastText* model for use with other searches. This will speed up runtimes and often improve results. 

## Requirements

Requires RStudio (*reticulate* and *tidyverse* packages) and Python (*pandas*, *re*, *spacy*, *rank_bm25*, *tqdm*, *pickle*, *numpy*, *gensim*, and *nmslib* modules). 

## Acknowledgements

This work is based **heavily** on foundational code provided by Josh Taylor (https://twitter.com/josh_taylor_01). 

- https://towardsdatascience.com/how-to-build-a-search-engine-9f8ffa405eac
- https://towardsdatascience.com/how-to-build-a-smart-search-engine-a86fca0d0795

