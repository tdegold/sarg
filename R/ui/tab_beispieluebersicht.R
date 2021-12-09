tab_beispieluebersicht <- tabItem(tabName = "tab_beispieluebersicht",
  DT::dataTableOutput("tab_examples"),
  uiOutput("selected_view")
)
