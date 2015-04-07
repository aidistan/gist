# Install packages if not installed and require them all
use.packages <- function(list) {
  new.packages <- list[!(list %in% installed.packages()[,'Package'])]
  if(length(new.packages)) install.packages(new.packages)
  for(pkg in list ) library(pkg, character.only = TRUE)
}
