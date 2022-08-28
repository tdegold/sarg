server <- function(input, output, session) {
  all_examples <- reactive({utils.get_all_examples()})

  output$tab_examples <- DT::renderDataTable({
    # file path exculed ([,1:4])
    DT::datatable(all_examples()[,1:4], selection = "single", options=list(columnDefs = list(list(visible=FALSE, targets=0))))
  })

  observe({
    req(is.null(input$tab_examples_rows_selected))
    output$selected_view <- renderUI({
        h1("Kein Beispiel markiert!")
    })
  })

  example_to_preview <- reactive({
    paste0(all_examples()[input$tab_examples_rows_selected,5], ".Rmd")
  })

  observe({
    req(input$tab_examples_rows_selected)
    output$selected_view <- renderUI({
      exams2html(example_to_preview(), dir = TEMP_PATH)
      withMathJax(includeHTML(paste0(TEMP_PATH, "/plain81.html")))
    })
  })

  output$exampleSelector <- renderUI({
    selectInput("examplesChosen", "Beispiele", all_examples()[,1], multiple = TRUE)
  })

  examples_selected <- reactive({
    all_examples()[which(all_examples()$Name %in% input$examplesChosen),]
  })

  output$examplesChosenTable <- DT::renderDataTable({
    DT::datatable(examples_selected()[,1:4],
                  selection = "none",
                  options = list(
                    columnDefs = list(list(visible=FALSE, targets=0)),
                    ordering = FALSE,
                    pageLength = 100))
  })

  observeEvent(input$generatePDF, {
    files_selected <- examples_selected()
    files_selected[,5] <- paste0(files_selected[,5], ".Rmd")
    files_selected <- utils.reorder(files_selected, userinput = input$orderText)

    f <- str_which(files_selected$Section, "maxima")
    files <- files_selected[,5]
    files_n <- files_selected[-f,5]
    files_m <- files_selected[f,5]

    dateX <- as.character(input$examDate)
    nameX <- paste0(input$examName, "_", dateX, c("_au", "_lo"))
    tableX <- as.character(utils.gen_pointscale_path(files))

    guid <- utils.path_replace(path = tempfile(pattern="", tmpdir = ""))

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

    if(input$examSplitMaxima){
      nameMaxima <- paste0(input$examName, "_", dateX, c("_maxima_au", "_maxima_lo"))

      for (i in 1:2) {
        exams2pdf(files_n, n=1, dir = pdfdir, texdir = lookup$texdir[i],
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
        exams2pdf(files_m, n=1, dir = pdfdir, texdir = lookup$texdirm[i],
                  name = paste0(nameMaxima, "_", lookup$gruppe[i]),
                  template = paste0(TEMPLATES_PATH,c("/tgm_maxima", "/tgm_solution")),
                  header = list(
                    Date = format.Date(dateX, format = "%d. %m. %Y"),
                    ID = lookup$gruppe[i],
                    Title = paste0(input$examName, " Teil 2"),
                    Komp = input$examKomp,
                    Class = input$examClass,
                    TableDir = tableX,
                    EnumStartAt = length(files_n)
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

    showNotification("Schularbeit(en) erstellt", type = "message")
  })

  observeEvent(input$generateMOODLE, {
    exams2moodle(
      file = paste0(examples_selected()[,5],".Rmd"),
      dir = NOPS_PATH,
      name = input$examName,
      zip = FALSE)

    showNotification("Moodle-Quiz erstellt", type = "message")
  })

  output$infoSection <- renderUI({
    column(width = 6,
      valueBox(length(input$examplesChosen), "Beispiele", color = "aqua", icon = icon("list-ol")),
      valueBox(sum(examples_selected()[3]), "Punkte gesamt", color = "green", icon = icon("chart-pie"))
    )
  })
}
