#' elevation_map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_elevation_map_ui <- function(id) {
  ns <- NS(id)
  tagList(
      highchartOutput(ns("stage_elevation"), height = 300)
  )
}

#' elevation_map Server Functions
#'
#' @noRd
mod_elevation_map_server <- function(id, filter_vars) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns
        idx <- reactive({
            idx <- as.numeric(gsub("[^0-9]", "", filter_vars$selected_stage()))
            return(idx)
        })

        output$stage_elevation <- renderHighchart({
            aux <- hchart(list_vuelta[[idx()]],
                          "areaspline",
                          name = "Altitude",
                          color = "green",
                          hcaes(x = distance,
                                y = altitude)) %>%
                hc_tooltip(formatter = JS("function() {
                            return ('Elevation: ' + this.y + ' m <br> Distance: ' + this.x.toFixed(2) + ' km')
                            }")
                           ) %>%
                ## This option is used to show a marker in the route map according
                ## to mouseover.
                hc_plotOptions(
                    series = list(
                        point = list(
                            events = list(
                                mouseOver = JS("function () {
                            Shiny.setInputValue('elevation_map_1-x_value', this.x);
                          }")
                          )
                        ),
                        events = list(
                            mouseOut = JS("function () {
                            Shiny.setInputValue('elevation_map_1-x_value', null);
                          }")
                        )
                    )
                )
            aux %>%
                hc_add_theme(thm)
        })
        return(list(x_value = reactive( {input$x_value} )))
    })
}

## To be copied in the UI
# mod_elevation_map_ui("elevation_map_1")

## To be copied in the server
# mod_elevation_map_server("elevation_map_1")
