## ------------------------------------------------------------------------
library(lattice)
library(latticeExtra)

## ---- fig.height=6.5, fig.width=6----------------------------------------
# Read data
x <- read.csv("Example 1 Data.csv", stringsAsFactors = FALSE)

# Set up matrix by moving sample codes from first column to row names
sampleCodes <- x[, 1] # Grab sample codes
heatmapMatrix <- data.matrix(x[, -1]) # Remove first column
rownames(heatmapMatrix) <- sampleCodes # Assign as row names

# Clustering
# heatmapMatrix <- t(heatmapMatrix) # To flip the figure, if needed
rowDendrogram <- as.dendrogram(hclust(dist(heatmapMatrix)))
rowOrder <- order.dendrogram(rowDendrogram)
columnDendrogram <- as.dendrogram(hclust(dist(t(heatmapMatrix))))
columnOrder <- order.dendrogram(columnDendrogram)

# Plot
lattice.options(axis.padding=list(factor = 0.5)) # Sets padding between heatmap and box

p1 <- levelplot(heatmapMatrix[rowOrder, columnOrder],
                aspect = "fill", 
                scales = list(x = list(rot = 90), tck = c(1,0)),
                # Specify key color ramp
                colorkey = list(space = "left", 
                                col = colorRampPalette(c("blue", "red", "yellow"), 
                                                       space = "Lab")(100),
                                height = 0.75),
                # Specify plot color ramp (same as key)
                col.regions = colorRampPalette(c("blue", "red", "yellow"), 
                                               space = "Lab")(100),
                xlab = NULL, ylab = NULL, pretty = TRUE, 
                main = "Byproduct ratios in treated water samples",
                # Set range and number of breakpoints in intensity data,
                # length.out should match the number of number of colors
                # specified for the ke and plot.
                at = seq(0, 4500, length.out = 100),
                # Set dendogram position
                par.settings = list(layout.widths = list(axis.key.padding = -1.5),
                                    layout.heights = list(key.axis.padding = -1.5)),
                # Draw dendograms
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

print(p1)

## ---- fig.height=6.5, fig.width=6----------------------------------------
p2 <- levelplot(heatmapMatrix[rowOrder, columnOrder],
          aspect = "fill", scales = list(x = list(rot = 90), tck = c(1,0)),
          colorkey = list(space = "left", 
                          col = colorRampPalette(c("blue", "red", "yellow"), 
                                                 space = "Lab")(10),
                          height = 0.75),
          col.regions = colorRampPalette(c("blue", "red", "yellow"), 
                                         space = "Lab")(10),
          xlab = NULL, ylab = NULL, cuts = 10, pretty = TRUE,
          main = "Byproduct ratios in treated water samples",
          par.settings = list(layout.widths = list(axis.key.padding = -1.5),
                              layout.heights = list(key.axis.padding = -1.5)),
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

print(p2)

## ----fig.height=4, fig.width=8-------------------------------------------
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

p3 <- levelplot(heatmapMatrix[rowOrder, columnOrder],
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
            list(right = list(fun = dendrogramGrob,
                              args = list(x = columnDendrogram, side = "right", size = 5)),
                 top = list(fun = dendrogramGrob,
                            args = list(x = rowDendrogram, side = "top", size = 5)))
)

print(p3)

## ------------------------------------------------------------------------
# Extract code
# library(knitr)
# purl("HeatMaps.Rmd") 
