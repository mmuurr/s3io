#' @title Read a file in from AWS S3
#'
#' @param bucket [string] AWS S3 bucket name.
#' @param key [string] AWS S3 object key.
#' @param readfun [function] A read function where the first argument is a filepath.
#'        The function's signature should look like \code{readfun(file, ...)}.
#' @param ... Additional arguments forwarded on to \code{readfun}.
#' @param .localfile [string] The local filepath of the downloaded file.
#' @param .rm_localfile [boolean] Should the local filepath be deleted once it has been read?
#'        If \code{rm_localfile = TRUE}, then the read operation should read the entire file into memory.
#' @param .get_object_args [list] Additional optional args passed on to \code{awscli::s3api_get_object}.
#'
#' @return The returned value from \code{readfun}.
#' 
#' @examples
#' \dontrun{
#'   s3io_read("mybucket", "my/object/key.csv", readr::read_csv, col_names = TRUE)
#' }
s3io_read <- function(bucket, key,
                      readfun, ...,
                      .localfile = tempfile(),
                      .rm_localfile = TRUE,
                      .get_object_args = list()) {
    if(.rm_localfile) on.exit(try_file_remove(.localfile), add = TRUE)
    
    flog.debug("s3://%s/%s --> %s", bucket, key, .localfile)
    do.call(awscli::s3api_get_object, c(list(bucket, key, .localfile), .get_object_args))
    flog.debug("reading from %s", .localfile)
    readfun(.localfile, ...)
}

