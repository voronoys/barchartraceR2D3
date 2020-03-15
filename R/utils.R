##-- Function to prepare data for r2d3
prepare_data <- function(data, date, date_label, name, value, cumulative = TRUE, mood = "neutral") {
  
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
  if(cumulative) {
    data <- data %>%
      dplyr::arrange(date) %>%
      dplyr::group_by(name) %>%
      dplyr::mutate(value = cumsum(value)) %>%
      dplyr::ungroup() 
  }
  
  data <- data %>%
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
  
  ##-- Colors
  data$colour <- make_palette(x = data$name, mood = mood)
  
  ##-- Select
  data <- data %>%
    select(date, frame, frame_label, name, colour, rank, value, last_value)
  
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

make_palette <- function(x, mood = "neutral") {
  x <- as.character(x)
  unique_groups <- unique(x)
  
  if(mood == "neutral") colors <- c("#67D0DD", "#9FE481", "#F6E785", "#FAAFA5", "#DC95DD", "#A885EE")
  if(mood == "happy") colors <- c("#7BB661", "#C4DE6F", "#FF5348", "#FEF65C", "#00B9FC", "#0984FC")
  if(mood == "sad") colors <- c("#4B4AA7", "#7F78D2", "#FDECFF", "#CC6A87", "#AF5B7C")
  
  n_colors <- length(unique_groups)
  
  palette <- colorRampPalette(colors = colors)(n_colors)
  palette <- sample(x = palette, size = n_colors, replace = FALSE)
  names(palette) <- unique_groups
  
  out_colors <- palette[x]
  return(out_colors)
}