library(DT)
library(exams)
library(rmarkdown)
library(shiny)
library(shinyAce)
library(shinydashboard)

library(pipeR)

source("./config.R")

source("ui/ui.R")

source("server/server.R")

shinyApp(ui, server)
