material_page(
  title = "",
  include_nav_bar = FALSE,
  ##-- Including audio
  tags$nav(
    htmlOutput("audio"), 
    style = "background-color:#f1f3f4"
  ),
  ##-- Enabling shinyjs
  useShinyjs(),
  ##-- Enabling rintrojs
  introjsUI(),
  ##-- Global CSS
  shiny::includeCSS("www/styles_global.css"),
  ##-- Github button
  HTML("<script async defer src='https://buttons.github.io/buttons.js'></script>"),
  ##-- Sidebar
  material_side_nav(
    fixed = TRUE, 
    image_source = "img/material.png",
    material_side_nav_tabs(
      side_nav_tabs = c(
        "COVID-19 race" = "cv_race",
        "Brands race" = "b_race",
        "R packages race" = "pkgs_race",
        "Upload your own data" = "upload_data"
      ),
      icons = c("ac_unit", "copyright", "build", "cloud_upload")
    ),
    br(), 
    tags$div(style = "display:inherit; padding-top:3%; text-align:center;",
             ##-- Twitter
             tags$a(href = "https://twitter.com/https://twitter.com/share?ref_src=twsrc%5Etfw",
                    class = "twitter-share-button",
                    `data-hashtags` = "#rstats #rstudio #shinycontest #covid19 #coronavirus",
                    `data-show-count` = "true",
                    `data-url` = "https://voronoys.shinyapps.io/barchartraceR2D3",
                    `data-text1` = "Look at this bar chart race!"),
             
             ##-- Facebook
             tags$iframe(
               src = "https://www.facebook.com/plugins/share_button.php?href=https://voronoys.shinyapps.io/barchartraceR2D3/&layout=button_count&size=small&width=148&height=20&appId",
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
               `data-url` = "https://voronoys.shinyapps.io/barchartraceR2D3/"
             )
    ),
    br(),
    
    ##-- GitHub
    tags$a(
      href = "https://github.com/voronoys/barchartraceR2D3",
      tags$i(
        class = "fa fa-github", style = 'font-size:30px; color: black; display: list-item; padding-left: 10px; position: fixed; bottom: 70px;'
      )
    )
  ),
  
  ##-- COVID-19 ----
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
              choices = c("Confirmed cases", "Deaths"),
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
              label = "Duration (ms)",
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
              label = "# Bars",
              min_value = 2,
              max_value = 15,
              initial_value = 10,
              color = "blue"
            )
          ),
          material_floating_button2(input_id = "rebuild_corona", icon = "autorenew", color = "teal lighten-3", top = TRUE)
        ),
        material_card(
          title = "", 
          tags$div(
            material_checkbox(input_id = "china_corona", label = "Include China", initial_value = FALSE, color = "teal lighten-3")
          ),
          material_card(
            title = "",
            shinycssloaders::withSpinner(
              htmlOutput(outputId = "corona", height = '515px'), 
              type = 4, 
              color = col_spinner
            ),
          ),
          ##-- Download HTML
          downloadBttn(
            outputId = "corona_download",
            style = "bordered",
            color = "primary",
            size = "xs"
          ),
          ##-- Github
          HTML("<a class='github-button'
                   href='https://github.com/voronoys/barchartraceR2D3/archive/master.zip' 
                   data-color-scheme='no-preference: light; light: light; dark: dark;' 
                   aria-label='Download voronoys/barchartraceR2D3 on GitHub'>
                   Download
                </a>"
          )
        )
      )
    )
  ),
  
  ##-- BRANDS ----
  material_side_nav_tab_content(
    side_nav_tab_id = "b_race",
    tags$br(),
    material_row(
      material_column(
        width = 10,
        offset = 1,
        material_row(
          material_column(
            width = 3,
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
              label = "Duration (ms)",
              min_value = 0,
              max_value = 1000,
              initial_value = 500,
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_slider(
              input_id = "top_n_brands",
              label = "# Bars",
              min_value = 2,
              max_value = 15,
              initial_value = 10,
              color = "blue"
            )
          ),
          material_floating_button2(input_id = "rebuild_brands", icon = "autorenew", color = "teal lighten-3", top = TRUE)
        ),
        material_card(
          title = "",
          width = 12,
          material_card(
            title = "",
            shinycssloaders::withSpinner(
              htmlOutput(outputId = "brands", height = '515px'),
              type = 4, 
              color = col_spinner)
          ),
          ##-- Download HTML
          downloadBttn(
            outputId = "brands_download",
            style = "bordered",
            color = "primary",
            size = "xs"
          ),
          ##-- Github
          HTML("<a class='github-button' 
                   href='https://github.com/voronoys/barchartraceR2D3/archive/master.zip' 
                   data-color-scheme='no-preference: light; light: light; dark: dark;' 
                   aria-label='Download voronoys/barchartraceR2D3 on GitHub'>
                   Download
                </a>"
          )
        )
      )
    )
  ),
  
  ##-- R packages ----
  material_side_nav_tab_content(
    side_nav_tab_id = "pkgs_race",
    tags$br(),
    material_row(
      material_column(
        width = 10,
        offset = 1,
        material_row(
          material_column(
            width = 3,
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
              label = "Duration (ms)",
              min_value = 0,
              max_value = 1000,
              initial_value = 250,
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_slider(
              input_id = "top_n_pkgs",
              label = "# Bars",
              min_value = 2,
              max_value = 15,
              initial_value = 10,
              color = "blue"
            )
          ),
          material_floating_button2(input_id = "rebuild_pkgs", icon = "autorenew", color = "teal lighten-3", top = TRUE)
        ),
        material_card(
          title = "", 
          width = 12,
          material_card(
            title = "",
            shinycssloaders::withSpinner(
              htmlOutput(outputId = "pkgs", height = '515px'), 
              type = 4,
              color = col_spinner) 
          ),
          ##-- Download HTML
          downloadBttn(
            outputId = "pkgs_download",
            style = "bordered",
            color = "primary",
            size = "xs"
          ),
          ##-- Github
          HTML("<a class='github-button' 
                   href='https://github.com/voronoys/barchartraceR2D3/archive/master.zip' 
                   data-color-scheme='no-preference: light; light: light; dark: dark;' 
                   aria-label='Download voronoys/barchartraceR2D3 on GitHub'>
                   Download
                </a>"
          )
        )
      )
    )
  ),
  
  ##-- USER ----
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
              span('The dataset must have at least three columns: date, name and count.'),
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
                                 width = 3,
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
                                   label = "Duration (ms)",
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
                                   label = "# Bars",
                                   min_value = 2,
                                   max_value = 15,
                                   initial_value = 10,
                                   color = "blue"
                                 )
                               ),
                               material_floating_button2(input_id = "rebuild_user", icon = "autorenew", color = "teal lighten-3", top = TRUE)
                             ),
                             material_card(
                               title = "",
                               material_card(
                                 title = "",
                                 shinycssloaders::withSpinner(
                                   htmlOutput(outputId = "user", height = '515px'), 
                                   type = 4, 
                                   color = col_spinner
                                 )
                               ),
                               ##-- Download HTML
                               downloadBttn(
                                 outputId = "user_download",
                                 style = "bordered",
                                 color = "primary",
                                 size = "xs"
                               ),
                               ##-- Github
                               HTML("<a class='github-button' 
                                        href='https://github.com/voronoys/barchartraceR2D3/archive/master.zip' 
                                        data-color-scheme='no-preference: light; light: light; dark: dark;' 
                                        aria-label='Download voronoys/barchartraceR2D3 on GitHub'>
                                        Download
                                     </a>"
                               )
                             )
            ),
            conditionalPanel(condition = "!input.r2d3_user",
                             material_card(
                               title = "",
                               HTML("<h3 style='color:#707070;'>
                                       Select your data set using the
                                       <button data-target='upload_modal' display='inline-block' class='waves-effect waves-light shiny-material-modal-trigger modal-trigger teal lighten-3 btn-floating btn-large waves-effect waves-light z-depth-3' style='background-color:#F06C71;'>
                                         <i class='material-icons left'>cloud_upload</i>
                                       </button>
                                       button!
                                     </h3>
                                     <p style='color:#63636399;'>
                                       It must contain at least 3 columns:
                                     </p>
                                     <ul style='color:#63636399;'>
                                       <li>A column indicating the <b>group or name</b> of each bar. </li>
                                       <li>A <b>date column</b> or at least a numerical one. </li>
                                       <li>The <b>value</b> to be displayed. </li>
                                     </ul>
                                     <p style='color:#63636399;'>
                                       It is still possible to define the <b>frame label</b> and the <b>bar color</b> columns. If the colors are not present then a random set of colors is going to be used based on the mood.
                                       Do not forget to inform me whether the values must be accumulated over time (cumulative = Yes) or not!
                                     </p>
                                     <p style='color:#63636399;'>
                                       After uploading the data you will be able to select the <b>number of bars</b> to be displayed, the <b>transition speed</b> and the <b>mood</b>.
                                     </p>
                                     <h3 style='color:#707070;'>
                                       Enjoy!
                                     </h3>
                                    ")
                             )
            )
          )
        )
      )
    )
  ),
  ##-- Footer ----
  div(class = "footer",
      div(includeHTML("html/google_analytics.html"))
  ),
  HTML("<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src='//platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script>")
)
