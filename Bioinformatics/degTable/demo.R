source('http://aidistan.github.io/gist/R/use.packages.R')
source('http://aidistan.github.io/gist/R/degTable.R')
use.packages(c('GEOquery'))

write.table(degTable(
  getGEO('GSE2669', destdir='.', GSEMatrix=TRUE, AnnotGPL=TRUE)[[1]],
  label = read.table('GSE2669.tab', header = T, row.names = 1, sep = "\t")[colnames(gset), 2],
  contrasts = c('I-CG')
), file='result.txt', row.names=FALSE, quote=FALSE, sep="\t")