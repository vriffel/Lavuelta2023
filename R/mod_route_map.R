#' route_map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_route_map_ui <- function(id) {
  ns <- NS(id)
  tagList(
      leafletOutput(ns("stage_route"), height = 300)
  )
}

#' route_map Server Functions
#'
#' @noRd
mod_route_map_server <- function(id, filter_vars, x_value) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns
        ##======================================================================
        idx <- reactive({
            idx <- as.numeric(gsub("[^0-9]", "", filter_vars$selected_stage()))
            return(idx)
        })
        var_filter <- reactive({
            filter_vars$selected_var()
        })
        ##======================================================================

        ##======================================================================
        ## Create map. The polyline will be added below, according to the
        ## selected var option.
        map <- reactive({
            ret <- leaflet(list_vuelta[[idx()]]) %>%
                addTiles() %>%
                ## add start maker.
                addMarkers(lng = list_vuelta[[idx()]]$lng[1],
                           lat = list_vuelta[[idx()]]$lat[1],
                           label = "Start") %>%
                ## add finish maker.
                addAwesomeMarkers(lng = list_vuelta[[idx()]]$lng[nrow(list_vuelta[[idx()]])],
                                  lat = list_vuelta[[idx()]]$lat[nrow(list_vuelta[[idx()]])],
                                  label = "Finish",
                                  icon = makeAwesomeIcon(icon = "flag-checkered",
                                                         library = "fa",
                                                         iconColor = "black"))
            ret
        })
        ##======================================================================

        ##======================================================================
        ## Render route map.
        output$stage_route <- renderLeaflet({
            show_modal_spinner(text = "Loading the map")
            ## If selected var is none, line color is define as black.
            if (var_filter() == "None") {
                map_plot <- map() %>%
                    addPolylines(color = "black")
                remove_modal_spinner()
                return(map_plot)
                ## Else use viridis palette with the values of elevation.
            } else {
                values <- st_drop_geometry(list_vuelta[[idx()]][, var_filter(), drop = TRUE])
                color_palette <- colorNumeric(palette = "viridis",
                                              domain = values)
                map_plot <- map() %>%
                    addPolylines(color = color_palette(values)) %>%
                    addLegend("bottomright",
                              pal = color_palette,
                              values = values,
                              opacity = 1)
                remove_modal_spinner()
                return(map_plot)
            }
        })
        ##======================================================================

        ##======================================================================
        ## Show a maker (on route map) according to mouse position (on elevation map)
        observeEvent(x_value$x_value(), {
            ## idx_dist indexes where the mouseover is.
            idx_dist <- which(x_value$x_value() == list_vuelta[[idx()]]$distance)[1]
            leafletProxy(ns("stage_route")) %>%
                ## Remove last marker
                clearGroup("position") %>%
                addCircles(lng = list_vuelta[[idx()]]$lng[idx_dist],
                           lat = list_vuelta[[idx()]]$lat[idx_dist],
                           color = "#fc0330",
                           radius = 100,
                           opacity = 1,
                           group = "position")
        })
        ##======================================================================
    })
}

## To be copied in the UI
# mod_route_map_ui("route_map_1")

## To be copied in the server
# mod_route_map_server("route_map_1")
