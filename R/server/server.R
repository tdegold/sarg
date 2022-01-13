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
    DT::datatable(temp, selection = "single", options=list(columnDefs = list(list(visible=FALSE, targets=0))))
  })
  
  observe({
    req(is.null(input$tab_examples_rows_selected))
    output$ace_editor <- renderUI({
      h1("First, select an example on the first tab!")
    })
    
    output$selected_view <- renderUI({
        h1("No example selected!")
    })
  })
  
  observe({
    req(input$tab_examples_rows_selected)
    # tab_beispieluebersciht
    gen_path <- function(){
      return(paste0(get_examples()[input$tab_examples_rows_selected,5], ".Rmd"))
    }
    
    output$selected_view <- renderUI({
      exams2html(gen_path(), dir = TEMP_PATH)
      withMathJax(includeHTML(paste0(TEMP_PATH, "/", "plain81.html")))
    })
    # tab_beispieleditor
    output$ace_editor <- renderUI({
      tagList(
      aceEditor("file_content", 
                value = readChar(gen_path(), file.info(gen_path())$size),
                mode = "r",
                showLineNumbers = TRUE
      ),
      actionButton("ace_save", label = "Update Example", class = "btn-success")
      )
    })
    
    observeEvent(input$ace_save, {
      #TODO write file_content to respective file
      showNotification("Example saved", type = "message")
    })
  })
  
  output$exampleSelector <- renderUI({
    selectInput("examplesChosen", "Beispiele", get_examples()[,1], multiple = TRUE)
  })
  
  get_selected <- function(){
    f <- which(get_examples()$Name %in% input$examplesChosen)
    return(get_examples()[f,])
  }
  
  output$examplesChosenTable <- DT::renderDataTable({
    DT::datatable(get_selected()[,1:4], selection = "none", options=list(columnDefs = list(list(visible=FALSE, targets=0))))
  })
  
  observeEvent(input$generatePDF, {
    files <- paste0(get_selected()[,5],".Rmd")
    exams2pdf(files, n=2, dir = NOPS_PATH, 
              name = c("sa_au", "sa_lo"), template = c("exam", "solution"), showpoints = TRUE)
  })
  
  output$infoSection <- renderUI({
    column(width = 12,
      infoBox("Anzahl Beispiele", value = length(input$examplesChosen), color = "aqua"),
      infoBox("Punkte gesamt", value = sum(get_selected()[3]), color = "green")
    )
  })
  
  output$pdfviewer <- renderUI(
    tags$iframe(style="height:900px; width:100%", src="Git.pdf")
  )
}
