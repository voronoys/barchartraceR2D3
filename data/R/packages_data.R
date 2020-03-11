##-- Packages
library(cranlogs)
library(dplyr)
library(lubridate)

##-- Getting data
pkgs <- data.frame(var = c("ggplot2", "plotly", "highcharter", "plot3D",
                               "dplyr", "tidyr", "readr", "purrr", "tibble", "stringr", "forcats", "data.table",
                               "shiny", "rmarkdown", "xaringam"),
                   group = c(rep("Visualization", 4),
                           rep("Manipulation", 8),
                           rep("Report", 3)), stringsAsFactors = FALSE)
pkg_data <- cranlogs::cran_downloads(packages = pkgs$var, from = "2019-01-01", to = Sys.Date()-1)
pkg_data <- pkg_data %>% left_join(pkgs, by = c("package" = "var")) %>%
  rename(var = package)

##-- Making the cumulative number of downloads
pkg_data <- pkg_data %>%
  group_by(var) %>%
  arrange(date) %>%
  mutate(cum_count = cumsum(count)) %>%
  ungroup()

##-- Making the daily ranking
pkg_data <- pkg_data %>%
  group_by(date) %>%
  arrange(desc(cum_count)) %>%
  mutate(rank = 1:n()) %>%
  ungroup()

##-- Rearranging data
pkg_data <- pkg_data %>%
  mutate(year = year(date),
         month = month(date, label = TRUE, abbr = FALSE)) %>%
  select(date, year, month, var, group, count, cum_count, rank)

save(pkg_data, file = "data/pkg_data.RData")
