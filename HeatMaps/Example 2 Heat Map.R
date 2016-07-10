# Hierarchical Clustering

# log scale

rm(list = ls())

library(lattice)
library(latticeExtra)
library(grid)

x <- read.csv("Example 2 Data.csv", stringsAsFactors = FALSE, na.strings = c("", "NA"))

x <- x[x$Category1 == "natural", ]

# Heat map showing all natural compounds. Each compound has at least one detect
# among the eight samples, even though the color coding seems to show some
# compounds with no detects. These are compounds with very low relative peak
# areas that were binned as having values of zero.

# Prepare matrix and subset.

x$SampleCode <- paste(x$Ecotype, " (", substr(x$Sample, (nchar(x$Sample) - 2) + 1, nchar(x$Sample)), ")", sep = "")
heatmapData <- x[, c("SampleCode", "Compound", "RelativeArea")]
heatmapData$RelativeArea <- log10(heatmapData$RelativeArea + 1) # log scale data

# heatmapData$RelativeArea <- heatmapData$RelativeArea

heatmapData <- reshape(heatmapData,
                       v.names = "RelativeArea",
                       idvar = "SampleCode",
                       timevar = "Compound",
                       direction = "wide")

heatmapMatrix <- data.matrix(heatmapData[, -1]) # remove sample codes
heatmapMatrix[is.na(heatmapMatrix)] <- 0 # set non-detects to zero

rownames(heatmapMatrix) <- heatmapData$SampleCode
colnames(heatmapMatrix) <- sapply(strsplit(colnames(heatmapMatrix), split = ".", fixed = TRUE), "[[", j = 2)

# Clustering
heatmapMatrix <- t(heatmapMatrix)
rowDendrogram <- as.dendrogram(hclust(dist(heatmapMatrix)))
rowOrder <- order.dendrogram(rowDendrogram)
columnDendrogram <- as.dendrogram(hclust(dist(t(heatmapMatrix))))
columnOrder <- order.dendrogram(columnDendrogram)

lattice.options(axis.padding=list(factor=0.5)) # No padding between heatmap and box

p1 <- levelplot(heatmapMatrix[rowOrder, columnOrder],
          aspect = "fill", scales = list(x = list(rot = 90), tck = c(1,0)),
          colorkey = list(space = "left",
                          col = colorRampPalette(c("blue", "red", "yellow"), space = "Lab")(15),
                          height = 0.75,
                          labels = list(at = c(0,
                                               log10(1+1),
                                               log10(2+1),
                                               log10(3+1),
                                               log10(4+1)),
                                        labels = c(0,1,2,3,4)
                          )
          ),
          col.regions = colorRampPalette(c("blue", "red", "yellow"), space = "Lab")(15),
          xlab = NULL, ylab = NULL, cuts = 14,
          par.settings = list(layout.widths=list(axis.key.padding=-1),
                              layout.heights=list(key.axis.padding=-1)),
          legend =
            list(right = list(fun = dendrogramGrob,
                              args = list(x = columnDendrogram, side = "right", size = 5)),
                 top = list(fun = dendrogramGrob,
                            args = list(x = rowDendrogram, side = "top", size = 5)))
)

tiff(filename = 'Example 2 Heat Map.tiff', width = 10, height = 5, units = "in", res = 600, compression = 'lzw')
print(p1)
graphics.off()