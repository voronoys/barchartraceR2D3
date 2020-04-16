##-- Barchart race in D3
barchartrace_r2d3 <- function(data, 
                              name, date, value, date_label = date, colour = name, 
                              cumulative = FALSE, 
                              title = "", subtitle = "", caption = "", 
                              mood = "neutral", top_n = 12, duration = 700,
                              css = "www/styles.css", script = "www/js/barchartrace.js",
                              width = 515, height = "100%",
                              margin = c(80, 20, 5, 0),
                              label_fix = FALSE) {
  ##-- Prepare data
  data <- prepare_data(data = data, 
                       date = date, date_label = date_label, 
                       name = name, value = value, colour = colour,
                       cumulative = cumulative, 
                       mood = mood) %>%
    dplyr::filter(rank <= top_n)
  
  ##-- Frame labels
  frame_labels <- data %>% 
    group_by(frame) %>%
    summarise(frame_label = first(frame_label)) %>%
    .$frame_label %>%
    as.character
  
  ##-- Options
  options <- list(title = title, 
                  subtitle = subtitle, 
                  caption = caption,
                  first_frame = 1, last_frame = max(data$frame), 
                  top_n = top_n, tick_duration = duration,
                  height = 600, width = 960,
                  margin_top = margin[1], margin_right = margin[2], margin_bottom = margin[3], margin_left = margin[4],
                  frame_labels = frame_labels,
                  label_fix = label_fix)
  
  bcrr2d3 <- r2d3(data = data, 
                  css = css, 
                  script = script, 
                  width = width, 
                  height = height, 
                  options = options)
  
  return(bcrr2d3)
}

##-- Function to prepare data for r2d3
prepare_data <- function(data, 
                         date, date_label,
                         name, value, colour, 
                         cumulative = TRUE, 
                         mood = "neutral") {
  
  if(is.null(date_label)) date_label <- date
  if(date_label == date) {
    data[["frame_label"]] <- data[[date]]
    date_label <- "frame_label" 
  }
  
  if(is.null(colour)) colour <- name
  if(colour == name) {
    data[["colour"]] <- data[[name]]
    colour <- "colour" 
  }
  
  ##-- Renaming
  if("name" %in% names(data) & name != "name") data$name <- NULL
  if("date" %in% names(data) & date != "date") data$date <- NULL
  if("date_label" %in% names(data) & date_label != "date_label") data$date_label <- NULL
  if("value" %in% names(data) & value != "value") data$value <- NULL
  if("colour" %in% names(data) & colour != "colour") data$colour <- NULL
  
  data <- data %>%
    rename(date = rlang::expr(!!date),
           frame_label = rlang::expr(!!date_label),
           name = rlang::expr(!!name),
           value = rlang::expr(!!value),
           colour = rlang::expr(!!colour))
  
  ##-- Ranks
  if(cumulative) {
    data <- data %>%
      dplyr::group_by(name) %>%
      dplyr::arrange(date) %>%
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
    dplyr::mutate(last_value = if_else(is.na(last_value), 0, as.numeric(last_value))) %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(frame = as.numeric(factor(date)))
  
  ##-- Colors
  if(!is.color(data$colour[1])) data$colour <- make_palette(x = data$colour, mood = mood)
  
  ##-- Select
  data <- data %>%
    select(date, frame, frame_label, name, colour, rank, value, last_value)
  
  return(data)
}

##-- COVID-19 dataset
get_corona_data <- function() {
  ##-- Reading
  types <- c("confirmed", "deaths")
  
  data <- dplyr::bind_rows(
    lapply(types, function(type) {
      link <- sprintf("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_%s_global.csv", type)
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

make_palette <- function(x, mood = "neutral", seed = 1) {
  set.seed(seed)
  
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

is.color <- function(x) {
  lg <- grepl(x = x, pattern = "^#([0-9]|[a-eA-E]){6}")  
  
  return(lg)
}

material_floating_button2 <- function(input_id, icon = NULL, depth = NULL, color = NULL, top = FALSE) {
  shinymaterial:::create_material_object(
    js_file = "shiny-material-floating-button.js", 
    material_tag_list = shiny::tagList(
      shiny::tags$div(
        id = paste0(input_id, "_div"),
        class = "fixed-action-btn", 
        style = ifelse(top, 
                       "bottom: auto;", 
                       ""),
        shiny::tags$button(
          class = paste0("btn-floating btn-large waves-effect waves-light shiny-material-floating-button", 
                         ifelse(
                           is.null(depth), 
                           "", 
                           paste0(" z-depth-", depth)
                         ), 
                         ifelse(
                           is.null(color), 
                           "", 
                           paste0(" ", color)
                         )
          ), 
          style = ifelse(!is.null(color), "", "background-color:#F06C71"), 
          id = input_id, 
          value = 0, 
          shiny::tags$i(class = "material-icons", icon)
        )
      )
    )
  )
}
