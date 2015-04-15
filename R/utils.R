# Install packages if not installed and require them in one line
use.packages <- function(packages) {
  new.packages <- packages[!(packages %in% installed.packages()[,'Package'])]
  if(length(new.packages)) install.packages(new.packages)
  for(pkg in packages) library(pkg, character.only = TRUE)
}
