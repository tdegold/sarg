tab_beispieluebersicht <- tabItem(tabName = "tab_beispieluebersicht",
  h1("Examples"),
  br(),
  DT::dataTableOutput("tab_examples"),
  br(),
  fluidRow(
    column(width = 12,
      box(title = "Example Preview", collapsible = TRUE, width = 12, collapsed = TRUE,
        uiOutput("selected_view")
      )
    )
  )
)
