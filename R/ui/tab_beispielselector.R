tab_beispielselector <- tabItem(tabName = "tab_beispielselector",
  fluidRow(
    column(4, uiOutput("exampleSelector")),
    column(4, selectInput("examClass", label = "Jahrgang", c("1xHIT", "2xHIT", "3xHIT", "4xHIT", "5xHIT")),
           textInput("examName", label = "Name der Schularbeit", value = "x. Schularbeit AM"),
           textInput("examKomp", label = "Kompetenzbereich", value = "S03B: Trigonometrie")),
    column(4, dateInput("examDate", label = "Datum der Schularbeit", value = Sys.Date(), format = "dd. mm. yyyy", language = "de"),
           strong("Maxima-Einstellungen"),
           checkboxInput("examInclMaxima", label = "Schularbeit mit Maxima?"),
           checkboxInput("examSplitMaxima", label = "Maxima-Teil separat?"))
  ),
  DT::dataTableOutput("examplesChosenTable"),
  uiOutput("infoSection"),
  fluidRow(
    column(12, 
           actionButton("generatePDF", "PDF generieren", class = "btn-success"),
           actionButton("generateMOODLE", "Moodle-XML generieren", class = "btn-success")
    )
  )
)
