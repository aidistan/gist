# Install packages if not installed and require them in one line

use.packages <- function(...) {
  packages <- c(...)

  # Find uninstalled packages
  uninstalled <- packages[!(packages %in% installed.packages()[,'Package'])]

  # Try to install all uninstalled packages
  if(length(uninstalled)) {
    # Install from CRAN
    cran <- uninstalled[uninstalled %in% available.packages()[, 'Package']]
    if(length(cran)) install.packages(cran)

    # Install from BioConductor
    bioc <- uninstalled[!(uninstalled %in% available.packages()[, 'Package'])]
    if(length(bioc)) {
      source("http://bioconductor.org/biocLite.R")
      biocLite()
      biocLite(bioc)
    }
  }

  # Load all packages
  for(pkg in packages) library(pkg, character.only = TRUE)
}
