material_page(
  title = "",
  nav_bar_color = "blue",
  material_side_nav(
    fixed = TRUE, 
    image_source = "img/material.png",
    material_side_nav_tabs(
      side_nav_tabs = c(
        "Brands race" = "b_race",
        "Corona virus race" = "cv_race",
        "Upload your own data" = "upload_data"
      ),
      icons = c("copyright", "ac_unit", "cloud_upload")
    ),
    htmlOutput("audio")
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
              input_id = "moode",
              label = "Theme mood", 
              choices = c("Neutral", "Dark", "Sad", "Happy"),
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_slider(
              input_id = "duration",
              label = "Transition duration (milliseconds)",
              min_value = 0,
              max_value = 1000,
              initial_value = 500,
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_slider(
              input_id = "top_n",
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
              d3Output(outputId = "barchart_race", height = '600px')
            )
          )
        )
      )
    )
  ),
  material_side_nav_tab_content(
    side_nav_tab_id = "cv_race",
    tags$br()
  ),
  material_side_nav_tab_content(
    side_nav_tab_id = "upload_data",
    tags$br()
  ),
)