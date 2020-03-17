material_page(
  title = "",
  include_nav_bar = FALSE,
  tags$nav(htmlOutput("audio"), class = "blue"),
  shiny::includeCSS("www/styles_global.css"),
  material_side_nav(
    fixed = TRUE, 
    image_source = "img/material.png",
    material_side_nav_tabs(
      side_nav_tabs = c(
        "Corona virus race" = "cv_race",
        "Brands race" = "b_race",
        "R packages race" = "pkgs_race",
        "Urban population race" = "pop_race",
        "Upload your own data" = "upload_data"
      ),
      icons = c("ac_unit", "copyright", "build", "person_pin_circle", "cloud_upload")
    )
  ),
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
        material_row(
          material_column(
            width = 12,
            material_card(
              title = "",
              shinycssloaders::withSpinner(htmlOutput(outputId = "corona", height = '515px'), type = 4, color = col_spinner),
              tags$br(),
              tags$div(
                ##Twitter
                tags$div(
                  style="display: inline;",
                  tags$a(href = "https://twitter.com/share?ref_src=twsrc%5Etfw", 
                         class = "twitter-share-button", 
                         `data-hashtags` = "#rstats #rstudio #shinycontest", 
                         `data-show-count` = "true", 
                         `data-text1` = "It's my barchartrace!",
                         "Tweet"),
                  tags$script(`async src`="https://platform.twitter.com/widgets.js", charset="utf-8")
                ),
                
                ##Facebbok
                tags$iframe(
                  src = "https://www.facebook.com/plugins/share_button.php?href=https://voronoys.shinyapps.io/voronoys/&layout=button_count&size=small&width=148&height=20&appId",
                  width="120",
                  height="20",
                  style="border:none;overflow:hidden",
                  scrolling="no",
                  frameborder="0",
                  allowTransparency="true",
                  allow="encrypted-media"
                ),
                tags$div(
                  style="display: inline;",
                ## Linkedin
                tags$script(
                  src = "https://platform.linkedin.com/in.js",
                  type = "text/javascript",
                  "lang: en_US"
                ),
                tags$script(
                  type = "IN/Share",
                  style = "vertical-align: top !important;",
                  `data-url` = "https://voronoys.shinyapps.io/voronoys"
                )
                )
              )
            )
          )
        )
      )
    )
  ),
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
        material_row(
          material_column(
            width = 12,
            material_card(
              title = "",
              shinycssloaders::withSpinner(htmlOutput(outputId = "brands", height = '515px'), type = 4, color = col_spinner)
            )
          )
        )
      )
    )
  ),
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
          material_column(
            width = 12,
            material_card(
              title = "",
              shinycssloaders::withSpinner(htmlOutput(outputId = "pkgs", height = '515px'), type = 4, color = col_spinner) 
            )
          )
        )
      )
    )
  ),
  material_side_nav_tab_content(
    side_nav_tab_id = "pop_race",
    tags$br(),
    material_row(
      material_column(
        width = 10,
        offset = 1,
        material_row(
          material_column(
            width = 6,
            material_dropdown(
              input_id = "mood_pop",
              label = "Theme mood", 
              choices = c("Happy", "Neutral", "Sad"), 
              selected = "Neutral", 
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_slider(
              input_id = "duration_pop",
              label = "Transition duration (milliseconds)",
              min_value = 0,
              max_value = 1000,
              initial_value = 250,
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_slider(
              input_id = "top_n_pop",
              label = "Number of bars",
              min_value = 2,
              max_value = 15,
              initial_value = 10,
              color = "blue"
            )
          )
        ),
        material_row(
          material_column(
            width = 12,
            material_card(
              title = "",
              shinycssloaders::withSpinner(htmlOutput(outputId = "pop", height = '515px'), type = 4, color = col_spinner) 
            )
          )
        )
      )
    )
  ),
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
            shinymaterial::material_modal(
              modal_id = "upload_modal", 
              button_text = "Upload", 
              button_icon = "cloud_upload", 
              button_color = "teal lighten-3", 
              floating_button = TRUE, 
              close_button_label = "Cancel",
              title = "Upload your data",
              span('The data set must have at least three columns: date, name and count.'),
              fileInput(inputId = "dataset_user", 
                        label = "Upload", 
                        accept = c(
                          "text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv"
                        )
              ),
              material_column(
                width = 12,
                material_column(width = 2,
                                shinyWidgets::pickerInput(inputId = "name_user", label = "Name column", choices = character(0))
                ),
                material_column(width = 2,
                                shinyWidgets::pickerInput(inputId = "date_user", label = "Date column", choices = character(0))
                ),
                material_column(width = 2,
                                shinyWidgets::pickerInput(inputId = "date_label_user", label = "Date label column", choices = character(0))
                ),
                material_column(width = 2,
                                shinyWidgets::pickerInput(inputId = "count_user", label = "Count column", choices = character(0))
                ),
                material_column(width = 2,
                                shinyWidgets::pickerInput(inputId = "colour_user", label = "Colour column", choices = character(0))
                )
              ),
              tags$style("height:'600px'")
            ),
            conditionalPanel(condition = "input.upload_data_user",
                             material_card(
                               title = "",
                               shinycssloaders::withSpinner(
                                 htmlOutput(outputId = "user", height = '515px'), 
                                 type = 4, 
                                 color = col_spinner)
                             )
            ),
            conditionalPanel(condition = "!input.upload_data_user",
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
