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
# Check for missing values
which(is.na(politeness$frequency)) # row 39 has a frequency of NA
png('Politeness_1.png', width = 5, height = 5, units = "in", res = 600)
boxplot(frequency ~ attitude*gender, col=c("white","lightgray"),politeness)
graphics.off()
politeness.model = lmer(frequency ~ attitude + (1|subject) + (1|scenario), data=politeness)
summary(politeness.model)
politeness.model = lmer(frequency ~ attitude + gender + (1|subject) + (1|scenario), data=politeness)
summary(politeness.model)
politeness.null = lmer(frequency ~ gender + (1|subject) + (1|scenario), data=politeness, REML=FALSE)
politeness.model = lmer(frequency ~ attitude + gender + (1|subject) + (1|scenario), data=politeness, REML=FALSE)
anova(politeness.null,politeness.model)
