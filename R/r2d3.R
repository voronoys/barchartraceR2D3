##-- Packages 
library(dplyr)
library(r2d3)

##--
data_tst <- read.table(file = "data/brand_values.csv", sep = ",", dec = ".", header = TRUE, quote = "\"")
options <- list(title = "Acusto PNC", subtitle = "Almost Done!", caption = "Caption aqui!",
                first_year = 2000, last_year = 2018,
                top_n = 12, tick_duration = 500,
                height = 600, width = 960,
                margin_top = 80, margin_right = 0, margin_bottom = 5, margin_left = 0)

r2d3(data = data_tst, 
     css = "www/styles.css", 
     script = "www/js/barchartrace.js", 
     width = 960, 
     height = 600, 
     options = options)
