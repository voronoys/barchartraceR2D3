library(dplyr)
library(r2d3)

# Options: Confirmed, Deaths, or Recovered
types <- c("Confirmed", "Deaths", "Recovered")

# reading
dt <- data.table::rbindlist(
  lapply(types, function(type) {
    link <- sprintf("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-%s.csv", type)
    read.csv(link, stringsAsFactors = FALSE) %>% 
      mutate(type = type)
  })
)

# selecting vars
dt <- dt %>% 
  select(-Province.State, -Lat, -Long) %>% 
  rename(country = Country.Region) %>% 
  select(country, type, everything())

# grouping
dt <- dt %>% 
  group_by(country, type) %>% 
  summarise_all(sum, na.rm = TRUE) %>% 
  ungroup() 

# tidying
dt <- dt %>% 
  tidyr::pivot_longer(cols = 3:ncol(dt), 
                      names_to  = "date", 
                      values_to = "cases") %>% 
  mutate(date = gsub(pattern = "X", replacement = "", x = date)) %>% 
  mutate(date = gsub(pattern = "\\.", replacement = "/", x = date)) %>% 
  mutate(date = as.Date(date, format = "%m/%d/%y"))

# temporary
dt <- dt %>% 
  filter(type == "Confirmed")
##

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

##-- Plot
options <- list(title         = "Coronavirus", 
                subtitle      = "Experimental", 
                caption       = "Source: John Hopkins University",
                first_frame   = 1,
                last_frame    = 48, 
                top_n         = 10,
                tick_duration = 500,
                height        = 600,
                width         = 960,
                margin_top    = 80,
                margin_right  = 0,
                margin_bottom = 5,
                margin_left   = 0)

r2d3(data    = dt, 
     css     = "shiny/www/styles.css", 
     script  = "shiny/www/js/barchartrace.js", 
     width   = 960, 
     height  = 600, 
     options = options)

# didn't roll ... yet