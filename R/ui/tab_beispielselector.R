tab_beispielselector <- tabItem(tabName = "tab_beispielselector",
  uiOutput("exampleSelector"),
  DT::dataTableOutput("examplesChosenTable"),
  uiOutput("infoSection")
)