tab_beispieleditor <- tabItem(tabName = "tab_beispieleditor",
  textAreaInput("file_content", value = readChar("ui/ui.R", file.info("ui/ui.R")$size), "Beispiel", width = "50%", rows = 25),
)