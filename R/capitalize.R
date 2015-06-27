# Capitalize the first letter of a string

capitalize <- function(str) {
  paste(toupper(substring(str, 1,1)), substring(str, 2), sep = '', collapse = '')
}
