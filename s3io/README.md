# s3io

The s3io package provides some lightweight tooling to read and write to/from AWS S3 locations.

## R <--> Localfile <--> AWS S3

For output operations, the general paradigm is:
 1. data is first written to a local file, then
 2. that local file is 'put' to AWS S3.

For read operations, the order is reversed and first:
 1. an AWS S3 'get' writes data to a local file, then
 2. R reads the contents of that local file.

This implies that (for both read and write cases) enough disk space must be available for the local file.
The default arguments specify that the local file is a tempfile (via R's `tempfile()`), and that the temp file is removed once the read or write has completed.

## Usage

Both `s3io_read()` and `s3io_write()` are just wrappers around an underlying reader or writer function which must be specified by the user.
The underlying reader function should take the form:
```R
function(obj, file, ...)
```
and the writer function should take the form:
```R
function(file, ...)
```

Here's an example session where the iris table is first written to, then read in from an S3 location:
```R
> s3io_write(iris, bucket = "bktname", key = "the/key.csv", readr::write_csv, col_names = FALSE)
> foo <- s3io_read("bktname", "the/key.csv", readr::read_csv, col_names = FALSE)
```
In the example, `readr::read_csv()` and `readr::write_csv()` serve as the underlying readre and writer functions.
Other common readers and writers might be `write.csv()`, `read.delim()`, `write.table()`, `readRDS()`, `saveRDS()`, etc.
In cases where a reader or writer doesn't meet the required signature, the user can create her own wrapper, like so:
```R
## this function can't be used directly by s3io_write:
> my_new_writer <- function(file, obj) { ... }
## but we can wrap it:
> my_newer_writer <- function(obj, file) my_new_writer(file, obj)
## and now we can use it with s3io_write:
> s3io_write(obj, bucket, key, my_newer_writer)
```

## AWS Credentials

The s3io package uses the awscli package and thus relies on the standard AWS CLI toolkit conventions to handle permissions/credentials/IAM decisions.
