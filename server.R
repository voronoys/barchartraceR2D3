server <- function(input, output, session) {
  runjs("$('#dataset_user').parent().removeClass('btn-default').addClass('btn-danger');")
  
  ##-- Introduction
  introjs(session = session, 
          options = list(steps =
                           data.frame(
                             element = c(NA, 
                                         "#slide-out",
                                         "#cv_race > div > div > div.row > div:nth-child(1)",
                                         "#cv_race > div > div > div.row > div:nth-child(2)",
                                         "#duration_corona",
                                         "#top_n_corona",
                                         "#rebuild_corona_div",
                                         "#corona",
                                         "#corona_download_bttn",
                                         "#cv_race > div > div > div.card > div > span:nth-child(5)"
                             ),
                             intro = c("Before start looking at the races let's have a tour in our app!", 
                                       "We provide three examples of bar chart races at the sidebar: COVID-19, brand value, and most downloaded R packages. Also, it is possible to upload your dataset.",
                                       "For COVID-19 you can select the outcome: confirmed cases or deaths.",
                                       "The mood: neutral, sad or happy...",
                                       "The duration speed. The higher the duration the slower the transition.",
                                       "The number of bars to be displayed.",
                                       "Rebuild the plot after changing the controls.",
                                       "Finally, you have the bar chart race displayed in the middle of the screen.",
                                       "Download it in HTML format!",
                                       "Download the app from GitHub!"
                             )
                           ),
                         nextLabel = "Next",
                         prevLabel = "Previous",
                         skipLabel = "Skip",
                         doneLabel = "Done")
  )
  
  ##-- COVID-19 bar chart race
  output$corona <- renderUI({
    ##-- Inputs
    input$rebuild_corona
    
    duration <- isolate(input$duration_corona)
    top_n <- isolate(input$top_n_corona)
    mood <- isolate(tolower(input$mood_corona))
    type <- isolate(input$type_corona)
    
    type_sel <- switch(type,
                       "Confirmed cases" = "confirmed",
                       "Deaths" = "deaths")
    
    ##-- Prepare data
    data_corona <- data_corona %>%
      filter(type == type_sel & name != "China") %>%
      filter(value != 0)
    
    ##-- Prepare R2D3
    subtitle <- switch(type_sel,
                       "confirmed" = "Confirmed cases (cumulative)",
                       "deaths" = "Number of deaths (cumulative)")
    
    gd3 <- barchartrace_r2d3(
      data = data_corona, 
      name = "name", date = "date", value = "value", date_label = "date", colour = "name", 
      cumulative = FALSE, 
      title = "COVID-19 outside China", 
      subtitle = subtitle, 
      caption = "Source: John Hopkins University", 
      mood = mood, top_n = top_n, duration = duration, 
      css = "www/styles.css", script = "www/js/barchartrace.js", 
      width = width, height = height,
      margin = c(80, 20, 0, 0)
    )
    
    file_out <- "www/out_bcr/covid19.html"
    saveWidgetFix(widget = gd3, file = file_out, selfcontained = TRUE)
    
    tags$iframe(src = paste0("out_bcr/", basename(file_out)), height = "600", width = "100%", frameBorder = "0")
  })
  output$corona_download <- downloadHandler(
    filename = function() {
      sprintf("covid19_%s.html", Sys.Date())
    },
    content = function(con) {
      file.copy(from = "www/out_bcr/covid19.html", con)
    }
  )
  
  ##-- Brands bar chart race
  output$brands <- renderUI({
    ##-- Inputs
    input$rebuild_brands
    
    duration <- isolate(input$duration_brands)
    top_n <- isolate(input$top_n_brands)
    mood <- isolate(tolower(input$mood_brands))
    
    ##-- Prepare R2D3
    data_brands <- data_brands %>%
      mutate(frame_label = str_sub(string = year, start = 1, end = 4))
    
    gd3 <- barchartrace_r2d3(
      data = data_brands, 
      name = "name", date = "year", value = "value", date_label = "frame_label", colour = "name", 
      cumulative = FALSE, 
      title = "18 years of Interbrand’s Top Global Brands", 
      subtitle = "Brand value, $m", 
      caption = "Source: Interbrand", 
      mood = mood, top_n = top_n, duration = duration, 
      css = "www/styles.css", script = "www/js/barchartrace.js", 
      width = width, height = height,
      margin = c(80, 20, 0, 0)
    )
    
    file_out <- "www/out_bcr/brands.html"
    saveWidgetFix(widget = gd3, file = file_out, selfcontained = TRUE)
    
    tags$iframe(src = paste0("out_bcr/", basename(file_out)), height = "600", width = "100%", frameBorder = "0")
  })
  output$brands_download <- downloadHandler(
    filename = function() {
      "brands.html"
    },
    content = function(con) {
      file.copy(from = "www/out_bcr/brands.html", con)
    }
  )
  
  ##-- R packages bar chart race
  output$pkgs <- renderUI({
    ##-- Inputs
    input$rebuild_pkgs
    
    duration <- isolate(input$duration_pkgs)
    top_n <- isolate(input$top_n_pkgs)
    mood <- isolate(tolower(input$mood_pkgs))
    
    ##-- Prepare R2D3
    data_pkgs <- data_pkgs %>%
      mutate(month = month(date, abbr = TRUE, label = TRUE),
             day = day(date),
             frame_label = paste0(month, "/", day))
    
    gd3 <- barchartrace_r2d3(
      data = data_pkgs, 
      name = "package", date = "date", value = "count", date_label = "frame_label", colour = "package", 
      cumulative = TRUE, 
      title = "Most downloaded R packages in 2019", 
      subtitle = "Based on the 100 most downloaded packages last month", 
      caption = "Source: cranlogs", 
      mood = mood, top_n = top_n, duration = duration, 
      css = "www/styles.css", script = "www/js/barchartrace.js", 
      width = width, height = height,
      margin = c(80, 20, 0, 0)
    )
    
    file_out <- "www/out_bcr/pkgs.html"
    saveWidgetFix(widget = gd3, file = file_out, selfcontained = TRUE)
    
    tags$iframe(src = paste0("out_bcr/", basename(file_out)), height = "600", width = "100%", frameBorder = "0")
  })
  output$pkgs_download <- downloadHandler(
    filename = function() {
      "R_packages.html"
    },
    content = function(con) {
      file.copy(from = "www/out_bcr/pkgs.html", con)
    }
  )
  
  ##-- User bar chart race
  data_user <- eventReactive(input$dataset_user, {
    input_file <- input$dataset_user
    
    if(is.null(input_file)) {
      return(NULL)
    } else {
      input_file <- input_file$datapath
      ext <- tools::file_ext(input_file)
      
      if(ext != "csv") {
        sendSweetAlert(
          width = "1000px",
          session = session,
          title = "Error...",
          text = "We can only accept csv files at the moment.",
          type = "error"
        )
        
        out <- NULL
      } else {
        ##-- Tryig sep = ","
        out <- read.table(input_file, header = TRUE, sep = ";", quote = "\"", comment.char = "", stringsAsFactors = FALSE)
        
        ##-- Tryig sep = ";"
        if(ncol(out) == 1) 
          out <- read.table(input_file, header = TRUE, sep = ",", quote = "\"", comment.char = "", stringsAsFactors = FALSE)
        
        ##-- Tryig sep = "\t"
        if(ncol(out) == 1) 
          out <- read.table(input_file, header = TRUE, sep = "\t", quote = "\"", comment.char = "", stringsAsFactors = FALSE)
        
        ##-- 
        if(ncol(out) == 1) {
          sendSweetAlert(
            width = "1000px",
            session = session,
            title = "Error...",
            text = "We can only accept the following separators: ',', ';' and '\t'.",
            type = "error"
          )
          
          out <- NULL
        } 
      }
    }
    
    return(out)
  })
  observe({
    out <- data_user()
    
    if(!is.null(out)) {
      names <- c("", colnames(out))
      
      update_material_dropdown(session = session, input_id = "name_user", choices = names, value = names[1])
      update_material_dropdown(session = session, input_id = "date_user", choices = names, value = names[1])
      update_material_dropdown(session = session, input_id = "date_label_user", choices = names, value = names[1])
      update_material_dropdown(session = session, input_id = "count_user", choices = names, value = names[1])
      update_material_dropdown(session = session, input_id = "colour_user", choices = names, value = names[1]) 
      
      shinyjs::enable(id = "r2d3_user")
    }
  })
  
  observeEvent(input$r2d3_user_close, {
    close_material_modal(session = session, modal_id = "upload_modal")
  })
  data_user_plot <- eventReactive(c(input$r2d3_user, input$rebuild_user), {
    ##-- Get data
    data <- data_user()
    
    name <- input$name_user 
    date <- input$date_user 
    value <- input$count_user
    
    ##-- Checking empty columns
    if(name == "" || date == "" || value == "") {
      sendSweetAlert(
        width = "1000px",
        session = session,
        title = "Error...",
        text = "You must provide, at least, name, date and value columns.",
        type = "error"
      )
      
      return(NULL)
    } 
    
    ##-- Checking problems
    ##-- + Date class
    err01 <- !(class(data[[date]]) %in% c("integer", "numeric"))
    
    if(err01) {
      data[[date]] <- parse_date_time(x = data[[date]], orders = c("ymd", "dmy", "ydm", "ym", "md"))
      err01 <- any(is.na(data[[date]]))
    }
    
    if(err01) {
      sendSweetAlert(
        width = "1000px",
        session = session,
        title = "Error...",
        text = "Date must be in a date format (e.g. YYYY/mm/dd or dd-mm-YYYY) or at least be a numeric vector",
        type = "error"
      )
      
      return(NULL)
    }
    ##-- Value class
    err02 <- !(class(data[[value]]) %in% c("integer", "numeric"))
    
    if(err01) {
      sendSweetAlert(
        width = "1000px",
        session = session,
        title = "Error...",
        text = "Value must be in an integer or a numeric vector",
        type = "error"
      )
      
      return(NULL)
    }
    
    ##-- Repeated names by date class
    test_n <- data %>%
      group_by_(name, date) %>%
      summarise(n = n())
    
    if(any(test_n$n > 1)) {
      sendSweetAlert(
        width = "1000px",
        session = session,
        title = "Error...",
        text = sprintf("There is more than one entry for a combination of %s and %s.", name, date),
        type = "error"
      )
      
      return(NULL)
    }
    
    ##-- Close material
    close_material_modal(session = session, modal_id = "upload_modal")
    
    ##-- Parameters
    date_label <- ifelse(test = input$date_label_user == "", yes = input$date_user, no = input$date_label_user)
    colour <- ifelse(test = input$colour_user == "", yes = input$name_user, no = input$colour_user)
    
    cumulative_user <- ifelse(test = input$cumulative_user %in% c("", "No"), yes = FALSE, no = TRUE)
    
    title <- input$title_user
    subtitle <- input$subtitle_user
    caption <- input$caption_user
    
    mood <- ifelse(is.null(input$mood_user), "neutral", tolower(input$mood_user))
    duration <- ifelse(is.null(input$duration_user), 500, input$duration_user)
    top_n <- ifelse(is.null(input$top_n_user), 12, input$top_n_user)
    
    gd3 <- barchartrace_r2d3(
      data = data, 
      name = name, date = date, value = value, date_label = date_label, colour = colour, 
      cumulative = cumulative_user, 
      title = title, 
      subtitle = subtitle, 
      caption = caption, 
      mood = mood, top_n = top_n, duration = duration, 
      css = "www/styles.css", script = "www/js/barchartrace.js", 
      width = width, height = height,
      margin = c(80, 20, 0, 0)
    )
    
    file_out <- "www/out_bcr/barchartrace.html"
    saveWidgetFix(widget = gd3, file = file_out, selfcontained = TRUE)
    
    return(file_out)
  })
  output$user <- renderUI({
    file_out <- data_user_plot()
    
    if(!is.null(file_out)) {
      ##-- file
      file_out <- gsub(x = file_out, pattern = "www/", replacement = "")
      
      ##-- Plot
      tags$iframe(src = file_out, height = "600", width = "100%", frameBorder = "0")
    }
  })
  output$user_download <- downloadHandler(
    filename = function() {
      "barchartrace.html"
    },
    content = function(con) {
      file.copy(from = "www/out_bcr/barchartrace.html", con)
    }
  )
  
  ##-- Songs
  observeEvent(input$mood_corona, {
    output$audio <- renderUI({
      mood <- tolower(input$mood_corona)
      HTML(sprintf("<div align = 'right'; style = 'padding:5px; vertical-align:middle'>
                      <div id='audioid'><<audio controls controlsList = 'autoplay loop; nodownload'><source src='mp3/%s.mp3' type='audio/mp3'></audio></div>
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
  observeEvent(input$mood_user, {
    output$audio <- renderUI({
      mood <- tolower(input$mood_user)
      HTML(sprintf("<div align = 'right'; style = 'padding:5px; vertical-align:middle'>
                      <audio controls controlsList = 'nodownload'><source src='mp3/%s.mp3' type='audio/mp3'></audio>
                    </div>", mood))
    })
  })
}