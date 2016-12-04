#install.packages("bayesAB")
library(bayesAB)

plotBeta(1000,1000)

library(magrittr)
n <- 1e3
out_weaker_priors <- rep(NA, n)
out_stronger_priors <- rep(NA, n)
out_diffuse <- rep(NA, n)