##-- Packages
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)
library(cranlogs)
library(shiny)
library(shinymaterial)
library(shinycssloaders)
library(shinyWidgets)
library(shinyBS)
library(shinyjs)
library(rintrojs)
library(r2d3)

source(file = "R/utils.R")

##-- Data corona
data_corona <- get_corona_data()

##-- Data brands
data_brands <- read.table(file = "data/brand_values.csv", sep = ",", dec = ".", header = TRUE, quote = "\"")

##-- Data pacakges
pkgs_file <- "data/R_packages.csv"

if(!file.exists(pkgs_file)) {
  data_pkgs <- get_pkgs_data()
  write.table(x = data_pkgs, file = pkgs_file, sep = ";", row.names = FALSE)
} else {
  data_pkgs <- read.table(file = pkgs_file, sep = ";", dec = ".", header = TRUE)
}

##-- Global definitions
height <- 515
width <- "100%"
col_spinner <- "#2196F3" 

##-- Out path
dir.create(path = "www/out_bcr", showWarnings = FALSE)