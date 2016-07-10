# Hierarchical Clustering 

# Linear scale

# Non-detects were set to a concentration of zero. Missing values ("No IS") were
# set to NA and appear as white (empty) cells. Compounds with very low
# concentrations are binned as having apparent values of zero (blue).

rm(list = ls())

library(lattice)
library(latticeExtra)

# Read data
x <- read.csv("Example 1 Data.csv", stringsAsFactors = FALSE)

# Set up matrix, move sample codes from first column to row names
sampleCodes <- x[, 1] # Sample codes
heatmapMatrix <- data.matrix(x[, -1]) # Remove first column (sample codes)
rownames(heatmapMatrix) <- sampleCodes

# Clustering
# heatmapMatrix <- t(heatmapMatrix)
rowDendrogram <- as.dendrogram(hclust(dist(heatmapMatrix)))
rowOrder <- order.dendrogram(rowDendrogram)
columnDendrogram <- as.dendrogram(hclust(dist(t(heatmapMatrix))))
columnOrder <- order.dendrogram(columnDendrogram)

lattice.options(axis.padding=list(factor=0.5)) # No padding between heatmap and box

p1 <- levelplot(heatmapMatrix[rowOrder, columnOrder],
          aspect = "fill", scales = list(x = list(rot = 90), tck = c(1,0)),
          colorkey = list(space = "left", 
                          col = colorRampPalette(c("blue", "red", "yellow"), 
                                                 space = "Lab")(100),
                          height = 0.75),
          col.regions = colorRampPalette(c("blue", "red", "yellow"), 
                                         space = "Lab")(100),
          xlab = NULL, ylab = NULL, pretty = TRUE, 
          at = seq(0, 4500, length.out = 100),
          par.settings = list(layout.widths=list(axis.key.padding=-1),
                              layout.heights=list(key.axis.padding=-1)),
          legend =
            list(right = list(fun = dendrogramGrob,
                              args = list(x = columnDendrogram, 
                                          side = "right", 
                                          size = 5)),                      
                 top = list(fun = dendrogramGrob,
                            args = list(x = rowDendrogram, 
                                        side = "top", 
                                        size = 5)))
)

tiff(filename = 'Example 1 Heat Map A.tiff', width = 7, height = 7, units = "in", res = 600, compression = 'lzw')
print(p1)
graphics.off()


# Modified color scaling to show low abundance.

p2 <- levelplot(heatmapMatrix[rowOrder, columnOrder],
          aspect = "fill", scales = list(x = list(rot = 90), tck = c(1,0)),
          colorkey = list(space = "left", 
                          col = colorRampPalette(c("blue", "red", "yellow"), 
                                                 space = "Lab")(10),
                          height = 0.75),
          col.regions = colorRampPalette(c("blue", "red", "yellow"), 
                                         space = "Lab")(10),
          xlab = NULL, ylab = NULL, cuts = 10, pretty = TRUE,
          par.settings = list(layout.widths=list(axis.key.padding=-1),
                              layout.heights=list(key.axis.padding=-1)),
          legend =
            list(right = list(fun = dendrogramGrob,
                              args = list(x = columnDendrogram, 
                                          side = "right", 
                                          size = 5)),                      
                 top = list(fun = dendrogramGrob,
                            args = list(x = rowDendrogram, 
                                        side = "top", 
                                        size = 5)))
)

tiff(filename = 'Example 1 Heat Map B.tiff', width = 7, height = 7, units = "in", res = 600, compression = 'lzw')
print(p2)
graphics.off()
