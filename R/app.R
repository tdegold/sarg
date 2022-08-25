library(DT)
library(exams)
library(rmarkdown)
library(shiny)
library(shinydashboard)
library(stringr)
library(xtable)

source("config.R")

source("utils.R")

source("ui/ui.R")

source("server/server.R")

shinyApp(ui, server)
