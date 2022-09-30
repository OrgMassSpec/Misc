# Heat Map
# Wide format input data
# Output as compounds on x-axis and samples on y-axis.

library(lattice)
library(latticeExtra)
library(tidyverse)
options(scipen=999) # disable scientific notation
rm(list = ls())

# Input data (tall format)
x <- read_csv("Input - Wide Format.csv")
# If encoding trouble, save csv file from excel as CSV UTF-8

png('Histogram - Wide Format Input - Untransformed Responses.png', 
    width = 5, height = 5, units = "in", res = 600)
range_response <- signif(range(data.matrix(x[, -1])), 4) # min and max
hist(data.matrix(x[, -1]), breaks = 100, main = paste('Untransformed Responses', date()), 
     sub = paste('Min = ', range_response[1], ' Max = ', range_response[2]))
graphics.off()

# Adjustment value and transformation
compounds <- x$Compound
tmp_vector <- as.vector(data.matrix(x[, -1]))
min_response <- sort(tmp_vector[tmp_vector != 0])[1] # lowest non-zero value

adj_method <- 'method 1'

if(adj_method == 'method 1') {
    # increase adj_value > 10% to bring zero closer to rest of the distribution
    adj_value <- 10^(round(log10(min_response * 1))) # method 1
    heatmapData <- mutate_at(x, names(x)[2:ncol(x)], function(x) {log10(x + adj_value)})
    sub_text <- 'Transform = log10(x + (10% of the smallest non-zero value))'
}
if(adj_method == 'method 2') {
    adj_value <- 10^abs(floor(log10(min_response))) # method 2
    heatmapData <- mutate_at(x, names(x)[2:ncol(x)], function(x) {log10((x * adj_value) + 1)})
    sub_text <- 'Transform = log10((x * 10^|floor(log10(min))|) + 1)'
}
if(adj_method == 'method 3'){
    # log scale data, method 3
    heatmapData <- mutate_at(x, names(x)[2:ncol(x)], function(x) {log1p(x)})
    sub_text <- 'Transform = log10(x + 1)'
}
if(adj_method == 'method 4'){
    heatmapData <- mutate_at(x, names(x)[2:ncol(x)], function(x) {log2(x + 1)})
    sub_text <- 'Transform = log2(x + 1)'
}

heatmapMatrix <- data.matrix(heatmapData[, -1]) # remove first column
rownames(heatmapMatrix) <- compounds
range_response <- signif(range(heatmapMatrix), 4) # min and max
scale_min <- floor(range(heatmapMatrix))[1]
scale_max <- ceiling(range(heatmapMatrix))[2]
png("Histogram - Wide Format Input - Transformed Responses.png", 
    width = 5, height = 5, units = "in", res = 600)
hist(heatmapMatrix, breaks = 100, main = paste('Transformed Responses', date()),
     sub = paste('Min = ', range_response[1], ' Max = ', range_response[2]))
graphics.off()

# Clustering
# heatmapMatrix <- t(heatmapMatrix)

# Method "complete" is the default. See ?hclust and method for other options. 
clustering_method <- "complete"  

rowDendrogram <- as.dendrogram(hclust(dist(heatmapMatrix), method = clustering_method))
rowOrder <- order.dendrogram(rowDendrogram)
columnDendrogram <- as.dendrogram(hclust(dist(t(heatmapMatrix)), method = clustering_method))
columnOrder <- order.dendrogram(columnDendrogram)

# Heatmap
lattice.options(axis.padding = list(factor = 0.5))
p1 <- levelplot(heatmapMatrix[rowOrder, columnOrder],
                aspect = "fill", 
                # scales = list(x = list(rot = 90), tck = c(1,0)),
                # scales = list(x = list(rot = 90), y = list(draw = FALSE), tck = c(1,0)),
                scales = list(x = list(draw = FALSE)),
                main = paste('Heatmap - ', date(),', Clustering = ', clustering_method),
                sub = sub_text,
                colorkey = list(space = "left",
                                col = colorRampPalette(c("white", "darkred"), 
                                                       space = "Lab")(100),
                                height = 0.75,
                                labels = list(at = c(scale_min:scale_max), 
                                              labels = c(scale_min:scale_max))
                ),
                col.regions = colorRampPalette(c("white", "darkred"), 
                                               space = "Lab")(100),
                xlab = "Compound", ylab = NULL, 
                at = seq(scale_min, scale_max, length.out = 100),
                par.settings = list(layout.widths=list(axis.key.padding = -2),
                                    layout.heights=list(key.axis.padding = 0.25)),
                legend =
                    list(right = list(fun = dendrogramGrob,
                                      args = list(x = columnDendrogram, 
                                                  side = "right", size = 2)),
                         top = list(fun = dendrogramGrob,
                                    args = list(x = rowDendrogram, 
                                                side = "top", size = 2)))
)
png("Heatmamp - Wide Format Input.png", 
    width = 7, height = 5, units = "in", res = 600)
print(p1)
graphics.off()

# Write sorted table to CSV in same orientation as heat map. 
table_output <- heatmapMatrix[rowOrder, rev(columnOrder)]
table_output <- t(table_output) 
# table_output <- table_output[nrow(table_output):1,]
write.csv(table_output, file = 'Table - Wide Format Input.csv')
