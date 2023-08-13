#' value_boxes UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_value_boxes_ui <- function(id) {
  ns <- NS(id)
  tagList(
      valueBoxOutput(ns("stage_type")),
      valueBoxOutput(ns("stage_km")),
      valueBoxOutput(ns("stage_elevation_total"))
  )
}

#' value_boxes Server Functions
#'
#' @noRd
mod_value_boxes_server <- function(id, filter_vars){
    moduleServer(id, function(input, output, session) {
        ns <- session$ns
        ##======================================================================
        ## Create text for the boxes
        idx <- reactive({
            idx <- as.numeric(gsub("[^0-9]", "", filter_vars$selected_stage()))
            return(idx)
        })
        stage_type_text <- reactive({
            text <- stage_summary[idx(), "type"]
            return(text)
        })
        stage_km_text <- reactive({
            value <- round(max(list_vuelta[[idx()]][, "distance", drop = TRUE]), 2)
            text <- paste0(value, " km")
            return(text)
        })
        stage_elevation_text <- reactive({
            d <- diff(list_vuelta[[idx()]][, "altitude", drop = TRUE])
            value <- sum(d[d > 0])
            text <- paste0(value, " m")
            return(text)
        })
        ##======================================================================

        ##======================================================================
        ## Render boxes
        output$stage_type <- renderValueBox({
            valueBox(stage_type_text(), "Stage type")
        })
        output$stage_km <- renderValueBox({
            valueBox(stage_km_text(), "Total distance")
        })
        output$stage_elevation_total <- renderValueBox({
            valueBox(stage_elevation_text(), "Elevation gain")
        }
        )
        ##======================================================================
    })
}

## To be copied in the UI
# mod_value_boxes_ui("value_boxes_1")

## To be copied in the server
# mod_value_boxes_server("value_boxes_1")
