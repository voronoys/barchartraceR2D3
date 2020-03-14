##-- Packages
library(dplyr)
library(stringr)
library(shiny)
library(shinymaterial)
library(r2d3)
library(cranlogs)
library(lubridate)

source(file = "R/utils.R")

##-- Data brands
data_brands <- read.table(file = "data/brand_values.csv", sep = ",", dec = ".", header = TRUE, quote = "\"")
data_brands <- data_brands %>%
  mutate(frame_label = str_sub(string = year, start = 1, end = 4)) %>%
  prepare_data(date = "year", date_label = "frame_label", name = "name", value = "value")

##-- Data corona
corona_file <- sprintf("data/corona_%s.RData", Sys.Date())

if(!file.exists(corona_file)) {
  data_corona <- get_corona_data()
  save(data_corona, file = corona_file)
} else {
  load(corona_file)
}

##-- Data pacakges
pkgs_file <- sprintf("data/R_packages_%s.RData", Sys.Date())

if(!file.exists(pkgs_file)) {
  data_pkgs <- get_pkgs_data()
  save(data_pkgs, file = pkgs_file)
} else {
  load(pkgs_file)
}
