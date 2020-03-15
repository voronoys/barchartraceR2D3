##-- Function to prepare data for r2d3
prepare_data <- function(data, date, date_label, name, value) {
  
  if(is.null(date_label)) date_label <- date
  if(date_label == date) {
    data[["frame_label"]] <- data[[date]]
    date_label <- "frame_label" 
  }
  
  ##-- Renaming
  data <- data %>%
    rename(date = rlang::UQ(rlang::sym(date)),
           frame_label = rlang::UQ(rlang::sym(date_label)),
           name = rlang::UQ(rlang::sym(name)),
           value = rlang::UQ(rlang::sym(value)))
  
  ##-- Ranks
  data <- data %>%
    dplyr::arrange(date) %>%
    dplyr::group_by(name) %>%
    dplyr::mutate(value = cumsum(value)) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(date) %>%
    dplyr::arrange(dplyr::desc(value)) %>%
    dplyr::mutate(rank = 1:n()) %>%
    dplyr::ungroup()

  ##-- Last value
  data <- data %>%
    dplyr::arrange(date) %>%
    dplyr::group_by(name) %>%
    dplyr::mutate(last_value = dplyr::lag(x = value, n = 1L)) %>%
    dplyr::ungroup()

  ##-- Frame and frame label
  data <- data %>%
    dplyr::filter(!is.na(last_value)) %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(frame = as.numeric(as.factor(date)))
  
  ##-- Select
  data <- data %>%
    select(date, frame, frame_label, name, rank, value, last_value)
  
  return(data)
}

##-- COVID-19 dataset
get_corona_data <- function() {
  ##-- Reading
  types <- c("Confirmed", "Deaths", "Recovered")
  
  data <- dplyr::bind_rows(
    lapply(types, function(type) {
      link <- sprintf("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-%s.csv", type)
      read.csv(link, stringsAsFactors = FALSE) %>% 
        mutate(type = type)
    })
  )
  
  ##-- Selecting vars
  data <- data %>% 
    dplyr::select(-Province.State, -Lat, -Long) %>% 
    dplyr::rename(name = Country.Region) %>% 
    dplyr::select(name, type, dplyr::everything())
  
  ##-- Grouping
  data <- data %>% 
    dplyr::group_by(name, type) %>% 
    dplyr::summarise_all(sum, na.rm = TRUE) %>% 
    dplyr::ungroup() 
  
  ##-- Tidying
  data <- data %>% 
    tidyr::pivot_longer(cols = 3:ncol(.), 
                        names_to  = "date", 
                        values_to = "value") %>% 
    dplyr::mutate(date = gsub(pattern = "X", replacement = "", x = date)) %>% 
    dplyr::mutate(date = gsub(pattern = "\\.", replacement = "/", x = date)) %>% 
    dplyr::mutate(date = as.Date(date, format = "%m/%d/%y"))

  return(data)
}

##-- R packages dataset
get_pkgs_data <- function(from = "2019-01-01", to = "2019-12-31") {
  top_lm <- cranlogs::cran_top_downloads(when = "last-month", count = 100)$package
  data <- cranlogs::cran_downloads(packages = top_lm, from = from, to = to)
  
  return(data)
}

saveWidgetFix <- function (widget, file, ...) {
  ##-- https://github.com/ramnathv/htmlwidgets/issues/299
  wd <- getwd()
  on.exit(setwd(wd))
  
  out_dir <- dirname(file)
  file <- basename(file)
  
  setwd(out_dir)
  
  htmlwidgets::saveWidget(widget, file = file, ...)
}
