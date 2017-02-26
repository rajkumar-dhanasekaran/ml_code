#https://cran.r-project.org/web/packages/wikipediatrend/vignettes/using-wikipediatrend.html

if(!require(wikipediatrend)) {
  install.packages("wikipediatrend"); require(wikipediatrend)} #load / install+load wikipediatrend

if(!require(ggplot2)) {
  install.packages("ggplot2"); require(ggplot2)} #load / install+load ggplot2

setwd("/Users/Cipher/Documents/ml_code")

page_views <- wp_trend("main_page", from = "2015-10-01", to = "2015-11-30")

plot(
  page_views[, c("date","count")], 
  type="b"
)


ggplot(page_views, aes(x=date, y=count)) + 
  geom_line(size=1.5, colour="steelblue") + 
  geom_smooth(method="loess", colour="#00000000", fill="#001090", alpha=0.1) +
  scale_y_continuous( breaks=seq(5e6, 50e6, 5e6) , 
                      label= paste(seq(5,50,5),"M") ) +
  theme_bw()

page_views <- 
  wp_trend( 
    page = c( "Millennium_Development_Goals", "Climate_Change"), 
    from = "2015-01-01",
    to   = "2015-01-30"
  )

ggplot(page_views, aes(x=date, y=count, group=page, color=page)) + 
  geom_line(size=1.5) + theme_bw()

page_views <- 
  wp_trend( 
    page = "Millennium_Development_Goals" ,
    from = "2000-01-01",
    to   = "2009-01-30"
  )

ggplot(page_views, aes(x=date, y=count, color=wp_year(date))) + 
  geom_line() + 
  stat_smooth(method = "lm", formula = y ~ poly(x, 22), color="#CD0000a0", size=1.2) +
  theme_bw() 

page_views <- 
  wp_trend( 
    page = c("Objetivos_de_Desarrollo_del_Milenio", "Millennium_Development_Goals") ,
    lang = c("es", "en"),
    from = "2015-01-01",
    to   = "2015-04-30"
  )


ggplot(page_views, aes(x=date, y=count, group=lang, color=lang, fill=lang)) + 
  geom_smooth(size=1.5) + 
  geom_point() +
  theme_bw() 

wp_trend("Millennium_Development_Goals", file="Millennium_Development_Goals.csv", from = "2015-01-01", to="2015-01-30")
wp_trend("Objetivos_de_Desarrollo_del_Milenio", lang="es", file="Millennium_Development_Goals.csv", from = "2015-01-01", to="2015-01-30")
#if file already exsists always appends to file
Millennium_Development_Goals <- wp_load( file="Millennium_Development_Goals.csv" )
wp_get_cache()
wp_cache_reset()

titles <- wp_linked_pages("Millennium_Development_Goals", "en")
titles <- titles[titles$lang %in% c("de", "es", "ar", "ru", "ta"),]

page_views <- 
  wp_trend(
    page = titles$page, 
    lang = titles$lang,
    from = "2015-06-01",
    to   = "2015-11-30"
  ) 

for(i in unique(page_views$lang) ){
  iffer <- page_views$lang==i
  page_views[iffer, ]$count <- scale(page_views[iffer, ]$count)
}

ggplot(page_views, aes(x=date, y=count, group=lang, color=lang)) + 
  geom_line(size=1.2, alpha=0.5) + 
  ylab("standardized count\n(by lang: m=0, var=1)") +
  theme_bw() + 
  scale_colour_brewer(palette="Set1") + 
  guides(colour = guide_legend(override.aes = list(alpha = 1))) 


