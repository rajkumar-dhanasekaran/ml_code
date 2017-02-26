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
