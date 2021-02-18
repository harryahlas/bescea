#' Python Modules Check
#'
#' Check to see if required Python modules are installed and if not, send a message.
#' @keywords reticulate
#' @export
#' @examples
#' pythonModulesCheck()

pythonModulesCheck <- function() {
  
  missingModuleStopper <- function(module_name) {
    if (!reticulate::py_module_available(module_name)) {
      stop(paste0("The ", module_name, " Python package is not installed. Install it using cmd: 'pip install ", module_name, "'"))
    }
  }
  
  pythonModuleList <- list(
    "pandas",
    "re",
    "spacy",
    "rank_bm25",
    "tqdm",
    "pickle",
    "numpy",
    "gensim",
    "os",
    "nmslib",
    "time")

  lapply(pythonModuleList, missingModuleStopper)
}
