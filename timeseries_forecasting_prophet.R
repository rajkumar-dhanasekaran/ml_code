#https://facebookincubator.github.io/prophet/
  
if(!require(prophet)) {
  install.packages("prophet"); require(prophet)} #load / install+load prophet

if(!require(dplyr)) {
  install.packages("dplyr"); require(dplyr)} #load / install+load dplyr

if(!require(wikipediatrend)) {
  install.packages("wikipediatrend"); require(wikipediatrend)} #load / install+load wikipediatrend

setwd("/Users/Cipher/Documents/ml_code")

wp_trend("Peyton_Manning", file="example_wp_peyton_manning.csv", from = "2009-01-01", to="2017-01-31")

peyton_manning <- wp_load( file="example_wp_peyton_manning.csv" )
colnames(peyton_manning)
nrow(peyton_manning)
head(peyton_manning)

df <- read.csv('example_wp_peyton_manning.csv') 
df <- df[df$count != 0,]

df <- df %>%
  mutate(y = log(count))

df <- df[,c(1,8)]
nrow(df)

colnames(df)<-c('ds','y')
m <- prophet(df)

future <- make_future_dataframe(m, periods = 365)
tail(future)

forecast <- predict(m, future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])

plot(m, forecast)
prophet_plot_components(m, forecast)

#Forecasting Growth - with a specified carrying capacity


wp_trend("R_(programming_language)", file="example_wp_R.csv", from = "2007-01-01", to="2017-01-31")

r_prog_lang <- wp_load( file="example_wp_R.csv" )
colnames(r_prog_lang)
nrow(r_prog_lang)
head(r_prog_lang)

df <- read.csv('example_wp_R.csv') 
df <- df[df$count != 0,]
head(df)
df$y <- log(df$count)

df <- df[,c(1,8)]
nrow(df)
head(df)
colnames(df)<-c('ds','y')

df$cap <- 8.5

m <- prophet(df, growth = 'logistic')

future <- make_future_dataframe(m, periods = 1826)
future$cap <- 8.5
fcst <- predict(m, future)
plot(m, fcst)

#Trend Changepoints - Adjust trend flexibity
#peyton_manning dataset

m <- prophet(df, changepoint.prior.scale = 0.5)
forecast <- predict(m, future)
plot(m, forecast)

#decreasing trend changepoint
m <- prophet(df, changepoint.prior.scale = 0.001)
forecast <- predict(m, future)
plot(m, forecast)

#specifying the locations of changepoints
m <- prophet(df, changepoints = c(as.Date('2014-01-01')))
forecast <- predict(m, future)
plot(m, forecast)
