# T Distribution

library(tidyverse)

p <- ggplot(data.frame(x = c(-5, 5)), aes(x)) + 
    labs(x = 'score', y = 'density',
        title = 't-distribution', subtitle = 'density histogram') +
    stat_function(fun = dnorm,
        args = list(mean = 0, sd = 1), aes(color = "normal dist."), size = 2) +
    stat_function(fun = dt,
        args = list(df = 30), aes(color = 't-dist., df = 30'), size = 1) +
    stat_function(fun = dt,
        args = list(df = 15), aes(color = 't-dist., df = 15'), size = 1) +
    stat_function(fun = dt,
        args = list(df = 5), aes(color = 't-dist., df = 5'), size = 1) +
    scale_color_manual('Curve', 
        values = c('royalblue4', 'darkseagreen4', 'darkseagreen3', 'darkseagreen2'))

png(filename = 'T_Distribution_1.png', width = 5, 
    height = 3, units = 'in', res = 600)
print(p)
dev.off()