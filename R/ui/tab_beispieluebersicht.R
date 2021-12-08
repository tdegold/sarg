tab_beispieluebersicht <- tabItem(tabName = "tab_beispieluebersicht",
  DT::dataTableOutput("tab_examples"),
  htmlOutput("selected_html_view")
)
