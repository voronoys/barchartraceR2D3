material_page(
  title = "",
  include_nav_bar = FALSE,
  tags$nav(htmlOutput("audio"), class = "blue"),
  useShinyjs(),
  shiny::includeCSS("www/styles_global.css"),
  ##-- Sidebar
  material_side_nav(
    fixed = TRUE, 
    image_source = "img/material.png",
    material_side_nav_tabs(
      side_nav_tabs = c(
        "Corona virus race" = "cv_race",
        "Brands race" = "b_race",
        "R packages race" = "pkgs_race",
        "Upload your own data" = "upload_data"
      ),
      icons = c("ac_unit", "copyright", "build", "cloud_upload")
    )
  ),
  ##-- COVID-19
  material_side_nav_tab_content(
    side_nav_tab_id = "cv_race",
    tags$br(),
    material_row(
      material_column(
        width = 10,
        offset = 1,
        material_row(
          material_column(
            width = 3,
            material_dropdown(
              input_id = "type_corona",
              label = "Variable", 
              choices = c("Confirmed cases", "Deaths", "Recovered"),
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_dropdown(
              input_id = "mood_corona",
              label = "Theme mood", 
              choices = c("Happy", "Neutral", "Sad"),
              selected = "Neutral",
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_slider(
              input_id = "duration_corona",
              label = "Transition duration (milliseconds)",
              min_value = 0,
              max_value = 1000,
              initial_value = 700,
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_slider(
              input_id = "top_n_corona",
              label = "Number of bars",
              min_value = 2,
              max_value = 15,
              initial_value = 10,
              color = "blue"
            )
          )
        ),
        material_card(
          title = "", 
          material_card(
            title = "",
            shinycssloaders::withSpinner(htmlOutput(outputId = "corona", height = '515px'), type = 4, color = col_spinner),
          ),
          
          ##-- Social networks
          tags$div(style = "display: inline; vertical-align: top;",
                   ##-- Twitter
                   tags$a(href = "https://twitter.com/https://twitter.com/share?ref_src=twsrc%5Etfw1", 
                          class = "twitter-share-button", 
                          `data-hashtags` = "#rstats #rstudio #shinycontest #covid19 #coronavirus", 
                          `data-show-count` = "true", 
                          `data-text1` = "It's my barchart race!",
                          id = "corona"),
                   tags$script(`async src` = "https://platform.twitter.com/widgets.js", charset = "utf-8"),
                   
                   ##-- Facebook
                   tags$iframe(
                     src = "https://www.facebook.com/plugins/share_button.php?href=https://voronoys.shinyapps.io/voronoys/&layout=button_count&size=small&width=148&height=20&appId",
                     width = "115",
                     height = "20",
                     scrolling = "no",
                     frameborder = "0",
                     allowTransparency = "true",
                     allow = "encrypted-media"
                   ),
                   
                   ##-- LinkedIn
                   tags$script(
                     src = "https://platform.linkedin.com/in.js",
                     type = "text/javascript",
                     "lang: en_US"
                   ),
                   tags$script(
                     type = "IN/Share",
                     `data-url` = "https://voronoys.shinyapps.io/voronoys"
                   ),
          ),
          
          ##-- Download HTML
          downloadBttn(
            outputId = "corona_download",
            style = "bordered",
            color = "primary",
            size = "xs"
          )
        )
      )
    )
  ),
  ##-- BRANDS
  material_side_nav_tab_content(
    side_nav_tab_id = "b_race",
    tags$br(),
    material_row(
      material_column(
        width = 10,
        offset = 1,
        material_row(
          material_column(
            width = 6,
            material_dropdown(
              input_id = "mood_brands",
              label = "Theme mood", 
              choices = c("Happy", "Neutral", "Sad"),
              selected = "Neutral",
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_slider(
              input_id = "duration_brands",
              label = "Transition duration (milliseconds)",
              min_value = 0,
              max_value = 1000,
              initial_value = 700,
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_slider(
              input_id = "top_n_brands",
              label = "Number of bars",
              min_value = 2,
              max_value = 15,
              initial_value = 10,
              color = "blue"
            )
          )
        ),
        material_card(
          title = "",
          width = 12,
          material_card(
            title = "",
            shinycssloaders::withSpinner(htmlOutput(outputId = "brands", height = '515px'), type = 4, color = col_spinner)
          ),
          ##-- Social networks
          tags$div(style = "display: inline; vertical-align: top;",
                   ##-- Twitter
                   tags$a(href = "https://twitter.com/share?ref_src=twsrc%5Etfw2", 
                          class = "twitter-share-button", 
                          `data-hashtags` = "#rstats #rstudio #shinycontest", 
                          `data-show-count` = "true", 
                          `data-text1` = "It's my barchart race!",
                          id = "brands"),
                   tags$script(`async src` = "https://platform.twitter.com/widgets.js", charset = "utf-8"),
                   
                   ##-- Facebook
                   tags$iframe(
                     src = "https://www.facebook.com/plugins/share_button.php?href=https://voronoys.shinyapps.io/voronoys/&layout=button_count&size=small&width=148&height=20&appId",
                     width = "115",
                     height = "20",
                     scrolling = "no",
                     frameborder = "0",
                     allowTransparency = "true",
                     allow = "encrypted-media"
                   ),
                   
                   ##-- LinkedIn
                   tags$script(
                     src = "https://platform.linkedin.com/in.js",
                     type = "text/javascript",
                     "lang: en_US"
                   ),
                   tags$script(
                     type = "IN/Share",
                     `data-url` = "https://voronoys.shinyapps.io/voronoys"
                   ),
          ),
          
          ##-- Download HTML
          downloadBttn(
            outputId = "brands_download",
            style = "bordered",
            color = "primary",
            size = "xs"
          )
        )
      )
    )
  ),
  ##-- R packages
  material_side_nav_tab_content(
    side_nav_tab_id = "pkgs_race",
    tags$br(),
    material_row(
      material_column(
        width = 10,
        offset = 1,
        material_row(
          material_column(
            width = 6,
            material_dropdown(
              input_id = "mood_pkgs",
              label = "Theme mood", 
              choices = c("Happy", "Neutral", "Sad"),
              selected = "Neutral",
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_slider(
              input_id = "duration_pkgs",
              label = "Transition duration (milliseconds)",
              min_value = 0,
              max_value = 1000,
              initial_value = 700,
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_slider(
              input_id = "top_n_pkgs",
              label = "Number of bars",
              min_value = 2,
              max_value = 15,
              initial_value = 10,
              color = "blue"
            )
          )
        ),
        material_row(
          material_card(
            title = "", 
            width = 12,
            material_card(
              title = "",
              shinycssloaders::withSpinner(htmlOutput(outputId = "pkgs", height = '515px'), type = 4, color = col_spinner) 
            ),
            ##-- Social networks
            tags$div(style = "display: inline; vertical-align: top;",
                     ##-- Twitter
                     tags$a(href = "https://twitter.com/share?ref_src=twsrc%5Etfw3", 
                            class = "twitter-share-button", 
                            `data-hashtags` = "#rstats #rstudio #shinycontest", 
                            `data-show-count` = "true", 
                            `data-text1` = "It's my barchart race!",
                            id = "pkgs"),
                     tags$script(`async src` = "https://platform.twitter.com/widgets.js", charset = "utf-8"),
                     
                     ##-- Facebook
                     tags$iframe(
                       src = "https://www.facebook.com/plugins/share_button.php?href=https://voronoys.shinyapps.io/voronoys/&layout=button_count&size=small&width=148&height=20&appId",
                       width = "115",
                       height = "20",
                       scrolling = "no",
                       frameborder = "0",
                       allowTransparency = "true",
                       allow = "encrypted-media"
                     ),
                     
                     ##-- LinkedIn
                     tags$script(
                       src = "https://platform.linkedin.com/in.js",
                       type = "text/javascript",
                       "lang: en_US"
                     ),
                     tags$script(
                       type = "IN/Share",
                       `data-url` = "https://voronoys.shinyapps.io/voronoys"
                     ),
            ),
            
            ##-- Download HTML
            downloadBttn(
              outputId = "pkgs_download",
              style = "bordered",
              color = "primary",
              size = "xs"
            )
          )
        )
      )
    )
  ),
  ##-- USER
  material_side_nav_tab_content(
    side_nav_tab_id = "upload_data",
    tags$br(),
    material_row(
      material_column(
        width = 10,
        offset = 1,
        material_row(
          material_column(
            width = 12,
            ##-- Modal upload data
            material_modal(
              modal_id = "upload_modal", 
              button_text = "Upload", 
              button_icon = "cloud_upload", 
              button_color = "teal lighten-3", 
              floating_button = TRUE, 
              close_button_label = NULL,
              title = "Upload your data",
              span('The data set must have at least three columns: date, name and count.'),
              br(), br(), 
              material_column(
                width = 12,
                ##-- Upload data
                material_column(
                  width = 2,
                  ##-- Data
                  fileInput(inputId = "dataset_user", 
                            label = "Upload a csv dataset", 
                            accept = c(
                              "text/csv",
                              "text/comma-separated-values,text/plain",
                              ".csv"
                            )
                  )
                ),
                ##-- Data columns
                material_column(
                  width = 12,
                  material_column(
                    width = 2,
                    material_dropdown(
                      input_id = "name_user",
                      label = "Name column",
                      choices = "",
                      color = "blue")
                  ),
                  material_column(
                    width = 2,
                    material_dropdown(
                      input_id = "date_user",
                      label = "Date column",
                      choices = "",
                      color = "blue"
                    )
                  ),
                  material_column(
                    width = 2,
                    material_dropdown(
                      input_id = "date_label_user",
                      label = "Date label column",
                      choices = "",
                      color = "blue"
                    )
                  ),
                  material_column(
                    width = 2,
                    material_dropdown(
                      input_id = "count_user",
                      label = "Count column",
                      choices = "",
                      color = "blue"
                    )
                  ),
                  material_column(
                    width = 2,
                    material_dropdown(
                      input_id = "colour_user",
                      label = "Colour column",
                      choices = "",
                      color = "blue"
                    )
                  ),
                  material_column(
                    width = 2,
                    material_dropdown(
                      input_id = "cumulative_user",
                      label = "should we accumulate?",
                      choices = c("", "Yes", "No"), 
                      selected = "",
                      color = "blue"
                    )
                  ),
                  material_column(
                    width = 4,
                    material_text_box(
                      input_id = "title_user", 
                      label = "Title",
                      color = "blue"
                    )
                  ),
                  material_column(
                    width = 4,
                    material_text_box(
                      input_id = "subtitle_user", 
                      label = "Subtitle",
                      color = "blue"
                    )
                  ),
                  material_column(
                    width = 4,
                    material_text_box(
                      input_id = "caption_user", 
                      label = "Caption",
                      color = "blue"
                    )
                  )
                )
              ),
              material_column(
                width = 3, offset = 9, 
                br(), br(), br(), br(),
                shinyjs::disabled(material_button(input_id = "r2d3_user", label = "Go!", icon = "play_arrow", color = "#26a69a")),
                material_button(input_id = "r2d3_user_close", label = "close", icon = "close", color = "#26a69a")
              ),
              tags$style("height: '700px'")
            ),
            ##-- Plot
            conditionalPanel(condition = "input.r2d3_user",
                             material_row(
                               material_column(
                                 width = 6,
                                 material_dropdown(
                                   input_id = "mood_user",
                                   label = "Theme mood", 
                                   choices = c("Happy", "Neutral", "Sad"),
                                   selected = "Neutral",
                                   color = "blue"
                                 )
                               ),
                               material_column(
                                 width = 3,
                                 material_slider(
                                   input_id = "duration_user",
                                   label = "Transition duration (milliseconds)",
                                   min_value = 0,
                                   max_value = 1000,
                                   initial_value = 700,
                                   color = "blue"
                                 )
                               ),
                               material_column(
                                 width = 3,
                                 material_slider(
                                   input_id = "top_n_user",
                                   label = "Number of bars",
                                   min_value = 2,
                                   max_value = 15,
                                   initial_value = 10,
                                   color = "blue"
                                 )
                               )
                             ),
                             material_card(
                               title = "",
                               material_card(
                                 title = "",
                                 shinycssloaders::withSpinner(
                                   htmlOutput(outputId = "user", height = '515px'), 
                                   type = 4, 
                                   color = col_spinner)
                               ),
                               ##-- Social networks
                               tags$div(style = "display: inline; vertical-align: top;",
                                        ##-- Twitter
                                        tags$a(href = "https://twitter.com/share?ref_src=twsrc%5Etfw2", 
                                               class = "twitter-share-button", 
                                               `data-hashtags` = "#rstats #rstudio #shinycontest", 
                                               `data-show-count` = "true", 
                                               `data-text1` = "It's my barchart race!",
                                               id = "brands"),
                                        tags$script(`async src` = "https://platform.twitter.com/widgets.js", charset = "utf-8"),
                                        
                                        ##-- Facebook
                                        tags$iframe(
                                          src = "https://www.facebook.com/plugins/share_button.php?href=https://voronoys.shinyapps.io/voronoys/&layout=button_count&size=small&width=148&height=20&appId",
                                          width = "115",
                                          height = "20",
                                          scrolling = "no",
                                          frameborder = "0",
                                          allowTransparency = "true",
                                          allow = "encrypted-media"
                                        ),
                                        
                                        ##-- LinkedIn
                                        tags$script(
                                          src = "https://platform.linkedin.com/in.js",
                                          type = "text/javascript",
                                          "lang: en_US"
                                        ),
                                        tags$script(
                                          type = "IN/Share",
                                          `data-url` = "https://voronoys.shinyapps.io/voronoys"
                                        ),
                               ),
                               ##-- Download HTML
                               downloadBttn(
                                 outputId = "user_download",
                                 style = "bordered",
                                 color = "primary",
                                 size = "xs"
                               )
                             )
            ),
            conditionalPanel(condition = "!input.r2d3_user",
                             material_card(
                               title = "Instructions",
                               p("Select your data set below! It must contains at least 3 columns:"),
                               tags$ul(
                                 tags$li(p(HTML("<b>name</b>: a column indicating the group or name of each bar."))),
                                 tags$li(p(HTML("<b>date</b>: a date column or at leats a numerical one."))),
                                 tags$li(p(HTML("<b>count</b>: the value to be displayed.")))
                               ),
                               p("It is still possible to define the frame label and the bar colors.
                                  If the colors are not present then a random set of colors are going to be used based on the mood."),
                               p("Do not forget to inform if the values must to be cumulative or not!")
                             )
            )
          )
        )
      )
    )
  )
)
