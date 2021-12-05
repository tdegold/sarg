server <- function(input, output, session) {
  output$mytable = DT::renderDataTable({
    mtcars
  })
  
  output$data <- renderText(input$choices)
  
  output$pdfviewer <- renderUI(
    tags$iframe(style="height:900px; width:100%", src="Git.pdf")
  )
}