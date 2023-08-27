#' results UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_results_ui <- function(id) {
  ns <- NS(id)
  tagList(
      selectInput(ns("stage_filter"),
                  "Select the stage",
                  choices = paste0("Stage ", 1:21, " (",
                                   stage_summary$start,
                                   " - ",
                                   stage_summary$finish, ")"),
                  selected = "Stage 1 (Barcelona - Barcelona)"),
      gt_output(ns("results_table"))
  )
}

#' results Server Functions
#'
#' @noRd
mod_results_server <- function(id) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns
        idx <- reactive({
            idx <- as.numeric(gsub("[^0-9]", "", input$stage_filter))
            return(idx)
        })
        output$results_table <- render_gt({
            stages_results[[idx()]] %>%
                gt() %>%
                tab_header(title = paste("Results of Stage", idx())) %>%
                gt_theme_espn() %>%
                opt_interactive(use_search = TRUE)
        })
    })
}

## To be copied in the UI
# mod_results_ui("results_1")

## To be copied in the server
# mod_results_server("results_1")
