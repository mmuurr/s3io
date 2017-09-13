## Assumes readfun has sig: readfun(file, ...)
## If rm_localfile = TRUE (the default), then the read operation must *read the file into memory in entirety*.
s3io_read <- function(bucket, key,
                      readfun, ...,
                      localfile = tempfile(), rm_localfile = TRUE) {
    tryCatch({
        flog.debug("s3://%s/%s --> %s", bucket, key, localfile)
        awscli::s3api_get_object(bucket, key, localfile)
        flog.debug("reading from %s", localfile)
        RV <- readfun(localfile, ...)
    }, finally = {
        if(rm_localfile) try_file_remove(localfile)
    })
    return(RV)
}

