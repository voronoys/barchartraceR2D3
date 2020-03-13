##-- Packages
library(shiny)
library(shinymaterial)
library(dplyr)
library(stringr)
library(r2d3)

##-- Data brands
data_brands <- read.table(file = "../data/brand_values.csv", sep = ",", dec = ".", header = TRUE, quote = "\"")
data_brands <- data_brands %>%
  mutate(frame_label = str_sub(string = year, start = 1, end = 4)) %>%
  rename(frame = year, last_value = lastValue) %>%
  arrange(frame) %>%
  mutate(frame = as.numeric(as.factor(frame)))

##-- Data corona
##-- Options: Confirmed, Deaths, or Recovered
types <- c("Confirmed", "Deaths", "Recovered")
type_sel <- "Confirmed"

##-- Reading
data_corona <- data.table::rbindlist(
  lapply(types, function(type) {
    link <- sprintf("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-%s.csv", type)
    read.csv(link, stringsAsFactors = FALSE) %>% 
      mutate(type = type)
  })
) %>% 
  select(-Province.State, -Lat, -Long) %>% 
  rename(country = Country.Region) %>% 
  select(country, type, everything()) %>% 
  group_by(country, type) %>% 
  summarise_all(sum, na.rm = TRUE) %>% 
  ungroup() %>% 
  tidyr::pivot_longer(cols = 3:ncol(.), 
                      names_to  = "date", 
                      values_to = "cases") %>% 
  mutate(date = gsub(pattern = "X", replacement = "", x = date)) %>% 
  mutate(date = gsub(pattern = "\\.", replacement = "/", x = date)) %>% 
  mutate(date = as.Date(date, format = "%m/%d/%y")) %>% 
  filter(type == type_sel) %>%
  arrange(date) %>% 
  group_by(country) %>% 
  mutate(value = cumsum(cases)) %>% 
  ungroup() %>% 
  group_by(date) %>%
  arrange(desc(value)) %>%
  mutate(rank = 1:n()) %>%
  ungroup() %>% 
  arrange(date) %>% 
  group_by(country) %>% 
  mutate(last_value = lag(x = value, n = 1L)) %>% 
  ungroup() %>% 
  mutate(frame_label = as.character(date)) %>% 
  rename(name = country) %>%
  filter(!is.na(last_value)) %>%
  arrange(date) %>%
  mutate(frame = as.numeric(as.factor(date))) %>%
  filter(name != "China")
