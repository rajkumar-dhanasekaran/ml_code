#http://www.analyticsvidhya.com/blog/2016/03/practical-guide-principal-component-analysis-python/?utm_content=buffer074c9&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer
#set working directory
setwd("/Users/Cipher/Documents")


#check variable class
str(data.set)
new_data <- data.set[2:(ncol(data.set)-2)]
#principal component analysis
prin_comp <- prcomp(new_data, scale. = T)
names(prin_comp)
[1] "sdev"     "rotation" "center"   "scale"    "x"
#outputs the mean of variables
prin_comp$center

#outputs the standard deviation of variables
prin_comp$scale

prin_comp$rotation

prin_comp$rotation[1:5,1:4]
dim(prin_comp$x)
biplot(prin_comp, scale = 0)
prin_comp$x
plot(prin_comp)
#compute standard deviation of each principal component
std_dev <- prin_comp$sdev

#compute variance
pr_var <- std_dev^2

#check variance of first 10 components
pr_var[1:10]

#proportion of variance explained
prop_varex <- pr_var/sum(pr_var)
prop_varex[1:20]


#scree plot
plot(prop_varex, xlab = "Principal Component",
       ylab = "Proportion of Variance Explained",
       type = "b")

#cumulative scree plot
plot(cumsum(prop_varex), xlab = "Principal Component",
       ylab = "Cumulative Proportion of Variance Explained",
       type = "b")