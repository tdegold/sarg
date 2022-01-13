tab_beispielselector <- tabItem(tabName = "tab_beispielselector",
  fluidRow(
    column(4, uiOutput("exampleSelector")),
    column(4, textInput("examName", label = "Name der Schularbeit", value = "Schularbeit")),
    column(4, dateInput("examDate", label = "Datum der Schularbeit", value = Sys.Date(), format = "yyyy-mm-dd", language = "de"))
  ),
  DT::dataTableOutput("examplesChosenTable"),
  uiOutput("infoSection"),
  actionButton("generatePDF", "PDF generieren", class = "btn-success")
)
