tab_beispielselector <- tabItem(tabName = "tab_beispielselector",
  selectInput(
    "choices",
    "Beispiele",
    c("1", "2", "3"),
    multiple = TRUE
  ),
  textOutput("data")
)