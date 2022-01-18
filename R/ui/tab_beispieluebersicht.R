tab_beispieluebersicht <- tabItem(tabName = "tab_beispieluebersicht",
  h1("Beispiele"),
  br(),
  DT::dataTableOutput("tab_examples"),
  br(),
  fluidRow(
    column(width = 12,
      box(title = "Example Preview", collapsible = TRUE, width = 12, collapsed = FALSE,
        uiOutput("selected_view")
      )
    )
  )
)
