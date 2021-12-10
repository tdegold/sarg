library(DT)
library(exams)
library(rmarkdown)
library(shiny)
library(shinyAce)
library(shinydashboard)

source("./config.R")

source("ui/ui.R")

source("server/server.R")

shinyApp(ui, server)
