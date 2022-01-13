tab_beispielselector <- tabItem(tabName = "tab_beispielselector",
  uiOutput("exampleSelector"),
  DT::dataTableOutput("examplesChosenTable"),
  actionButton("generatePDF", "PDF generieren", class = "btn-success"),
  uiOutput("infoSection")
)