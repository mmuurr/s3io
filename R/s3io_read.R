#' @title Read a file in from AWS S3
#'
#' @param bucket <chr(1)> AWS S3 bucket name.
#' @param key <chr(1)> AWS S3 object key.
#' @param readfun <function> A read function where the first argument is a filepath.
#'        The function's signature should look like \code{readfun(file, ...)}.
#' @param ... Additional arguments forwarded on to \code{readfun}.
#' @param .localfile <chr(1)> The local filepath of the downloaded file.
#' @param .rm_localfile <lgl(1)> Should the local filepath be deleted once it has been read?
#'        If \code{rm_localfile = TRUE}, then the read operation should read the entire file into memory.
#' @param .opts <dict> AWS CLI additional --opts, if not the default (from {awscli2}).
#'
#' @return The returned value from \code{readfun}.
#' 
#' @examples
#' \dontrun{
#'   s3io_read("mybucket", "my/object/key.csv", readr::read_csv, col_names = TRUE)
#' }
#' @export
## TODO: Possibly split .opts into .copy_opts and .aws_config to splice the values into the correct/expected positions in the final awscli command.
##       Same with s3io_write.
s3io_read <- function(bucket, key,
                      readfun, ...,
                      .localfile = fs::file_temp(), .rm_localfile = TRUE,
                      .opts = NULL) {
  if (isTRUE(.rm_localfile)) on.exit(try_file_remove(.localfile), add = TRUE)
  awscli2::awscli(
    c("s3api", "get-object"),
    "--bucket" = bucket,
    "--key" = key,
    .localfile,
    .config = .opts
  )
  readfun(.localfile, ...)
}
                      
  
