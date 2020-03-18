##-- Packages
library(dplyr)
library(tidyr)
library(stringr)
library(shiny)
library(shinymaterial)
library(shinycssloaders)
library(shinyWidgets)
library(shinyBS)
library(r2d3)
library(cranlogs)
library(lubridate)

source(file = "R/utils.R")

##-- Data corona
corona_file <- sprintf("data/corona_%s.csv", Sys.Date())

if(!file.exists(corona_file)) {
  data_corona <- get_corona_data()
  write.table(x = data_corona, file = corona_file, sep = ";", row.names = FALSE)
} else {
  data_corona <- read.table(file = corona_file, sep = ";", dec = ".", header = TRUE)
}

##-- Data brands
data_brands <- read.table(file = "data/brand_values.csv", sep = ",", dec = ".", header = TRUE, quote = "\"")

##-- Data pacakges
pkgs_file <- "data/R_packages.csv"

if(!file.exists(pkgs_file)) {
  data_pkgs <- get_pkgs_data()
  write.table(x = data_pkgs, file = pkgs_file, sep = ";", row.names = FALSE)
} else {
  data_pkgs <- read.table(file = pkgs_file, sep = ";", dec = ".", header = TRUE)
}

# ##-- Urban population
# ##-- https://www.theguardian.com/cities/2019/mar/21/500-years-in-59-seconds-the-race-to-be-the-worlds-largest-city
# ##-- Pensar melhor em como fazer isto
# data_pop <- read.table(file = "data/urban_pop.csv", sep = ";", dec = ".", header = TRUE, quote = "\"") %>%
#   group_by(City) %>%
#   mutate(first_year = min(year), last_year = max(year))
# full_data <- expand.grid(year = unique(data_pop$year), City = unique(data_pop$City))
# 
# data_pop <- full_data %>% 
#   left_join(data_pop, by = c("year", "City")) %>%
#   group_by(City) %>%
#   fill(first_year, last_year, .direction = "downup") %>%
#   filter(year >= first_year, year <= last_year) %>%
#   arrange(year) %>%
#   mutate(pop_interpolation = zoo::na.approx(pop)) %>%
#   filter(!is.na(pop_interpolation)) %>%
#   fill(Country, .direction = "downup") %>%
#   ungroup() %>%
#   mutate(frame_label = year,
#          name = paste0(City, " (", Country, ")")) %>%
#   filter(year > 0) %>%
#   prepare_data(date = "year", date_label = "frame_label", name = "name", value = "pop_interpolation", cumulative = FALSE) %>%
#   filter(rank < 20) 

##-- Global definitions
height <- 515
width <- "100%"
col_spinner <- "#2196F3" 