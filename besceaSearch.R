besceaSearch <- function(search_query, results_count = 50){
  
  # if(!is.null(results_count)) {
  #   py$return_results_count <- r_to_py(as.integer(results_count))
  # } else (
  #   py$return_results_count <- 50
  # )
  
  return(py$besceaSearch(search_query, r_to_py(as.integer(results_count))))
}