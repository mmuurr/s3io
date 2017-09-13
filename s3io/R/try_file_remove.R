try_file_remove <- function(filepath) {
    flog.debug("removing %s", filepath)
    try(file.remove(filepath))
}
