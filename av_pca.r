#data source - http://datahack.analyticsvidhya.com/contest/practice-problem-bigmart-sales-prediction
#http://www.analyticsvidhya.com/blog/2016/03/practical-guide-principal-component-analysis-python/?utm_content=buffer074c9&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer
#directory path
> path <- ".../Data/Big_Mart_Sales"

#set working directory
> setwd(path)

#load train and test file
> train <- read.csv("train_Big.csv")
> test <- read.csv("test_Big.csv")

#add a column
> test$Item_Outlet_Sales <- 1

#combine the data set
> combi <- rbind(train, test)

#impute missing values with median
> combi$Item_Weight[is.na(combi$Item_Weight)] <- median(combi$Item_Weight, na.rm = TRUE)

#impute 0 with median
> combi$Item_Visibility <- ifelse(combi$Item_Visibility == 0, median(combi$Item_Visibility),                                   combi$Item_Visibility)

#find mode and impute
> table(combi$Outlet_Size, combi$Outlet_Type)
> levels(combi$Outlet_Size)[1] <- "Other"

#remove the dependent and identifier variables
> my_data <- subset(combi, select = -c(Item_Outlet_Sales, Item_Identifier,                                       Outlet_Identifier))

#check available variables
> colnames(my_data)

#check variable class
> str(my_data)

'data.frame': 14204 obs. of 9 variables:
  $ Item_Weight : num 9.3 5.92 17.5 19.2 8.93 ...
$ Item_Fat_Content : Factor w/ 5 levels "LF","low fat",..: 3 5 3 5 3 5 5 3 5 5 ...
$ Item_Visibility : num 0.016 0.0193 0.0168 0.054 0.054 ...
$ Item_Type : Factor w/ 16 levels "Baking Goods",..: 5 15 11 7 10 1 14 14 6 6 ...
$ Item_MRP : num 249.8 48.3 141.6 182.1 53.9 ...
$ Outlet_Establishment_Year: int 1999 2009 1999 1998 1987 2009 1987 1985 2002 2007 ...
$ Outlet_Size : Factor w/ 4 levels "Other","High",..: 3 3 3 1 2 3 2 3 1 1 ...
$ Outlet_Location_Type : Factor w/ 3 levels "Tier 1","Tier 2",..: 1 3 1 3 3 3 3 3 2 2 ...
$ Outlet_Type : Factor w/ 4 levels "Grocery Store",..: 2 3 2 1 2 3 2 4 2 2 ...

#load library
> library(dummies)

#create a dummy data frame
> new_my_data <- dummy.data.frame(my_data, names = c("Item_Fat_Content","Item_Type",
                                                     "Outlet_Establishment_Year","Outlet_Size",
                                                     "Outlet_Location_Type","Outlet_Type"))
#check the data set
> str(new_my_data)

#principal component analysis
> prin_comp <- prcomp(new_my_data, scale. = T)
> names(prin_comp)
[1] "sdev"     "rotation" "center"   "scale"    "x"
#outputs the mean of variables
prin_comp$center

#outputs the standard deviation of variables
prin_comp$scale

> prin_comp$rotation

> prin_comp$rotation[1:5,1:4]
PC1            PC2            PC3             PC4
Item_Weight                0.0054429225   -0.001285666   0.011246194   0.011887106
Item_Fat_ContentLF        -0.0021983314    0.003768557  -0.009790094  -0.016789483
Item_Fat_Contentlow fat   -0.0019042710    0.001866905  -0.003066415  -0.018396143
Item_Fat_ContentLow Fat    0.0027936467   -0.002234328   0.028309811   0.056822747
Item_Fat_Contentreg        0.0002936319    0.001120931   0.009033254  -0.001026615
dim(prin_comp$x)
> biplot(prin_comp, scale = 0)

#compute standard deviation of each principal component
> std_dev <- prin_comp$sdev

#compute variance
> pr_var <- std_dev^2

#check variance of first 10 components
> pr_var[1:10]
[1] 4.563615 3.217702 2.744726 2.541091 2.198152 2.015320 1.932076 1.256831
[9] 1.203791 1.168101

#proportion of variance explained
> prop_varex <- pr_var/sum(pr_var)
> prop_varex[1:20]
[1] 0.10371853 0.07312958 0.06238014 0.05775207 0.04995800 0.04580274
[7] 0.04391081 0.02856433 0.02735888 0.02654774 0.02559876 0.02556797
[13] 0.02549516 0.02508831 0.02493932 0.02490938 0.02468313 0.02446016
[19] 0.02390367 0.02371118

#scree plot
> plot(prop_varex, xlab = "Principal Component",
       ylab = "Proportion of Variance Explained",
       type = "b")

#cumulative scree plot
> plot(cumsum(prop_varex), xlab = "Principal Component",
       ylab = "Cumulative Proportion of Variance Explained",
       type = "b")