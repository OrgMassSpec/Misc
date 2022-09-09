# Normal Distribution

library(tidyverse)

## Density histogram of the normal distribution

df <- read_csv(file = 'Input_1.csv')

p <- ggplot(df, aes(day1)) +
    geom_histogram(aes(y = ..density..), 
        colour = 'black', 
        fill = 'white') +
        labs(x = 'Value', 
        y = 'Density',
        title = 'Density histogram', 
    subtitle = 'Normal distribution') +
    stat_function(fun = dnorm,
        args = list(mean = mean(df$day1, 
            na.rm = TRUE), 
            sd = sd(df$day1, na.rm = TRUE)),
        colour = 'red', size = 2)

png(filename = 'Normal_Distribution_1.png', 
    width = 3, height = 3, 
    units = 'in', res = 600)
print(p)
dev.off()

## Density histograms of various normal distributions

p <- ggplot(data.frame(x = c(-5, 5)), aes(x)) + 
    labs(x = 'score', y = 'density',
        title = 'Density histograms', subtitle = 'Normal distributions') +
    stat_function(fun = dnorm,
        args = list(mean = 0, sd = 1),
        colour = 'royalblue4', size = 1.5) +
    stat_function(fun = dnorm,
        args = list(mean = 0, sd = 1.5),
        colour = 'royalblue3', size = 1.5) +
    stat_function(fun = dnorm,
        args = list(mean = 0, sd = 2),
        colour = 'royalblue2', size = 1.5) +
    stat_function(fun = dnorm,
        args = list(mean = 0, sd = 2.5),
        colour = 'royalblue1', size = 1.5) +
    annotate("text", x = 3.25, y = 0.39, label = "sd = 1") +
    annotate("text", x = 3.25, y = 0.25, label = "sd = 1.5") +
    annotate("text", x = 3.25, y = 0.2, label = "sd = 2") +
    annotate("text", x = 3.25, y = 0.15, label = "sd = 2.5")

png(filename = 'Normal_Distribution_2.png', 
    width = 3, height = 3, 
    units = 'in', res = 600)
print(p)
dev.off()
