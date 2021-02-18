# ### THIS MAY NOT BE NEEDED
# 
# # global reference (will be initialized in .onLoad)
# pandas <- NULL
# re <- NULL
# spacy <- NULL
# rank_bm25 <- NULL
# tqdm <- NULL
# pickle <- NULL
# numpy <- NULL
# gensim <- NULL
# os <- NULL
# nmslib <- NULL
# time <- NULL
# 
# 
# .onLoad <- function(libname, pkgname) {
#   # use superassignment to update global reference 
#   pandas <<- reticulate::import("pandas", delay_load = TRUE)
#   re <<- reticulate::import("re", delay_load = TRUE)
#   spacy <<- reticulate::import("spacy", delay_load = TRUE)
#   rank_bm25 <<- reticulate::import("rank_bm25", delay_load = TRUE)
#   tqdm <<- reticulate::import("tqdm", delay_load = TRUE)
#   pickle <<- reticulate::import("pickle", delay_load = TRUE)
#   numpy <<- reticulate::import("numpy", delay_load = TRUE)
#   gensim <<- reticulate::import("gensim", delay_load = TRUE)
#   os <<- reticulate::import("os", delay_load = TRUE)
#   nmslib <<- reticulate::import("nmslib", delay_load = TRUE)
#   time <<- reticulate::import("time", delay_load = TRUE)
#   
# }