##-- Packages
library(dplyr)
library(r2d3)

##-- Options: Confirmed, Deaths, or Recovered
types <- c("Confirmed", "Deaths", "Recovered")

##-- Reading
dt <- data.table::rbindlist(
  lapply(types, function(type) {
    link <- sprintf("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-%s.csv", type)
    read.csv(link, stringsAsFactors = FALSE) %>% 
      mutate(type = type)
  })
)

##-- Selecting vars
dt <- dt %>% 
  select(-Province.State, -Lat, -Long) %>% 
  rename(country = Country.Region) %>% 
  select(country, type, everything())

##-- Grouping
dt <- dt %>% 
  group_by(country, type) %>% 
  summarise_all(sum, na.rm = TRUE) %>% 
  ungroup() 

##-- Tidying
dt <- dt %>% 
  tidyr::pivot_longer(cols = 3:ncol(dt), 
                      names_to  = "date", 
                      values_to = "cases") %>% 
  mutate(date = gsub(pattern = "X", replacement = "", x = date)) %>% 
  mutate(date = gsub(pattern = "\\.", replacement = "/", x = date)) %>% 
  mutate(date = as.Date(date, format = "%m/%d/%y"))

##-- Temporary
dt <- dt %>% 
  filter(type == "Confirmed")

dt <- dt %>%
  arrange(date) %>% 
  group_by(country) %>% 
  mutate(value = cumsum(cases)) %>% 
  ungroup() %>% 
  group_by(date) %>%
  arrange(desc(value)) %>%
  mutate(rank = 1:n()) %>%
  ungroup()

dt <- dt %>% 
  arrange(date) %>% 
  group_by(country) %>% 
  mutate(last_value = lag(x = value, n = 1L)) %>% 
  ungroup()

dt <- dt %>% 
  mutate(frame_label = as.character(date),
         frame       = as.numeric(date) - 18282,
         colour      = "#32a852")

dt_aux <- dt %>% 
  rename(name = country) %>%
  filter(type == "Confirmed", !is.na(last_value)) %>%
  arrange(date) %>%
  mutate(frame = as.numeric(as.factor(date))) %>%
  filter(name != "China")