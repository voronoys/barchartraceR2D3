server <- function(input, output, session) {
  ##-- COVID-19 bar chart race
  output$corona <- renderUI({
    ##-- Inputs
    duration <- input$duration_corona
    top_n <- input$top_n_corona
    mood <- tolower(input$mood_corona)
    
    type_sel <- switch(input$type_corona,
                       "Confirmed cases" = "Confirmed",
                       "Deaths" = "Deaths",
                       "Recovered" = "Recovered")
    
    ##-- Prepare data
    data_corona <- data_corona %>%
      filter(type == type_sel & name != "China") %>%
      filter(value != 0) %>% 
      prepare_data(date = "date", date_label = "date", name = "name", value = "value", mood = mood, cumulative = FALSE) 
    
    ##-- Prepare R2D3
    frame_labels <- data_corona %>% 
      group_by(frame) %>%
      summarise(frame_label = first(frame_label)) %>%
      .$frame_label
    
    subtitle <- switch(type_sel,
                       "Confirmed" = "Confirmed cases (cumulative)",
                       "Deaths" = "Number of deaths (cumulative)",
                       "Recovered" = "Number of recovered (cumulative)")
    
    options <- list(title = "Covid-19 outside China", 
                    subtitle = subtitle, 
                    caption = "Source: John Hopkins University",
                    first_frame = 1, last_frame = max(data_corona$frame), 
                    top_n = top_n, tick_duration = duration,
                    height = 600, width = 960,
                    margin_top = 80, margin_right = 0, margin_bottom = 5, margin_left = 0,
                    frame_labels = frame_labels)
    
    gd3 <- r2d3(data = data_corona, 
                css = "www/styles.css", 
                script = "www/js/barchartrace.js", 
                width = width, 
                height = height, 
                options = options)
    
    file_out <- "www/out_bcr/corona.html"
    saveWidgetFix(widget = gd3, file = file_out, selfcontained = TRUE)
    
    tags$iframe(src = paste0("out_bcr/", basename(file_out)), height = "600", width = "100%", frameBorder = "0")
  })
  
  ##-- Brands bar chart race
  output$brands <- renderUI({
    ##-- Inputs
    duration <- input$duration_brands
    top_n <- input$top_n_brands
    mood <- tolower(input$mood_brands)
    
    ##-- Prepare R2D3
    data_brands <- data_brands %>%
      mutate(frame_label = str_sub(string = year, start = 1, end = 4)) %>%
      prepare_data(date = "year", date_label = "frame_label", name = "name", value = "value", mood = mood)
    
    frame_labels <- data_brands %>% 
      group_by(frame) %>%
      summarise(frame_label = first(frame_label)) %>%
      .$frame_label
    
    options <- list(title = "18 years of Interbrand’s Top Global Brands", 
                    subtitle = "Brand value, $m", 
                    caption = "Source: Interbrand",
                    first_frame = 1, last_frame = max(data_brands$frame), 
                    top_n = top_n, tick_duration = duration,
                    height = 600, width = 960,
                    margin_top = 80, margin_right = 0, margin_bottom = 5, margin_left = 0,
                    frame_labels = frame_labels)
    
    gd3 <- r2d3(data = data_brands, 
                css = "www/styles.css", 
                script = "www/js/barchartrace.js", 
                width = width, 
                height = height, 
                options = options)
    
    file_out <- "www/out_bcr/brands.html"
    saveWidgetFix(widget = gd3, file = file_out, selfcontained = TRUE)
    
    tags$iframe(src = paste0("out_bcr/", basename(file_out)), height = "600", width = "100%", frameBorder = "0")
  })
  
  ##-- R packages bar chart race
  output$pkgs <- renderUI({
    ##-- Inputs
    duration <- input$duration_pkgs
    top_n <- input$top_n_pkgs
    mood <- tolower(input$mood_pkgs)
    
    ##-- Prepare R2D3
    data_pkgs <- data_pkgs %>%
      mutate(month = month(date, abbr = TRUE, label = TRUE), 
             day = day(date),
             frame_label = paste0(month, "/", day)) %>%
      prepare_data(date = "date", date_label = "frame_label", name = "package", value = "count", mood = mood) 
    
    frame_labels <- data_pkgs %>% 
      group_by(frame) %>%
      summarise(frame_label = first(frame_label)) %>%
      .$frame_label
    
    options <- list(title = "Most downloaded R packages in 2019", 
                    subtitle = "Based on the 100 most downloaded packages last month", 
                    caption = "Source: cranlogs",
                    first_frame = 1, last_frame = max(data_pkgs$frame), 
                    top_n = top_n, tick_duration = duration,
                    height = 600, width = 960,
                    margin_top = 80, margin_right = 0, margin_bottom = 5, margin_left = 0,
                    frame_labels = frame_labels)
    
    gd3 <- r2d3(data = data_pkgs, 
                css = "www/styles.css", 
                script = "www/js/barchartrace.js", 
                width = width, 
                height = height, 
                options = options)
    
    file_out <- "www/out_bcr/pkgs.html"
    saveWidgetFix(widget = gd3, file = file_out, selfcontained = TRUE)
    
    tags$iframe(src = paste0("out_bcr/", basename(file_out)), height = "600", width = "100%", frameBorder = "0")
  })
  
  ##-- Urband population bar chart race
  output$pop <- renderUI({
    ##-- Inputs
    duration <- input$duration_pop
    top_n <- input$top_n_pop
    mood <- input$mood_pop
    
    ##-- Prepare R2D3
    data_pop <- data_pop %>%
      prepare_data(date = "year", date_label = "frame_label", name = "name", value = "pop_interpolation", cumulative = FALSE, mood = mood) %>%
      filter(rank < 20) 
    
    frame_labels <- data_pop %>% 
      group_by(frame) %>%
      summarise(frame_label = first(frame_label)) %>%
      .$frame_label
    
    options <- list(title = "The most populous cities", 
                    subtitle = "3500 BC - 2000 AC", 
                    caption = "Source: Nasa Earth Data’s Historical Urban Population",
                    first_frame = 1, last_frame = max(data_pop$frame), 
                    top_n = top_n, tick_duration = duration,
                    height = 600, width = 960,
                    margin_top = 80, margin_right = 0, margin_bottom = 5, margin_left = 0,
                    frame_labels = frame_labels)
    
    gd3 <- r2d3(data = data_pop, 
                css = "www/styles.css", 
                script = "www/js/barchartrace.js", 
                width = width, 
                height = height, 
                options = options)
    
    file_out <- "www/out_bcr/brands.html"
    saveWidgetFix(widget = gd3, file = file_out, selfcontained = TRUE)
    
    tags$iframe(src = paste0("out_bcr/", basename(file_out)), height = "600", width = "100%", frameBorder = "0")
  })
  
  ##-- User bar chart race
  data_user <- eventReactive(input$dataset_user, {
    input_file <- input$dataset_user
    
    if(is.null(input_file)) {
      return(NULL)
    } else {
      out <- read.csv(input_file$datapath, header = TRUE)
    }
    
    return(out)
  })
  observe({
    out <- data_user()
    
    names <- colnames(out)
    shinyWidgets::updatePickerInput(session = session, inputId = "name_user", choices = names)
    shinyWidgets::updatePickerInput(session = session, inputId = "date_user", choices = names)
    shinyWidgets::updatePickerInput(session = session, inputId = "date_label_user", choices = names)
    shinyWidgets::updatePickerInput(session = session, inputId = "count_user", choices = names)
    shinyWidgets::updatePickerInput(session = session, inputId = "colour_user", choices = names)
  })
  output$user <- renderUI({
    ##-- Inputs
    duration <- input$duration_user
    top_n <- input$top_n_user
    
    ##-- Prepare R2D3
    frame_labels <- data_pop %>% 
      group_by(frame) %>%
      summarise(frame_label = first(frame_label)) %>%
      .$frame_label
    
    options <- list(title = "The most populous cities", 
                    subtitle = "3500 BC - 2000 AC", 
                    caption = "Source: Nasa Earth Data’s Historical Urban Population",
                    first_frame = 1, last_frame = max(data_pop$frame), 
                    top_n = top_n, tick_duration = duration,
                    height = 600, width = 960,
                    margin_top = 80, margin_right = 0, margin_bottom = 5, margin_left = 0,
                    frame_labels = frame_labels)
    
    gd3 <- r2d3(data = data_pop, 
                css = "www/styles.css", 
                script = "www/js/barchartrace.js", 
                width = width, 
                height = height, 
                options = options)
    
    file_out <- "www/out_bcr/brands.html"
    saveWidgetFix(widget = gd3, file = file_out, selfcontained = TRUE)
    
    tags$iframe(src = paste0("out_bcr/", basename(file_out)), height = "600", width = "100%", frameBorder = "0")
  })
  
  ##-- Songs
  observeEvent(input$mood_corona, {
    output$audio <- renderUI({
      mood <- tolower(input$mood_corona)
      HTML(sprintf("<div align = 'right'; style = 'padding:5px; vertical-align:middle'>
                      <audio controls controlsList = 'autoplay; nodownload'><source src='mp3/%s.mp3' type='audio/mp3'></audio>
                    </div>", mood))
    })
  })
  observeEvent(input$mood_brands, {
    output$audio <- renderUI({
      mood <- tolower(input$mood_brands)
      HTML(sprintf("<div align = 'right'; style = 'padding:5px; vertical-align:middle'>
                      <audio controls controlsList = 'nodownload'><source src='mp3/%s.mp3' type='audio/mp3'></audio>
                    </div>", mood))
    })
  })
  observeEvent(input$mood_pkgs, {
    output$audio <- renderUI({
      mood <- tolower(input$mood_pkgs)
      HTML(sprintf("<div align = 'right'; style = 'padding:5px; vertical-align:middle'>
                      <audio controls controlsList = 'nodownload'><source src='mp3/%s.mp3' type='audio/mp3'></audio>
                    </div>", mood))
    })
  })
  observeEvent(input$mood_pop, {
    output$audio <- renderUI({
      mood <- tolower(input$mood_pop)
      HTML(sprintf("<div align = 'right'; style = 'padding:5px; vertical-align:middle'>
                      <audio controls controlsList = 'nodownload'><source src='mp3/%s.mp3' type='audio/mp3'></audio>
                    </div>", mood))
    })
  })
}