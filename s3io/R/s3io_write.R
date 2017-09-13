## Assumes writefun is of signatute: writefun(obj, file, ...)
## Works for most readr write functions, write.csv, write.csv2, write.table, Matrix::writeMM.
s3io_write <- function(obj, bucket, key,
                       writefun, ...,
                       localfile = tempfile(), rm_localfile = TRUE) {
    tryCatch({
        flog.debug("writing to %s", localfile)
        RV <- writefun(obj, localfile, ...)
        flog.debug("%s --> s3://%s/%s", localfile, bucket, key)
        awscli::s3api_put_object(localfile, bucket, key)
    }, finally = {
        if(rm_localfile) try_file_remove(localfile)
    })
    return(RV)
}
