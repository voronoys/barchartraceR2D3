server <- function(input, output, session) {
  output$barchart_race <- renderD3({
    
    duration <- input$duration
    top_n <- input$top_n
    
    options <- list(title = "18 years of Interbrand’s Top Global Brands", 
                    subtitle = "Brand value, $m", 
                    caption = "Source: Interbrand",
                    first_frame = 2010, last_frame = 2018, 
                    top_n = top_n, tick_duration = duration,
                    height = 600, width = 960,
                    margin_top = 80, margin_right = 0, margin_bottom = 5, margin_left = 0)
    
    r2d3(data = data_tst, 
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