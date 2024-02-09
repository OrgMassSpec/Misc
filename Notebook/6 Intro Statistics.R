library(ISwR)
m <- lm(pemax ~ age + sex + height + weight + bmp + fev1 + rv + frc + tlc, data = cystfibr)
summary(m)