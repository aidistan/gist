# Analyze gene differential expression

use.packages('limma')

degTable <- function(gset, label, contrasts,
  selected.cols = c('Gene.symbol', 'AveExpr', 'logFC', 'adj.P.Val')
){
  # make proper column names to match toptable
  fvarLabels(gset) <- make.names(fvarLabels(gset))

  # log2 transform
  eset <- exprs(gset)
  q <- quantile(eset, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T)
  if (
    (q['99%'] > 100) || (q['100%'] - q['0%'] > 50 && q['25%'] > 0) ||
      (q['25%'] > 0 && q['25%'] < 1 && q['75%'] > 1 && q['75%'] < 2)
  ) {
    eset[which(eset <= 0)] <- 0
    eset[which(eset <= 0)] <- 0
    exprs(gset) <- log2(eset)
  }

  # use contrasts to select label
  groups <- unique(unlist(strsplit(contrasts, '-')))
  gset <- gset[, label %in% groups]
  label <- factor(label[label %in% groups], groups)

  # make design matrix
  design.matrix <- model.matrix(~ 0 + label)
  colnames(design.matrix) <- levels(label)

  # make contrast matrix
  contrast.matrix <- makeContrasts(contrasts = contrasts, levels = label)

  # get top table
  fit <- lmFit(gset, design.matrix)
  fit <- contrasts.fit(fit, contrast.matrix)
  fit <- eBayes(fit, 0.01)
  tT <- topTable(fit, adjust='fdr', sort.by='B', number=Inf)

  # drow lines without gene symbols
  tT <- tT[tT[, 'Gene.symbol'] != '',]
  # drow lines with multiple gene symbols
  tT <- tT[regexpr('///', tT[, 'Gene.symbol']) < 0,]
  # drow duplicated probes matched to one gene but with a higher p-value
  tT <- tT[!duplicated(tT[,'Gene.symbol']),]

  # return selected columns
  return(subset(tT, select = selected.cols))
}
