server <- function(input, output, session) {
  output$brands <- renderD3({
    
    duration <- input$duration_brands
    top_n <- input$top_brands
    
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
  
  output$corona <- renderD3({
    
    duration <- input$duration_corona
    top_n <- input$top_n_corona
    
    frame_labels <- data_corona %>% 
      group_by(frame) %>%
      summarise(frame_label = first(frame_label)) %>%
      .$frame_label
    
    options <- list(title = "Covid-19 outside China", 
                    subtitle = "Confirmed cases", 
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
  
  output$audio <- renderUI({
    HTML("<audio controls autoplay><source src='mp3/test.mp3' type='audio/mp3'></audio>")
  })
}