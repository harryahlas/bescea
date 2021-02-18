#' Search Text
#'
#' Function to search bescea model
#' @param search_query search query
#' @param results_count how many docs to return
#' @keywords text
#' @export
#' @examples
#' besceaSearch("hello")

besceaSearch <- function(search_query, results_count = 50){
  return(py$besceaSearch(search_query, reticulate::r_to_py(as.integer(results_count))))
}