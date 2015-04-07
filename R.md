Add this function to .R file and require any R utils by `source.over.https(URL)`

```R
source.over.https <- function(url) {
  file <- tempfile()
  download.file(url, file, method="wget")
  source(file)
  unlink(file)
}
```
