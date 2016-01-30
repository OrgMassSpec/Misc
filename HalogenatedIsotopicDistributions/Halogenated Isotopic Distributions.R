library(OrgMassSpecR)
library(lattice)

BrClIsotopicDistribution <- function(number.bromines = 5, number.chlorines = 5) {
  results.list <- vector(mode = "list", length = number.bromines * number.chlorines)
  index <- 1
  for(n in 1:number.bromines) {
    for(m in 1:number.chlorines) { 
      results <- IsotopicDistribution(formula = list(Br = n, Cl = m))
      results$Br <- n 
      results$Cl <- m
      results.list[[index]] <- results
      index <- index + 1
    }
  }
  x <- as.data.frame(do.call("rbind", results.list))
  return(x)
}

brcl.data <- BrClIsotopicDistribution(number.bromines = 5, number.chlorines = 5)
brcl.data$distribution.label <- with(brcl.data, paste("Br", Br, "Cl", Cl, sep = ""))

print(xyplot(percent ~ mz | distribution.label, 
       data = brcl.data, 
       type = "h",
       xlim = list(c(113, 113+25), c(148, 148+25), c(183, 183+25), c(218, 218+25), c(253, 253+25), 
                   c(192, 192+25), c(227, 227+25), c(262, 262+25), c(297, 297+25), c(332, 332+25), c(271, 271+25), 
                   c(306, 306+25), c(341, 341+25), c(376, 376+25), c(411, 411+25), c(350, 350+25), c(385, 385+25), 
                   c(420, 420+25), c(455, 455+25), c(490, 490+25), c(429, 429+25), c(464, 464+25), c(499, 499+25), 
                   c(534, 534+25), c(569, 569+25)), 
       xlab = "halogen mass",
       ylab = "intensity (%)",
       main = "Bromine + Chlorine isotopic distributions",
       layout = c(5, 5),
       scales = list(x = list(relation = "free")),
       lwd = 2
))