besceaSearch <- function(search_query, results_count = NULL){
  
  if(!is.null(results_count)) {
    py$return_results_count <- r_to_py(as.integer(results_count))
  }
  
  return(py$besceaSearch(search_query))
}