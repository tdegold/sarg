server <- function(input, output, session) {
  ### GENERATE LIST OF EXAMPLES FOR tab_beispieluebersicht
  get_examples <- function(){
    df_examples <- data.frame()
    
    for (ex in dir(EXAMPLES_PATH)) {
      meta <- exams::read_metainfo(paste0(EXAMPLES_PATH,ex))
      df_examples <- rbind(df_examples, 
                           data.frame(meta$name, 
                                      paste(meta$section, collapse = ", "), 
                                      sum(meta$points), 
                                      meta$type,
                                      meta$file)
      )
    }
    names(df_examples) <- c("Name", "Section", "Sum of Points", "Type", "File")
    return(df_examples)
  }
  output$tab_examples <- renderDataTable({
    temp <- get_examples()[,1:4] # do not display the file-path
    DT::datatable(temp, selection = "single")
  })
  
  observe({
    req(input$tab_examples_rows_selected)
    mypath <- get_examples()[input$tab_examples_rows_selected,5]
    output$selected_view <- renderUI({
      exams2html(paste0(mypath,".Rmd"), dir = TEMP_PATH)
      withMathJax(includeHTML(paste0(TEMP_PATH, "/", "plain81.html")))
    })
  })
  
  output$data <- renderText(input$choices)
  
  output$pdfviewer <- renderUI(
    tags$iframe(style="height:900px; width:100%", src="Git.pdf")
  )
}
