#' @title Try to remove a file
#'
#' @description Tries to safely remove a file by capturing and ignoring any errors.
#' 
#' @return \code{TRUE} if the removal was successfuly, \code{FALSE} otherwise.
try_file_remove <- function(filepath) {
  tryCatch({
    fs::file_delete(filepath)
    TRUE
  }, error = function(e) {
    FALSE
  })
}
