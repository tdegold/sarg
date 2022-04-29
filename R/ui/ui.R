source("ui/tab_beispieluebersicht.R")
source("ui/tab_beispielselector_sa.R")

ui  <- dashboardPage(
  # HEADER #
  dashboardHeader(title = "SARG2.0"),
  # SIDEBAR #
  dashboardSidebar(
    sidebarMenu(
      menuItem("Beispieluebersicht", tabName = "tab_beispieluebersicht", icon = icon("table")),
      menuItem("Beispielselektor", tabName = "tab_beispielselector", icon = icon("list"), startExpanded = TRUE,
               menuSubItem("Schularbeit", tabName = "tab_beispielselector_sa"))
    )
  ),
  # BODY #
  dashboardBody(
    tabItems(
      tab_beispieluebersicht,
      tab_beispielselector_sa
    )
  )
)
