##-- Packages
library(shiny)
library(shinymaterial)
library(dplyr)
library(stringr)
library(r2d3)

##-- Data
data_tst <- read.table(file = "../data/brand_values.csv", sep = ",", dec = ".", header = TRUE, quote = "\"")
data_tst <- data_tst %>%
  mutate(frame_label = str_sub(string = year, start = 1, end = 4),
         #year = as.numeric(factor(x = year, levels = seq(2010, 2018, by = 0.1), labels = seq(2010, 2018, by = 0.1)))) %>%
  ) %>%
  rename(frame = year,
         last_value = lastValue)