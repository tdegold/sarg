server <- function(input, output, session) {
  ### GENERATE LIST OF EXAMPLES FOR tab_beispieluebersicht
  get_examples <- function(){
    df_examples <- data.frame()
    
    for (ex in dir(path = EXAMPLES_PATH)) {
      name <- exams::read_metainfo(paste0(EXAMPLES_PATH,ex))$name
      points <- exams::read_metainfo(paste0(EXAMPLES_PATH,ex))$points
      section <- exams::read_metainfo(paste0(EXAMPLES_PATH,ex))$section
      file <- exams::read_metainfo(paste0(EXAMPLES_PATH,ex))$file
      
      df_examples <- rbind(df_examples, data.frame(name, section, points, file))
    }
    names(df_examples) <- c("Name", "Categories", "Points", "File")
    return(df_examples)
  }
  output$tab_examples <- renderDataTable({
    temp <- get_examples()
    DT::datatable(temp, selection = "single")
  })
  
  observe({
    req(input$tab_examples_rows_selected)
    mypath <- get_examples()[input$tab_examples_rows_selected,4]
    print(mypath)
    output$selected_html_view <- renderUI({
      exams2html(paste0(mypath,".Rmd"), dir = TEMP_PATH)
      
      includeHTML(paste0(TEMP_PATH, "/", "plain81.html"))
    })
  })
  
  output$data <- renderText(input$choices)
  
  output$pdfviewer <- renderUI(
    tags$iframe(style="height:900px; width:100%", src="Git.pdf")
  )
}
