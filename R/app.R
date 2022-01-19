library(DT)
library(exams)
library(pipeR)
library(rim)
library(rmarkdown)
library(shiny)
library(shinyAce)
library(shinydashboard)
library(stringr)
library(xtable)

source("./config.R")

source("ui/ui.R")

source("server/server.R")

shinyApp(ui, server)
