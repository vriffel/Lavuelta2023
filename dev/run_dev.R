# Set options here
options(golem.app.prod = FALSE) # TRUE = production mode, FALSE = development mode

# Comment this if you don't want the app to be served on a random port
options(shiny.port = httpuv::randomPort())

# Detach all loaded packages and clean your environment
## golem::detach_all_attached()
# rm(list=ls(all.names = TRUE))

# Document and reload your package
golem::document_and_reload()

##------------------------------------------------------------------------------
## Os pacotes carrega no description, certo?
require(sf)
require(shinydashboard)
require(shinybusy)
require(golem)
require(shiny)
require(stringr)
require(data.table)
require(leaflet)
require(highcharter)
require(gt)
require(gtExtras)
##------------------------------------------------------------------------------

##------------------------------------------------------------------------------
## Onde que eu carrego isso?
list_vuelta <- dget("~/Desktop/Dashboard_Vuelta/data/list_vuelta")
stage_summary <- fread("~/Desktop/Dashboard_Vuelta/data/stage_summary.csv")
starting_list <- fread("~/Desktop/Dashboard_Vuelta/data/starting_list.csv")
starting_list[, Country_abrv := str_to_lower(Country_abrv)]
starting_list[, Flag_link := paste0("https://hatscripts.github.io/circle-flags/flags/",
                                    Country_abrv,
                                    ".svg")]


thm <- hc_theme(
    chart = list(
        style = list(
            fontFamily = "Arial",
            fontSize = "16px"
        )
    ),
    title = list(
        style = list(
            fontSize = "24px"
        )
    ),
    xAxis = list(
        labels = list(
            style = list(
                fontSize = "14px"
            )
        )
    ),
    yAxis = list(
        labels = list(
            style = list(
                fontSize = "14px"
            )
        )
    )
)


stages_table <- stage_summary %>%
    select(id, start, finish, type, date, distance, elevation) %>%
    mutate(distance = round(distance, 2)) %>%
    gt() %>%
    tab_header(title = "La Vuelta 2023") %>%
    gt_theme_espn() %>%
    cols_label("id" = "Stage",
               "date" = "Date",
               "type" = "Stage type",
               "distance" = "Distance (km)",
               "elevation" = "Elevation gain (m)",
               "start" = "Starting city",
               "finish" = "Finshing city") %>%
    opt_interactive(use_search = TRUE) %>%
    cols_move(columns = c(date, type, distance, elevation, start, finish),
              after = id)
stages_table

stages_chart <- hchart(stage_summary, "scatter",
                       hcaes(x = distance,
                             y = elevation,
                             group = type,
                             text = label)) %>%
    hc_legend(title = list(text = "Type")) %>%
    hc_title(text = "Stages La Vuelta 2023") %>%
    hc_xAxis(title = list(text = "Distance")) %>%
    hc_yAxis(title = list(text = "Elevation Gain")) %>%
    hc_tooltip(pointFormat = "{point.text}") %>%
    hc_add_theme(thm)
stages_chart
##------------------------------------------------------------------------------


golem::document_and_reload()
run_app()
