# PCA with clusters defined by k-means clustering

x <- read.csv("Example 1 Data.csv", stringsAsFactors = FALSE, na.strings = c("", "NA"))

x <- x[x$Category1 == "natural", ]


# k-Means Clustering ----------

# Two clusters specified based on the known two dolphin ecotypes.

pcaData <- x[, c("SampleCode", "Compound", "RelativeArea")]

pcaData$RelativeArea <- log10(pcaData$RelativeArea + 1) # log scale data

pcaData <- reshape(pcaData,
                   v.names = "RelativeArea",
                   idvar = "SampleCode",
                   timevar = "Compound",
                   direction = "wide")

row.names(pcaData) <- pcaData$SampleCode; pcaData <- pcaData[-1]

pcaMatrix <- data.matrix(pcaData)

colnames(pcaMatrix) <- gsub('RelativeArea.', '', x = colnames(pcaMatrix), fixed = TRUE)

pcaMatrix[is.na(pcaMatrix)] <- 0 # set any non-detects to zero

set.seed (2)
kmResult <- kmeans(pcaMatrix, centers = 2, nstart = 20)
setNames(as.data.frame(sort(kmResult$cluster)), "cluster")


# Principal Components Analysis ----------

# k-means results used to assign PCA clusters.

pcaResult = prcomp(pcaMatrix)

png("Example 1 PCA Figure.png", width = 5, height = 5, units = "in", res = 300)

par(mar = c(4,4,3,1))

plot(pcaResult$x[,1:2], xlab ="PC1", ylab="PC2", #xlim = c(-0.5, 0.75),
     col = kmResult$cluster,
     pch = c(15, 16)[kmResult$cluster],
     las = 1,
     main = 'PCA')

text(pcaResult$x[,1:2], row.names(pcaData), pos = c(4, 2, 4, 4, 4, 4, 4, 4), cex = 1, col = "blue")

legend("topright", legend = c("k-means cluster 1", "k-means cluster 2"), 
       col = c("black", "red"), pch = c(15, 16))

dev.off()

summary(pcaResult)$importance


# Default Biplot ----------

png("Example 1 Default Biplot Figure.png", width = 5, height = 5, units = "in", res = 300)

par(mar = c(4,4,3,1))

biplot(pcaResult, cex = 0.75, main = 'Default Biplot')

dev.off()


# Custom biplot ----------

# Base R code customized to replace sample names with points.
# getAnywhere(biplot.default)
# getAnywhere(biplot.prcomp)

biplotCustomDefault <- function (x, y, var.axes = TRUE, col = "green", cex = rep(par("cex"), 2), 
                                 xlabs = NULL, ylabs = NULL, expand = 1, xlim = NULL, ylim = NULL, 
                                 arrow.len = 0.1, main = NULL, sub = NULL, xlab = NULL, ylab = NULL, 
                                 ...) 
{
  n <- nrow(x)
  p <- nrow(y)
  if (missing(xlabs)) {
    xlabs <- dimnames(x)[[1L]]
    if (is.null(xlabs)) 
      xlabs <- 1L:n
  }
  xlabs <- as.character(xlabs)
  dimnames(x) <- list(xlabs, dimnames(x)[[2L]])
  if (missing(ylabs)) {
    ylabs <- dimnames(y)[[1L]]
    if (is.null(ylabs)) 
      ylabs <- paste("Var", 1L:p)
  }
  ylabs <- as.character(ylabs)
  dimnames(y) <- list(ylabs, dimnames(y)[[2L]])
  if (length(cex) == 1L) 
    cex <- c(cex, cex)
  if (missing(col)) {
    col <- par("col")
    if (!is.numeric(col)) 
      col <- match(col, palette(), nomatch = 1L)
    col <- c(col, col + 1L)
  }
  else if (length(col) == 1L) 
    col <- c(col, col)
  unsigned.range <- function(x) c(-abs(min(x, na.rm = TRUE)), 
                                  abs(max(x, na.rm = TRUE)))
  rangx1 <- unsigned.range(x[, 1L])
  rangx2 <- unsigned.range(x[, 2L])
  rangy1 <- unsigned.range(y[, 1L])
  rangy2 <- unsigned.range(y[, 2L])
  if (missing(xlim) && missing(ylim)) 
    xlim <- ylim <- rangx1 <- rangx2 <- range(rangx1, rangx2)
  else if (missing(xlim)) 
    xlim <- rangx1
  else if (missing(ylim)) 
    ylim <- rangx2
  ratio <- max(rangy1/rangx1, rangy2/rangx2)/expand
  on.exit(par(op))
  op <- par(pty = "s")
  if (!is.null(main)) 
    op <- c(op, par(mar = par("mar") + c(0, 0, 1, 0)))
  
  # Changed 
  plot(x, type = 'p', xlim = xlim, ylim = ylim, col = kmResult$cluster, pch = c(15, 16)[kmResult$cluster],
       xlab = xlab, ylab = ylab, sub = sub, main = main, ...)
  # text(x, xlabs, cex = cex[1L], col = col[1L], ...)
  

  par(new = TRUE)
  dev.hold()
  on.exit(dev.flush(), add = TRUE)
  plot(y, axes = FALSE, type = "n", xlim = xlim * ratio, ylim = ylim * 
         ratio, xlab = "", ylab = "", col = "green", ...)
  axis(3, col = "dark green", ...)
  axis(4, col = "dark green", ...)
  box(col = col[1L])
  text(y, labels = ylabs, cex = cex[2L], col = "dark green", ...)
  if (var.axes) 
    arrows(0, 0, y[, 1L] * 0.8, y[, 2L] * 0.8, col = "dark green", 
           length = arrow.len)
  invisible()
}

biplotCustomPrcomp <- function (x, choices = 1L:2L, scale = 1, pc.biplot = FALSE, ...) 
{
  if (length(choices) != 2L) 
    stop("length of choices must be 2")
  if (!length(scores <- x$x)) 
    stop(gettextf("object '%s' has no scores", deparse(substitute(x))), 
         domain = NA)
  if (is.complex(scores)) 
    stop("biplots are not defined for complex PCA")
  lam <- x$sdev[choices]
  n <- NROW(scores)
  lam <- lam * sqrt(n)
  if (scale < 0 || scale > 1) 
    warning("'scale' is outside [0, 1]")
  if (scale != 0) 
    lam <- lam^scale
  else lam <- 1
  if (pc.biplot) 
    lam <- lam/sqrt(n)
  biplotCustomDefault(t(t(scores[, choices])/lam), t(t(x$rotation[, 
                                                             choices]) * lam), ...)
  invisible()
}

png("Example 1 Custom Biplot Figure.png", width = 5, height = 5, units = "in", res = 300)

par(mar = c(4,4,3,1))

biplotCustomPrcomp(pcaResult, cex = 0.75, main = "Custom Biplot")

legend("topright", legend = c("k-means cluster 1", "k-means cluster 2"), 
       col = c("black", "red"), pch = c(15, 16))

dev.off()

