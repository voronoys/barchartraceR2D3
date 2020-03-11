theme_mood <- function(type = "neutral") {
  general_theme <- theme_bw() +
    theme(panel.border = element_blank(),
          plot.title = element_text(face = 'bold', size = 80),
          plot.subtitle = element_text(size = 40),
          panel.grid.major.y = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.x = element_line(color = 'grey75'),
          panel.grid.minor.x = element_line(color = 'grey75'),
          legend.position = 'none',
          axis.ticks = element_blank(),
          axis.text.y =  element_blank(),
          axis.text.x =  element_text(size = 30))
  
  if(type == "neutral") {
    theme <- general_theme
  }
  
  return(theme)
}

palette_mood <- function(type = "neutral") {
  if(type == "neutral") {
    colors <- RColorBrewer::brewer.pal(n = 10, name = "Paired")
  }
  
  return(colors)
}