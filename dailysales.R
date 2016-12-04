getwd()

setwd("/Users/Cipher/Documents")

dailysales = read.csv("Daily_Sales_GAP_20160413.csv") # get data 
head(dailysales)
summary(dailysales)
plot(dailysales$Avg_Session_Duration,dailysales$Product_Removes_From_Basket,type="h")
warnings()
corelation = cor(dailysales,method="kendall") # get correlations
View(corelation)
install.packages("Hmisc")
library(Hmisc)
rcorr(as.matrix(dailysales))

# Scatterplot Matrices from the glus Package 
install.packages("gclus")
library(gclus)

dta.col <- dmat.color(corelation) # get colors
# reorder variables so those with highest correlation
# are closest to the diagonal
dta.o <- order.single(corelation) 
cpairs(dailysales, dta.o, panel.colors=dta.col, gap=.5,       main="Variables Ordered and Colored by Correlation" )
