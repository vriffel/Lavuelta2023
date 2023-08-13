#' stages UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_stages_ui <- function(id) {
  ns <- NS(id)
  tagList(
      gt_output(ns("stages_table")),
      highchartOutput(ns("stages_chart"))
  )
}

#' stages Server Functions
#'
#' @noRd
mod_stages_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    output$stages_table <- render_gt({
        stages_table
    })
    output$stages_chart <- renderHighchart({
        stages_chart
    })
  })
}

## To be copied in the UI
# mod_stages_ui("stages_1")

## To be copied in the server
# mod_stages_server("stages_1")
