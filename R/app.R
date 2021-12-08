library(DT)
library(exams)
library(shiny)
library(shinydashboard)

source("./config.R")

source("ui/ui.R")

source("server/server.R")

shinyApp(ui, server)