server <- function(input, output, session) {
  ##-- COVID-19 bar chart race
  output$corona <- renderD3({
    ##-- Inputs
    duration <- input$duration_corona
    top_n <- input$top_n_corona
    
    type_sel <- switch(input$type_corona,
                       "Confirmed cases" = "Confirmed",
                       "Deaths" = "Deaths",
                       "Recovered" = "Recovered")
    
    ##-- Prepare data
    data_corona <- data_corona %>%
      filter(type == type_sel & name != "China") %>%
      prepare_data(date = "date", date_label = "date", name = "name", value = "value") 
    
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
    
    r2d3(data = data_corona, 
         css = "www/styles.css", 
         script = "www/js/barchartrace2.js", 
         width = 960, 
         height = 600, 
         options = options)
  })
  
  ##-- Brands bar chart race
  output$brands <- renderD3({
    browser()
    ##-- Inputs
    duration <- input$duration_brands
    top_n <- input$top_brands
    
    ##-- Prepare R2D3
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
    
    r2d3(data = data_brands, 
         css = "www/styles.css", 
         script = "www/js/barchartrace2.js", 
         width = 960, 
         height = 600, 
         options = options)
  })
  
  ##-- R packages bar chart race
  output$pkgs <- renderD3({
    ##-- Inputs
    duration <- input$duration_pkgs
    top_n <- input$top_pkgs
    
    ##-- Prepare R2D3
    data_pkgs <- data_pkgs %>%
      prepare_data(date = "date", date_label = "date", name = "package", value = "count") 
    
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
    
    r2d3(data = data_pkgs, 
         css = "www/styles.css", 
         script = "www/js/barchartrace2.js", 
         width = 960, 
         height = 600, 
         options = options)
  })
  
  output$audio <- renderUI({
    HTML("<audio controls autoplay><source src='mp3/test.mp3' type='audio/mp3'></audio>")
  })
}