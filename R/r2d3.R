##-- Packages 
library(dplyr)
library(stringr)
library(r2d3)

##-- Data
data_tst <- read.table(file = "data/brand_values.csv", sep = ",", dec = ".", header = TRUE, quote = "\"")
data_tst <- data_tst %>%
        mutate(frame_label = str_sub(string = year, start = 1, end = 4),
               #year = as.numeric(factor(x = year, levels = seq(2010, 2018, by = 0.1), labels = seq(2010, 2018, by = 0.1)))) %>%
               colour = if_else(name == "Apple", "green", "red"),
               ) %>%
        rename(frame = year,
               last_value = lastValue)

##-- Plot
options <- list(title = "18 years of Interbrand’s Top Global Brands", 
                subtitle = "Brand value, $m", 
                caption = "Source: Interbrand",
                first_frame = 2010, last_frame = 2018, 
                top_n = 12, tick_duration = 500,
                height = 600, width = 960,
                margin_top = 80, margin_right = 0, margin_bottom = 5, margin_left = 0)

r2d3(data = data_tst, 
     css = "shiny/www/styles.css", 
     script = "shiny/www/js/barchartrace.js", 
     width = 960, 
     height = 600, 
     options = options)
