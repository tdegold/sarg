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
      withMathJax(includeHTML(paste0(TEMP_PATH, "/plain81.html")))
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

  punkteTable <- function(x){
    d1 <- c("Punkte für Beispiel")
    j <- 1
    d2 <- data.frame("maximal erreichbar:")
    asum <- 0
    d3 <- data.frame("erreicht:")
    format <- "|c|l"
    for(i in x){
      d1 <- cbind(d1, as.character(j))
      j <- j+1
      meta <- exams::read_metainfo(paste0(EXAMPLES_PATH,"/",i))
      asum = asum + sum(meta$points)
      d2 <- cbind(d2, as.character(sum(meta$points)))
      d3 <- cbind(d3, "")
      format <- paste0(format, "|c")
    }
    d1 <- cbind(d1, "Summe")
    d2 <- cbind(d2, as.character(asum))
    d3 <- cbind(d3, "")
    names(d2) <- 1:length(d2)
    names(d3) <- 1:length(d3)
    d <- rbind(d2, d3)
    names(d) <- d1
    table <- xtable(d)
    format <- paste0(format, "|c|")
    align(table) <- format
    temf <- tempfile()
    print(table, include.rownames = FALSE, hline.after = c(-1:dim(d)[1]), floating = FALSE, file = temf)
    if(Sys.info()[1] == "Windows"){
      return(str_replace_all(temf, "\\\\", "/"))
    }else{
      return(temf)
    }
  }

  observeEvent(input$generatePDF, {
    files <- paste0(get_selected()[,5],".Rmd")
    dateX <- as.character(input$examDate)
    nameX <- paste0(input$examName, "_", dateX, c("_au", "_lo"))
    tableX <- as.character(punkteTable(files))

    guid <- tempfile(pattern="", tmpdir = "")

    if(Sys.info()[1] == "Windows"){
      guid <- str_replace_all(guid, "\\\\", "")
    }else{
      guid <- str_replace_all(guid, "/", "")
    }

    main_dir <- paste0(OUTPUT_PATH, input$examClass, "_", input$examName, "_", dateX, "_", guid)
    pdfdir <- paste0(main_dir, "/pdf")
    grAdir <- paste0(main_dir, "/grA")
    grBdir <- paste0(main_dir, "/grB")

    grAtex <- paste0(grAdir, "/tex")
    grBtex <- paste0(grBdir, "/tex")

    grAtexm <- paste0(grAdir, "/texm")
    grBtexm <- paste0(grBdir, "/texm")

    dir.create(main_dir)
    dir.create(pdfdir)

    dir.create(grAdir)
    dir.create(grBdir)
    dir.create(grAtex)
    dir.create(grBtex)
    dir.create(grAtexm)
    dir.create(grBtexm)

    lookup <- list(
      gruppe = c("A", "B"),
      texdir = c(grAtex, grBtex),
      texdirm =c(grAtexm, grBtexm)
    )

    f <- str_which(get_selected()$Section, "maxima")
    if(input$examSplitMaxima){
      filesMaxima <- files[f]
      filesNormal <- files[-f]
      nameMaxima <- paste0(input$examName, "_", dateX, c("_maxima_au", "_maxima_lo"))

      for (i in 1:2) {
        exams2pdf(filesNormal, n=1, dir = pdfdir, texdir = lookup$texdir[i],
                  name = paste0(nameX, "_", lookup$gruppe[i]),
                  template = paste0(TEMPLATES_PATH,c("/tgm_exam", "/tgm_solution")),
                  header = list(
                    Date = format.Date(dateX, format = "%d. %m. %Y"),
                    ID = lookup$gruppe[i],
                    Title = paste0(input$examName, " Teil 1"),
                    Komp = input$examKomp,
                    Class = input$examClass,
                    TableDir = tableX
                  ), )
        exams2pdf(filesMaxima, n=1, dir = pdfdir, texdir = lookup$texdirm[i],
                  name = paste0(nameMaxima, "_", lookup$gruppe[i]),
                  template = paste0(TEMPLATES_PATH,c("/tgm_maxima", "/tgm_solution")),
                  header = list(
                    Date = format.Date(dateX, format = "%d. %m. %Y"),
                    ID = lookup$gruppe[i],
                    Title = paste0(input$examName, " Teil 2"),
                    Komp = input$examKomp,
                    Class = input$examClass,
                    TableDir = tableX,
                    EnumStartAt = length(filesNormal)
                  ))
      }
    }else{
      for (i in 1:2) {
        exams2pdf(files, n=1, dir = pdfdir, texdir = lookup$texdir[i],
                  name = paste0(nameX, "_", lookup$gruppe[i]),
                  template = paste0(TEMPLATES_PATH,c("/tgm_exam", "/tgm_solution")),
                  header = list(
                    Date = format.Date(dateX, format = "%d. %m. %Y"),
                    ID = lookup$gruppe[i],
                    Title = input$examName,
                    Komp = input$examKomp,
                    Class = input$examClass,
                    TableDir = tableX,
                    InclMaxima = ifelse(length(f)>0, "true", "false")
                  ))
      }
    }
    showNotification("Exam(s) generated", type = "message")
  })

  observeEvent(input$generateMOODLE, {
    files <- paste0(get_selected()[,5],".Rmd")
    exams2moodle(files, dir = NOPS_PATH, name = input$examName, zip = FALSE)
  })

  output$infoSection <- renderUI({
    column(width = 6,
      valueBox(length(input$examplesChosen), "Beispiele", color = "aqua", icon = icon("list-ol")),
      valueBox(sum(get_selected()[3]), "Punkte gesamt", color = "green", icon = icon("chart-pie"))
    )
  })

  output$pdfviewer <- renderUI(
    tags$iframe(style="height:900px; width:100%", src="Git.pdf")
  )
}
