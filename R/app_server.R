#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
    filtervars <- mod_dashboardPage_server("dashboardPage_1")
    mod_value_boxes_server("value_boxes_1", filter_vars = filtervars)
    mod_elevation_map_server("elevation_map_1", filter_vars = filtervars)
    x_value <- mod_elevation_map_server("elevation_map_1", filter_vars = filtervars)
    mod_route_map_server("route_map_1", filter_vars = filtervars, x_value = x_value)
    mod_team_server("team_1", filter_vars = filtervars)
    mod_stages_server("stages_1")
    mod_results_server("results_1")
}
