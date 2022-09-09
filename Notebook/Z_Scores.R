# Z-Scores

library(tidyverse)

# Non-scaled data set
x <- rnorm(100, mean = 10, sd = 5)

p <- ggplot() + 
    geom_histogram(aes(x), bins = 30) +
    labs(x = 'score', y = 'count', 
        title = 'Non-scaled data set', 
        subtitle = 'Mean = 10, SD = 5')

png(filename = 'Z_Scores_1.png', 
    width = 3, height = 3, 
    units = 'in', res = 600)
print(p)
dev.off()

# Scaled data set
y <- scale(x, center = TRUE, scale = TRUE)

p <- ggplot() + 
    geom_histogram(aes(y), bins = 30) +
    labs(x = 'z-score', y = 'count', 
        title = 'Scaled data set', 
        subtitle = 'Scaled to normal distribution')

png(filename = 'Z_Scores_2.png', 
    width = 3, height = 3, 
    units = 'in', res = 600)
print(p)
dev.off()

# Z Scores by confidence interval
prob <- seq(from = 0.90, to = 0.99, length.out = 50)
z <- qnorm((1 - prob)/2, lower.tail = FALSE)
x1 <- 0.95; x2 <- qnorm((1 - x1)/2, lower.tail = FALSE)

p <- ggplot(data.frame(x = prob, y = z), aes(x = x, y = y)) +
    geom_line(color = 'darkgreen', size = 1.5) +
    geom_segment(aes(x = x1, y = z[1], xend = x1, 
        yend = x2), size = 1) +
    geom_segment(aes(x = x1, y = x2, xend = prob[1], 
        yend = x2), size = 1) +
    labs(x = 'confidence interval probability', 
        y = 'z-score', title = 'Z-scores', 
        subtitle = 'normal distribution')

png(filename = 'Z_Scores_3.png', width = 3, 
    height = 3, units = 'in', res = 600)
print(p)
dev.off()