tab_beispieluebersicht <- tabItem(tabName = "tab_beispieluebersicht",
  h1("Beispiele"),
  br(),
  DT::dataTableOutput("tab_examples"),
  uiOutput("selected_view")
)
