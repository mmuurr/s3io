#' @title Write a file to AWS S3
#' @param obj <anything> The object to write.
#' @param bucket <chr(1)> AWS S3 bucket name.
#' @param key <chr(1)> AWS S3 object key.
#' @param writefun <function> A write function where the first argument is the object to write and the second argument is a filepath.
#'        The function's signature should look like \code{writefun(obj, file, ...)}.
#' @param ... Additional arguments passed on to \code{writefun}.
#' @param .localfile <chr(1)> The local filepath for the initial write-to-disk.
#' @param .rm_localfile <lgl(1)> Remove \code{localfile} once the copy-to-S3 is complete?
#' @param .opts <dict> Additional --opts for the AWS CLI `aws s3api put-object` command.
#'        A common option you may want to specify, e.g., is content-type: \code{.opts = list("content-type" = "application/json")}.
#' @return The returned value from \code{writefun}.
#' @examples
#' \dontrun{
#'   s3io_write(iris, "mybucket", "my/object/key.csv", readr::write_csv, col_names = TRUE)
#' }
#' @export
## TODO: Possibly split .opts into .copy_opts and .aws_config to splice the values into the correct/expected positions in the final awscli command.
##       Same with s3io_read.
s3io_write <- function(obj, bucket, key,
                       writefun, ...,
                       .localfile = fs::file_temp(), .rm_localfile = TRUE,
                       .opts = NULL) {
  if (isTRUE(.rm_localfile)) on.exit(try_file_remove(.localfile), add = TRUE)
  retval <- withVisible(writefun(obj, .localfile, ...))
  retval <- if (isTRUE(retval$visible)) retval$value else invisible(retval$value)
  awscli2::awscli(
    c("s3api", "put-object"),
    "--bucket" = bucket,
    "--key" = key,
    "--body" = .localfile,
    .config = .opts
  )
  retval
}
