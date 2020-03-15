material_page(
  title = "",
  #nav_bar_color = "blue", 
  include_nav_bar = FALSE,
  tags$nav(htmlOutput("audio"), class = "blue"),
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
              htmlOutput(outputId = "corona", height = '515px')
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
              htmlOutput(outputId = "brands", height = '515px')
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
              htmlOutput(outputId = "pkgs", height = '515px')
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
              htmlOutput(outputId = "pop", height = '515px')
            )
          )
        )
      )
    )
  ),
  material_side_nav_tab_content(
    side_nav_tab_id = "upload_data",
  )
)