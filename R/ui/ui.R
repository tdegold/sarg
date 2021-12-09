source("ui/tab_beispieluebersicht.R")
source("ui/tab_beispieleditor.R")
source("ui/tab_beispielselector.R")
source("ui/tab_preview.R")

ui  <- dashboardPage(
  # HEADER #
  dashboardHeader(),
  # SIDEBAR #
  dashboardSidebar(
    sidebarMenu(
      menuItem("Beispieluebersicht", tabName = "tab_beispieluebersicht", icon = icon("table")),
      menuItem("Beispieleditor", tabName = "tab_beispieleditor", icon = icon("file")),
      menuItem("Beispielselektor", tabName = "tab_beispielselector", icon = icon("list")),
      menuItem("Preview", tabName = "tab_preview", icon = icon("book"))
    )
  ),
  # BODY #
  dashboardBody(
    tabItems(
      tab_beispieluebersicht,
      tab_beispieleditor,
      tab_beispielselector,
      tab_preview
    )
  )
)
