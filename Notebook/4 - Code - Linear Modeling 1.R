# Linear Model

pitch <- c(233,204,242,130,112,142) 
sex <- c(rep("female",3), rep("male",3))
df <- data.frame(pitch, sex)
lm_df <- lm(pitch ~ sex, df)
summary(lm_df)

age = c(14,23,35,48,52,67) 
pitch = c(252,244,240,233,212,204) 
df = data.frame(age, pitch) 
lm_df = lm(pitch ~ age, df) 
summary(lm_df)

library(lme4)
politeness <- read.csv('politeness_data.csv')
