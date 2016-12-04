getwd()
setwd("/Users/Cipher/Documents")

loan_granting_input <- read.csv("/Users/Cipher/Documents/Loan_Granting_Input_Dataset.csv")
head(loan_granting_input)
class(loan_granting_input)
str(loan_granting_input)

head(loan_granting_input[,3])

unique(loan_granting_input[,18])
unique(loan_granting_input[,19])
hist(loan_granting_input[,6])
boxplot((loan_granting_input[,6]))
summary(loan_granting_input[,6])
unique(loan_granting_input[,6])
unique(loan_granting_input[,9])
boxplot((loan_granting_input[,9]))

nrow(loan_granting_input[loan_granting_input[,6] > 850,])
#lines to port to Azure ML
loan_granting_input[is.na(loan_granting_input[,6]),6] <- median(loan_granting_input[,6],na.rm = TRUE)
loan_granting_input[is.na(loan_granting_input[,9]),9] <- median(loan_granting_input[,9],na.rm = TRUE)
loan_granting_input[loan_granting_input[,6] > 850,6] <- median(loan_granting_input[,6],na.rm = TRUE)
#
median(loan_granting_input[,6])
mean(loan_granting_input[,6])

median(loan_granting_input[,9],na.rm = TRUE)
summary(loan_granting_input[,9])

column_names <- data.frame(colnames(loan_granting_input))
plot(loan_granting_input$Loan.Status,loan_granting_input$Months.since.last.delinquent)

unique(loan_granting_input$Maximum.Open.Credit)
is.na(loan_granting_input$Maximum.Open.Credit)
loan_granting_input[is.na(loan_granting_input[,6]),6] <- median(loan_granting_input[,6],na.rm = TRUE)
loan_granting_input[is.na(loan_granting_input[,9]),9] <- median(loan_granting_input[,9],na.rm = TRUE)

class(loan_granting_input$Monthly.Debt)
class(loan_granting_input$Maximum.Open.Credit)

loan_granting_input$Maximum.Open.Credit = as.numeric(loan_granting_input$Maximum.Open.Credit)
loan_granting_input$Monthly.Debt = as.integer(loan_granting_input$Monthly.Debt)

credit_score_median <- median(loan_granting_input[,6],na.rm = TRUE)

loan_granting_input[loan_granting_input[,6] > 850,6] <- credit_score_median

nrow(loan_granting_input[(loan_granting_input[,6] > 850 & !is.na(loan_granting_input[,6])),6])
nrow(loan_granting_input[is.na(loan_granting_input[,9]),9])

pe94.person$foo <- ifelse(!is.na(pe94.person$H01) & pe94.person$H01 == 12, 0, pe94.person$H03)

loan_granting_input[(loan_granting_input[,6] > 850 & !is.na(loan_granting_input[,6])),6] <- credit_score_median
loan_granting_input[is.na(loan_granting_input[,19]),19] <- 0
class(loan_granting_input[,19])

class(loan_granting_input[,11])
?cor
cov(loan_granting_input, method = c("spearman"))

hist(loan_granting_input$Current.Loan.Amount)
summary(loan_granting_input$Current.Loan.Amount)
boxplot(loan_granting_input$Current.Loan.Amount)

head(loan_granting_input$Current.Loan.Amount,20)
median(loan_granting_input$Current.Loan.Amount)
median.Current.Loan.Amount <- median(loan_granting_input$Current.Loan.Amount)
loan_granting_input[loan_granting_input$Current.Loan.Amount == 99999999,] <- median.Current.Loan.Amount


#is.na(loan_granting_input$Current.Loan.Amount)
$ Annual.Income               : num  33694 42269 90126 38072 50025 ...
$ Years.of.Credit.History     : num  12.3 26.3 28.8 26.2 11.5 13.2 17.6 17.6 17.7 19.8 ...
$ Number.of.Open.Accounts     : num  10 17 5 9 12 4 7 7 7 7 ...
$ Current.Credit.Balance      : num  6760 6262 20967 22529 17391 ...

hist(loan_granting_input$Annual.Income)
summary(loan_granting_input$Annual.Income)
median.Annual.Income <- median(loan_granting_input$Annual.Income, na.rm = TRUE)

loan_granting_input[is.na(loan_granting_input$Current.Annual.Income),]  <- median.Annual.Income


hist(loan_granting_input$Years.of.Credit.History)
summary(loan_granting_input$Years.of.Credit.History)
boxplot(loan_granting_input$Years.of.Credit.History)

Outlier removal code- reusuable
http://stackoverflow.com/questions/4787332/how-to-remove-outliers-from-a-dataset#4788102

remove_outliers <- function(x, na.rm = TRUE, ...) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
  H <- 1.5 * IQR(x, na.rm = na.rm)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}

y <- remove_outliers(loan_granting_input$Years.of.Credit.History)
boxplot(y)
hist(y)
y[]

loan_granting_input$Years.of.Credit.History <- y

hist(loan_granting_input$Number.of.Open.Accounts)
summary(loan_granting_input$Number.of.Open.Accounts)
boxplot(loan_granting_input$Number.of.Open.Accounts)
y <- remove_outliers(loan_granting_input$Number.of.Open.Accounts)
loan_granting_input$Number.of.Open.Accounts <- y

?cor
plot(loan_granting_input$Number.of.Open.Accounts,loan_granting_input$Loan.Status)
plot(loan_granting_input$Loan.Status,loan_granting_input$Number.of.Open.Accounts)
?plot
plot(loan_granting_input)

Correlation tests
http://stats.stackexchange.com/questions/108007/correlations-with-categorical-variables
http://www.ats.ucla.edu/stat/mult_pkg/whatstat/default.htm