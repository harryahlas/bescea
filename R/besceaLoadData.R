#' Load new data to bescea model
#'
#' Load new data to bescea model for seawrching
#' @param data
#' @param text_field
#' @param unique_id
#' @param modelname
#' @param searchname
#' @keywords text
#' @export
#' @examples
#' besceaLoadData(...)

besceaLoadData <- function(data, 
                           text_field = text_field,
                           unique_id = unique_id, 
                           modelname = NULL, 
                           searchname = "my_search", ...) {
  
  pythonModulesCheck() # Check python modules
  
  if (!exists("text_field")) { stop("you need to provide a text_field argument")}
  if (!exists("unique_id")) { stop("you need to provide a unique_id argument")}
  
  # If running through app this may be needed, cannot have null search name
  if (is.null(searchname)) {searchname = "my_search"}
  
  # If no model is named, run the model on this data and use the default name "my_model"
  if(is.null(modelname)) {
    modelname <- "my_model" 
    besceaBuildModel(data, 
                     text_field = text_field,
                     unique_id = unique_id, ...)
  }
  
  library(reticulate)
  
  # Required Parameters
  py$df_docs <- reticulate::r_to_py(data)
  py$text_column_name <- reticulate::r_to_py(text_field)
  py$id_column_name <- reticulate::r_to_py(unique_id)
  
  # Optional Parameters
  py$modelname <- reticulate::r_to_py(modelname)
  py$searchname <- reticulate::r_to_py(searchname)
  
  reticulate::source_python(paste0(system.file(package = packageName()), "/python/besceaLoadData.py"))
  reticulate::source_python(paste0(system.file(package = packageName()), "/python/besceaSearch.py"))

}

