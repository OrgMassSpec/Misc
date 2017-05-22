library(lattice)
library(latticeExtra)

# Read data
x <- read.csv("Example 2 Data.csv", stringsAsFactors = FALSE, na.strings = c("", "NA"))

# Subset data and prepate sample names
x <- x[x$Category1 == "natural", ]
x$SampleCode <- paste(x$Ecotype, " (", substr(x$Sample, (nchar(x$Sample) - 2) + 1, nchar(x$Sample)), ")", sep = "")
heatmapData <- x[, c("SampleCode", "Compound", "RelativeArea")]

# Convert to log scale
heatmapData$RelativeArea <- log10(heatmapData$RelativeArea + 0.0001) 

# Convert to wide format
heatmapData <- reshape(heatmapData,
                       v.names = "RelativeArea",
                       idvar = "SampleCode",
                       timevar = "Compound",
                       direction = "wide")

heatmapMatrix <- data.matrix(heatmapData[, -1]) # Remove first column

# Convert non-detects
heatmapMatrix[is.na(heatmapMatrix)] <- -4

# Prepare row and column names
rownames(heatmapMatrix) <- heatmapData$SampleCode
colnames(heatmapMatrix) <- sapply(strsplit(colnames(heatmapMatrix), split = ".", fixed = TRUE), "[[", j = 2)

# Clustering
heatmapMatrix <- t(heatmapMatrix)
rowDendrogram <- as.dendrogram(hclust(dist(heatmapMatrix)))
rowOrder <- order.dendrogram(rowDendrogram)
columnDendrogram <- as.dendrogram(hclust(dist(t(heatmapMatrix))))
columnOrder <- order.dendrogram(columnDendrogram)

lattice.options(axis.padding=list(factor = 0.5))

# Do not set y-axis order based on clustering (and remove right dendogram)
p3 <- levelplot(heatmapMatrix[rowOrder, ], # remove columnOrder
                aspect = "fill", 
                scales = list(x = list(rot = 90), tck = c(1,0)),
                # scales = list(x = list(draw = FALSE)), # To remove axis if needed
                colorkey = list(space = "left",
                                col = colorRampPalette(c("blue", "red", "yellow"), 
                                                       space = "Lab")(100),
                                height = 0.75,
                                labels = list(at = c(log10(0+0.0001),
                                                     log10(0.001+0.0001),
                                                     log10(0.01+0.0001),
                                                     log10(0.1+0.0001),
                                                     log10(1+0.0001),
                                                     log10(10+0.0001)),
                                              labels = c(0, 0.001, 0.01, 0.1, 1, 10)
                                )
                ),
                col.regions = colorRampPalette(c("blue", "red", "yellow"), space = "Lab")(100),
                xlab = NULL, ylab = NULL, 
                main = "Relative abundance of natural products in dolphin ecotypes",
                at = seq(log10(0.0001), log10(10 + 0.0001), length.out = 100),
                par.settings = list(layout.widths = list(axis.key.padding = -1.5),
                                    layout.heights = list(key.axis.padding = -1.5)),
                legend =
                  list(top = list(fun = dendrogramGrob, # remove right dendogram
                                  args = list(x = rowDendrogram, side = "top", size = 5)))
)

print(p3)
