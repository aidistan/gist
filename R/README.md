# R

1. Add this function at first

  ```R
  source.over.https <- function(url) {
    file <- tempfile()
    download.file(url, file, method="wget")
    source(file)
    unlink(file)
  }
  ```

2. Require any R script by `source.over.https(URL)`

  ```R
  source.over.https('https://raw.githubusercontent.com/aidistan/gist/master/R/utils.R')
  ```
