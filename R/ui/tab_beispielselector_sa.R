tab_beispielselector_sa <- tabItem(tabName = "tab_beispielselector_sa",
  fluidRow(
    box(title = "Eingabe", status = "primary", width = 12,
      column(width = 4, uiOutput("exampleSelector")),
      column(width = 4, selectInput("examClass", label = "Jahrgang", c("1xHIT", "2xHIT", "3xHIT", "4xHIT", "5xHIT")),
             textInput("examName", label = "Name der Schularbeit", value = "x. Schularbeit AM"),
             textInput("examKomp", label = "Kompetenzbereich", value = "S03B: Trigonometrie")),
      column(width = 4, dateInput("examDate", label = "Datum der Schularbeit", value = Sys.Date(), format = "dd. mm. yyyy", language = "de"),
             strong("Maxima-Einstellungen"),
             checkboxInput("examSplitMaxima", label = "Maxima-Teil separat?"))
    ),
  ),
  fluidRow(
    column(width = 12,
      DT::dataTableOutput("examplesChosenTable")
    )
  ),
  fluidRow(
    column(width = 12,
           textInput("orderText", label = "Reihenfolge", value = "")
    )
  ),
  fluidRow(
     uiOutput("infoSection")
  ),
  fluidRow(
    column(12,
           actionButton("generatePDF", "PDF generieren", class = "btn-success"),
           actionButton("generateMOODLE", "Moodle-XML generieren", class = "btn-success")
    )
  )
)
