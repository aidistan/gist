library(ggplot2)
library(reshape2)
library(ggdendro)
library(grid)
library(gridExtra)

# Example data
data <- matrix(
  data = runif(60 * 48), nrow = 48, ncol = 60,
  dimnames = list(
    Row = paste('Row', 1:48),
    Column = paste('Col', 1:60)
  )
)
labels <- matrix(
  data = round(runif(180, min = 1, max = 4)), nrow = 3, ncol = 60,
  dimnames = list(
    Feature = c('Label 1', 'Label 2', 'Label 3'),
    Column = colnames(data)
  )
)

# Cluster results
row_cr <- hclust(dist(data))
col_cr <- hclust(dist(t(data)))
data <- data[row_cr$order, col_cr$order]
labels <- labels[,col_cr$order]

# Heatmap
dim_names <- dimnames(data)
dimnames(data) <- list(row = 1:nrow(data), column = 1:ncol(data))
gHeatmap <- ggplotGrob(
  ggplot(melt(data))
    + geom_tile(aes(x = column, y = row, fill = value), color = 'white', size = 1)
    + labs(title = NULL, x = NULL, y = NULL)
    + scale_fill_gradient(low = 'white', high = 'steelblue', guide = 'none')
    + scale_x_continuous(expand = c(0, 0))
    + scale_y_continuous(expand = c(0, 0))
    + theme(
      axis.ticks = element_line(size = 0),
      axis.text = element_text(size = 0)
    )
#     + scale_x_continuous(expand = c(0, 0), labels = dim_names[[2]], breaks=1:length(dim_names[[2]]))
#     + scale_y_continuous(expand = c(0, 0), labels = dim_names[[1]], breaks=-1:-length(dim_names[[1]]))
#     + theme(
#       axis.text.x = element_text(size = 16, angle = 90, vjust = 0.5),
#       axis.text.y = element_text(size = 16, angle =  0, hjust = 1)
#     )
)

# Column labels
dim_names <- dimnames(labels)
dimnames(labels) <- list(row = -1:-nrow(labels), column = 1:ncol(labels))
gColLabels <- ggplotGrob(
  ggplot(melt(labels))
    + geom_tile(aes(x = column, y = row, fill = factor(value)), color = 'white', size = 1)
    + labs(title = NULL, x = NULL, y = NULL)
    + scale_fill_brewer(palette = 'Set2', guide = 'none')
    + scale_x_continuous(expand = c(0, 0))
    + scale_y_continuous(expand = c(0, 0))
    + theme(
      axis.ticks = element_line(size = 0),
      axis.text = element_text(size = 0)
    )
#     + scale_x_continuous(expand = c(0, 0), labels = dim_names[[2]], breaks=1:length(dim_names[[2]]))
#     + scale_y_continuous(expand = c(0, 0), labels = dim_names[[1]], breaks=-1:-length(dim_names[[1]]))
#     + theme(
#       axis.text.x = element_text(size = 16, angle = 90, hjust = 0),
#       axis.text.y = element_text(size = 16, angle =  0, hjust = 1)
#     )
)
gColLabelTicks <- ggplotGrob(
  ggplot(melt(labels))
    + geom_tile(aes(x = column, y = row), color = 'white', fill = 'white')
    + labs(title = NULL, x = NULL, y = NULL)
    + scale_x_continuous(expand = c(0, 0))
    + scale_y_continuous(expand = c(0, 0), labels = dim_names[[1]], breaks=-1:-length(dim_names[[1]]))
    + theme(
      axis.ticks = element_line(size = 0),
      axis.text = element_text(size = 0),
      axis.text.y = element_text(size = 16, angle =  0, hjust = 1)
    )
)

# Dendrograms
col_cr <- dendro_data(col_cr)
gColDendro <- ggplotGrob(
  ggdendrogram(col_cr) +
    labs(title = NULL, x = NULL, y = NULL) +
    scale_x_continuous(
      expand = c(0, 0), limits = c(0.5, nrow(col_cr$labels) + 0.5),
      breaks = seq_along(col_cr$labels$label), labels = col_cr$labels$label
    ) +
    theme(
      axis.text.x = element_text(size = 16),
      axis.text.y = element_text(size = 0)
    )
)
row_cr <- dendro_data(row_cr)
gRowDendro <- ggplotGrob(
  ggdendrogram(row_cr, rotate = T) +
    labs(title = NULL, x = NULL, y = NULL) +
    scale_x_continuous(
      expand = c(0, 0), limits = c(0.5, nrow(row_cr$labels) + 0.5),
      breaks = seq_along(row_cr$labels$label), labels = row_cr$labels$label
    ) +
    theme(
      axis.text.x = element_text(size = 0),
      axis.text.y = element_text(size = 16)
    )
)

# Plot
grid.arrange(
  gColDendro, nullGrob(), gColLabels, gColLabelTicks, gHeatmap, gRowDendro,
  nrow = 3, ncol = 2, widths = c(4, 1), heights = c(4, nrow(labels), nrow(data))
)
