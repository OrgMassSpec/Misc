# Heat Map
# Tall format input data
# Output as compounds on x-axis and samples on y-axis.

library(lattice)
library(latticeExtra)
options(scipen=999) # disable scientific notation
rm(list = ls())

# Input data (tall format)
x <- read.csv("Input - Tall Format.csv", 
              stringsAsFactors = FALSE)
# If encoding trouble, save csv file from excel as CSV UTF-8

# Group = heatmap y-axis labels
# Compound = heatmap x-axis labels
# Response = heatmap color
x <- x[, c("Group", "Compound", "Response")]

stopifnot(length(x$Response[x$Response == 0]) >= 1) # stop if there are no zeros

# Untransformed response histogram
range_response <- signif(range(x$Response), 4) # min and max
png("Histogram - Tall Format Input - Untransformed Responses.png", 
    width = 5, height = 5, units = "in", res = 600)
hist(x$Response, breaks = 100, main = paste('Untransformed Responses', date()), 
     sub = paste('Min = ', range_response[1], ' Max = ', range_response[2]))
graphics.off()

# Adjustment value and transformation
min_response <- sort(x$Response[x$Response != 0])[1] # lowest non-zero value

adj_method <- 'method 1'

if(adj_method == 'method 1') {
    # increase adj_value > 10% to bring zero closer to rest of the distribution
    adj_value <- 10^(round(log10(min_response * 0.1))) # method 1
    x$Response <- log10(x$Response + adj_value) # log scale data, method 1
    sub_text <- 'Transform = log10(x + (10% of the smallest non-zero value))'
}
if(adj_method == 'method 2') {
    adj_value <- 10^abs(floor(log10(min_response))) # method 2
    x$Response <- log10((x$Response * adj_value) + 1) # log scale data, method 2
    sub_text <- 'Transform = log10((x * 10^|floor(log10(min))|) + 1)'
}
if(adj_method == 'method 3'){
    x$Response <- log1p(x$Response) # log scale data, method 3
    sub_text <- 'Transform = log10(x + 1)'
}
if(adj_method == 'method 4'){
    x$Response <- log2(x$Response + 1)
    sub_text <- 'Transform = log2(x + 1)'
}

range_response <- signif(range(x$Response), 4) # min and max
scale_min <- floor(range(x$Response))[1]
scale_max <- ceiling(range(x$Response))[2]
png("Histogram - Tall Format Input - Transformed Responses.png", 
    width = 5, height = 5, units = "in", res = 600)
hist(x$Response, breaks = 100, main = paste('Transformed Responses', date()),
     sub = paste('Min = ', range_response[1], ' Max = ', range_response[2]))
graphics.off()

# Reshape
# reshape loses the compound names
heatmapData <- reshape(x,
                       v.names = "Response",
                       idvar = "Group",
                       timevar = "Compound",
                       direction = "wide")

heatmapMatrix <- data.matrix(heatmapData[, -1]) 
rownames(heatmapMatrix) <- heatmapData$Group
colnames(heatmapMatrix) <- sapply(strsplit(colnames(heatmapMatrix), 
                                           split = ".", fixed = TRUE), "[[", j = 2)

# Clustering
heatmapMatrix <- t(heatmapMatrix) 

# Method "complete" is the default. See ?hclust and method for other options. 
clustering_method <- "complete"  

rowDendrogram <- as.dendrogram(hclust(dist(heatmapMatrix), method = clustering_method))
rowOrder <- order.dendrogram(rowDendrogram)
columnDendrogram <- as.dendrogram(hclust(dist(t(heatmapMatrix)), method = clustering_method))
columnOrder <- order.dendrogram(columnDendrogram)

# Heatmap
lattice.options(axis.padding=list(factor=0.5)) 
p1 <- levelplot(heatmapMatrix[rowOrder, columnOrder], 
                # rows and columns are interpreted in levelplot as the x and y vectors respectively
                aspect = "fill", 
                # scales = list(x = list(rot = 90), tck = c(1,0)),
                main = paste('Heatmap - ', date(),', Clustering = ', clustering_method),
                sub = sub_text,
                scales = list(x = list(draw = FALSE)),
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
png("Heatmamp - Tall Format Input.png", 
    width = 7, height = 5, units = "in", res = 600)
print(p1)
graphics.off()

# Write sorted table to CSV in same orientation as heat map. 
table_output <- heatmapMatrix[rowOrder, columnOrder]
table_output <- t(table_output) 
table_output <- table_output[nrow(table_output):1,]
write.csv(table_output, file = 'Table - Tall Format Input.csv')
