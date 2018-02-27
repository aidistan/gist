source('https://aidistan.github.io/gist/R/use.packages.R')
use.packages('ggplot2', 'reshape2', 'ggdendro', 'grid', 'gridExtra')

ggheatmap <- function (
  data, labels = NULL, row.cluster = FALSE, col.cluster = FALSE,
  heatmap.compact = FALSE, heatmap.scale = NULL
) {

  #
  # Preprocess labels
  #

  if (class(labels) %in% c('matrix', 'data.frame')) {
    label_names <- rownames(labels)
    names(label_names) <- label_names
    labels <- lapply(label_names, function (name) { labels[name,] })
  }

  if (class(labels) == 'list') {
    labels <- lapply(labels, function(label) {
      if (class(label) == 'list') {
        label
      } else {
        list(data = label, scale =
          if (class(label) == 'factor') {
            scale_fill_brewer(palette = 'Set2')
          } else if (min(label, na.rm = T) >= 0) {
            scale_fill_gradient(low = 'white', high = 'steelblue')
          } else {
            scale_fill_gradient2(low = '#1010f0', mid = 'white', high = '#f01010', midpoint = 0)
          }
        )
      }
    })
  }

  #
  # Cluster
  #

  if (row.cluster) {
    row_cr <- hclust(dist(data))
    data <- data[row_cr$order,]
  }

  if (col.cluster) {
    col_cr <- hclust(dist(t(data)))
    data <- data[,col_cr$order]
    for (name in names(labels)) {
      labels[[name]]$data <- labels[[name]]$data[col_cr$order]
    }
  }

  #
  # Heatmap
  #

  gHeatmap <- ggplot(melt(matrix(
    data = as.matrix(data), nrow = nrow(data), ncol = ncol(data),
    dimnames = list(row = 1:nrow(data), column = 1:ncol(data))
  )))

  gHeatmap <- gHeatmap +
    if (heatmap.compact) {
      geom_tile(aes(x = column, y = row, fill = value), size = 1)
    } else {
      geom_tile(aes(x = column, y = row, fill = value), size = 1, color = 'white')
    }

  gHeatmap <- gHeatmap +
    labs(title = NULL, x = NULL, y = NULL) +
    scale_x_continuous(expand = c(0, 0), labels = colnames(data), breaks=1:ncol(data)) +
    scale_y_reverse(expand = c(0, 0), labels = rownames(data), breaks=1:nrow(data)) +
    theme(
      legend.title = element_blank(),
      axis.ticks = element_blank(),
      axis.text.x = element_text(size = 13, angle = 90, vjust = 0.5, hjust = 0),
      axis.text.y = element_text(size = 13, angle =  0, vjust = 0.5, hjust = 0)
    )

  gHeatmap <- gHeatmap +
    if (!is.null(heatmap.scale)) {
      heatmap.scale
    } else if (min(data, na.rm = T) >= 0) {
      scale_fill_gradient(low = 'white', high = 'steelblue')
    } else {
      scale_fill_gradient2(low = '#1010f0', mid = 'white', high = '#f01010', midpoint = 0)
    }

  gHeatmap <- ggplotGrob(gHeatmap)

  #
  # Labels
  #

  gLabels <- lapply(names(labels), function (name) {
    labels[[name]]$scale$name <- name

    gLabel <- ggplot(data.frame(x = 1:ncol(data), y = 1, data = labels[[name]]$data))

    gLabel <- gLabel +
      if (heatmap.compact) {
        geom_tile(aes(x = x, y = y, fill = data), size = 1)
      } else {
        geom_tile(aes(x = x, y = y, fill = data), size = 1, color = 'white')
      }

    gLabel <- gLabel +
      labs(title = NULL, x = NULL, y = NULL) +
      scale_x_continuous(expand = c(0, 0)) +
      scale_y_continuous(expand = c(0, 0), labels = c(name), breaks = c(1)) +
      labels[[name]]$scale +
      theme(
        axis.ticks = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 13, angle =  0, vjust = 0.5, hjust = 0)
      )

    return(ggplotGrob(gLabel))
  })

  #
  # Col dendrogram
  #

  if (col.cluster) {
    col_cr <- dendro_data(col_cr)
    gColDendro <- ggplotGrob(
      ggdendrogram(col_cr, labels = F) +
        labs(title = NULL, x = NULL, y = NULL) +
        scale_x_continuous(
          expand = c(0, 0), limits = c(0.5, nrow(col_cr$labels) + 0.5),
          breaks = seq_along(col_cr$labels$label), labels = col_cr$labels$label
        ) +
        theme(axis.text = element_text(size = 0))
    )
  }

  #
  # Row dendrogram
  #

  if (row.cluster) {
    row_cr <- dendro_data(row_cr)
    gRowDendro <- ggplotGrob(
      ggdendrogram(row_cr, labels = F, rotate = T) +
        labs(title = NULL, x = NULL, y = NULL) +
        scale_x_continuous(
          expand = c(0, 0), limits = c(0.5, nrow(row_cr$labels) + 0.5),
          breaks = seq_along(row_cr$labels$label), labels = row_cr$labels$label
        ) +
        theme(axis.text = element_text(size = 0))
    )
  }

  #
  # Arrange
  #

  widths <- unit.c(
    unit(ncol(data), units = 'null'),
    unit(max(sapply(rownames(data), nchar)), units = 'char'),
    unit(if (row.cluster) 4 else 0, units = 'null'),
    unit(1, units = 'null')
  )

  # Add row dendro
  nrow <- 1
  if (col.cluster) {
    heights <- unit(4, units = 'null')
    grobs <- list(gColDendro[6, 4], zeroGrob(), zeroGrob(), zeroGrob())
  } else {
    heights <- unit(0, units = 'null')
    grobs <- list(zeroGrob(), zeroGrob(), zeroGrob(), zeroGrob())
  }

  # Add column names
  nrow <- nrow + 1
  heights <- unit.c(heights, unit(max(sapply(colnames(data), nchar)), units = 'char'))
  grobs <- c(grobs, list(gHeatmap[7, 4], zeroGrob(), zeroGrob(), zeroGrob()))

  # Add the labels
  for (gLabel in gLabels) {
    nrow <- nrow + 1
    heights <- unit.c(heights, unit(1, units = 'null'))
    grobs <- c(grobs, list(gLabel[6, 4], gLabel[6, 3], zeroGrob(), zeroGrob()))
  }
  if (length(gLabels) > 0) {
    nrow <- nrow + 1
    heights <- unit.c(heights, unit(1, units = 'null'))
    grobs <- c(grobs, list(zeroGrob(), zeroGrob(), zeroGrob(), zeroGrob()))
  }

  # Add the heatmap & col dendro
  nrow <- nrow + 1
  heights <- unit.c(heights, unit(nrow(data), units = 'null'))
  if (row.cluster) {
    grobs <- c(grobs, list(gHeatmap[6, 4], gHeatmap[6, 3], gRowDendro[6, 4], zeroGrob()))
  } else {
    grobs <- c(grobs, list(gHeatmap[6, 4], gHeatmap[6, 3], zeroGrob(), zeroGrob()))
  }

  # Bind together
  gMain <- arrangeGrob(grobs = grobs, nrow = nrow, ncol = 4, widths = widths, heights = heights)
  gLegand <- arrangeGrob(grobs = c(list(gHeatmap[6, 8]), lapply(gLabels, function (gLabel) { gLabel[6,8] })), ncol = 1)
  return(grid.arrange(
    grobs = list(gMain, gLegand), nrow = 1, ncol = 2,
    widths = unit.c(unit(1, units = 'null'), Reduce(max, lapply(gLegand$grobs, function (grob) { grob$widths })))
  ))
}
