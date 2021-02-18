#' Download Sneaplarge Data Set
#'
#' (Placeholder function - does not currently work.) Load data from github. Installs into models folder.
#' @keywords text data sneap
#' @export
#' @examples
#' downloadSneapLarge()


downloadSneaplarge <- function() {
  download.file(url = "https://raw.githubusercontent.com/harryahlas/bescea/main/models/_fasttext_sneaplarge_.model",
                destfile = "models/_fasttext_sneaplarge_.model")
  
  download.file(url = "https://raw.githubusercontent.com/harryahlas/bescea/main/models/_fasttext_sneaplarge_.model.trainables.vectors_ngrams_lockf.npy",
                destfile = "models/_fasttext_sneaplarge_.model.trainables.vectors_ngrams_lockf.npy")
  
  download.file(url = "https://raw.githubusercontent.com/harryahlas/bescea/main/models/_fasttext_sneaplarge_.model.wv.vectors_ngrams.npy",
                destfile = "models/_fasttext_sneaplarge_.model.wv.vectors_ngrams.npy")
  
}
