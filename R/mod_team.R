#' team UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_team_ui <- function(id) {
    ns <- NS(id)
    tagList(
        gt_output(ns("teams_table"))
    )
}

#' team Server Functions
#'
#' @noRd
mod_team_server <- function(id, filter_vars) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns
        output$teams_table <- render_gt({
            tab_data <- starting_list
            if (filter_vars$filter_team() != "None") {
                tab_data <- subset(starting_list, Team == filter_vars$filter_team())
            }
            if (filter_vars$filter_country() != "None") {
                tab_data <- subset(tab_data, Country == filter_vars$filter_country())
            }
            tab <- tab_data %>%
                select(Name, Team, Flag_link) %>%
                gt() %>%
                tab_header(title = "Starting list La Vuelta 2023") %>%
                gt_theme_espn() %>%
                gt_merge_stack(col1 = Name, col2 = Team) %>%
                gt_img_rows(columns = Flag_link,
                            height = 40,
                            img_source = "web") %>%
                cols_label("Flag_link" = "Country") %>%
                opt_interactive(use_search = TRUE)
            tab
        })
    })
}

## To be copied in the UI
# mod_team_ui("team_1")

## To be copied in the server
# mod_team_server("team_1")
