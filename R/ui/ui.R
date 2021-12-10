source("ui/tab_beispieluebersicht.R")
source("ui/tab_beispieleditor.R")
source("ui/tab_beispielselector.R")
source("ui/tab_preview.R")

ui  <- dashboardPage(
  # HEADER #
  dashboardHeader(title = "SARG2.0"),
  # SIDEBAR #
  dashboardSidebar(
    sidebarMenu(
      sidebarMenu(style = "position: fixed; overflow: visible;",
        menuItem("Beispieluebersicht", tabName = "tab_beispieluebersicht", icon = icon("table")),
        menuItem("Beispieleditor", tabName = "tab_beispieleditor", icon = icon("file")),
        menuItem("Beispielselektor", tabName = "tab_beispielselector", icon = icon("list")),
        menuItem("Preview", tabName = "tab_preview", icon = icon("book"))
      )
    )
  ),
  # BODY #
  dashboardBody(
    tabItems(
      tab_beispieluebersicht
      #tab_beispieleditor,
      #tab_beispielselector,
      #tab_preview
    )
  )
)
