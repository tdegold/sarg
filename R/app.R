library(shiny)
library(shinydashboard)
library(DT)

source("ui/ui.R")

source("server/server.R")

shinyApp(ui, server)