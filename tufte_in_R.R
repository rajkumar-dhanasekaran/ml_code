#tufte in R
#http://motioninsocial.com/tufte/

#Slopegraph in base graphics
#you can increase distance between labels using argument binval
install.packages("RCurl")
library(devtools)
library(RCurl)
#source_url("https://raw.githubusercontent.com/leeper/slopegraph/master/R/slopegraph.r")
#https://github.com/leeper/slopegraph/tree/master/R
source("/Users/Cipher/Documents/ml_code/slopegraph.r")
source("/Users/Cipher/Documents/ml_code/segmentize.r")
d <- read.csv(text = getURL("https://raw.githubusercontent.com/jkeirstead/r-slopegraph/master/cancer_survival_rates.csv"))
df <- reshape(d, timevar = "year", idvar = c("group"), direction = "wide")
rownames(df) <- df$group; df <- round(df[,-1],0)
slopegraph(df, col.line='gray', xlim = c(-1, ncol(df)+2), binval = 2,
           labels=c("5 years", "10 years", "15 years", "20 years"),
           col.xaxt="transparent", main="")

#Slopegraph in base graphics with bumpchart
install.packages("prettyR")
install.packages("plotrix")
library(devtools)
library(RCurl)
library(prettyR)
library(plotrix)
#source_url("https://raw.githubusercontent.com/leeper/slopegraph/master/R/slopegraph.r")
source("/Users/Cipher/Documents/ml_code/slopegraph.r")
source("/Users/Cipher/Documents/ml_code/segmentize.r")
d <- read.csv(text = getURL("https://raw.githubusercontent.com/jkeirstead/r-slopegraph/master/cancer_survival_rates.csv"),header=T)
df <- stretch_df(d, "group", "value")
bumpchart(df[,3:6], rank=FALSE, col="gray50", top.labels=c(5,10,15,20),
          labels=df[,1], main="Years cancer survival by group", mar=c(2,12,5,12))


