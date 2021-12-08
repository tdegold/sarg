server <- function(input, output, session) {
  ### GENERATE LIST OF EXAMPLES FOR tab_beispieluebersicht
  output$tab_examples <- renderDataTable({
    df_examples <- data.frame()
    
    for (ex in dir(path = EXAMPLES_PATH)) {
      name <- exams::read_metainfo(paste0(EXAMPLES_PATH,ex))$name
      points <- exams::read_metainfo(paste0(EXAMPLES_PATH,ex))$points
      section <- exams::read_metainfo(paste0(EXAMPLES_PATH,ex))$section
      
      df_examples <- rbind(df_examples, data.frame(name, section, points))
    }
    names(df_examples) <- c("Name", "Categories", "Points")
    DT::datatable(df_examples)
  })
  
  output$data <- renderText(input$choices)
  
  output$pdfviewer <- renderUI(
    tags$iframe(style="height:900px; width:100%", src="Git.pdf")
  )
}
