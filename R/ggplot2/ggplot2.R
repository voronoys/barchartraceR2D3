##-- Packages
library(dplyr)
library(ggplot2)
library(gganimate)

source("R/utils.R")

##-- Data
load("data/pkg_data.RData")

anim_data <- pkg_data %>%
  group_by(date) %>%
  filter(rank <= 10) %>%
  ungroup() %>%
  mutate(label = paste0(year, " - ", month))

lbl_pos <- 0.85*max(anim_data$cum_count)

##-- Plot
gg <- ggplot(data = anim_data, mapping = aes(x = rank)) +
  geom_tile(mapping = aes(y = cum_count/2, 
                          fill = group, 
                          height = cum_count, 
                          width = 0.9), 
            alpha = 0.8, color = "transparent") +
  geom_text(aes(y = 0, label = var), size = 12) +
  geom_text(aes(y = cum_count, size = 12, label = cum_count)) +
  geom_text(aes(x = 10, y = lbl_pos, label = label), size = 30, color = 'gray45') +
  coord_flip() +
  scale_fill_manual(values = palette_mood(type = "neutral")) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_reverse() +
  guides(fill = FALSE) +
  labs(title = 'Most downloaded R packages', subtitle = '2019-2020', x = '', y = '') +
  theme_mood(type = "neutral") +
  transition_manual(frames = date) +
  ease_aes("cubic-in-out")

animate(plot = gg, fps = 10, width = 2000, height = 1200)
