#' dashboardPage UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_dashboardPage_ui <- function(id) {
    ns <- NS(id)
    tagList(
        dashboardPage(skin = "black",
                      header = dashboardHeader(title = HTML("La vuelta 2023"),
                                               disable = FALSE,
                                               titleWidth  = 500,
                                               dropdownMenuCustom(
                                                   type = "message",
                                                   customSentence = customSentence,
                                                   messageItem(
                                                       from = "viniciusricardoriffel@gmail.com",
                                                       message =  "",
                                                       icon = icon("envelope"),
                                                       href = "mailto:viniciusricardoriffel@gmail.com"
                                                   ),
                                                   icon = icon('comment')
                                               )
                                               ),
                      sidebar = dashboardSidebar(
                          width = 200,
                          sidebarMenu(
                              id = ns("sidebar"),
                              style = "position: relative; overflow: visible;",
                              menuItem("About", tabName = "about"),
                              menuItem("Stages", tabName = "stages",
                                       icon = icon("info")
                                       ), ## Stages Summary
                              menuItem("Stage Overview", tabName = "overview",
                                       icon = icon("magnifying-glass")
                                       ), ## menuItem overview
                              menuItem("Results", tabName = "results",
                                       icon = icon("circle-info")
                                       ), ## menuItem Results
                              menuItem("Standings", tabName = "Standings",
                                       icon = icon("list")
                                       ), ## menuItem Stadings
                              menuItem("Teams", tabName = "teams"
                                       ) ## menuItem Teams
                          ) ## sidebarMenu
                      ),
                      body = dashboardBody(
                          tabItems(
                              tabItem(
                                  tabName = "about",
                                  includeMarkdown("about.md")
                              ),
                              tabItem(
                                  tabName = "stages",
                                  fluidRow(mod_stages_ui("stages_1")),
                                  ), ## tabItem Stages
                              tabItem(
                                  tabName = "overview",
                                  fluidRow(
                                      column(width = 4,
                                             selectInput(ns("selected_stage"),
                                                         "Select the stage",
                                                         choices = paste0("Stage ", 1:21, " (",
                                                                          stage_summary$start,
                                                                          " - ",
                                                                          stage_summary$finish, ")"),
                                                         selected = "Stage 1 (Barcelona - Barcelona)"),
                                             ),
                                      column(width = 4,
                                             selectInput(ns("selected_var"),
                                                         "Select the variable to be plotted",
                                                         choices = c("None"= "None",
                                                                     "Altitude" = "altitude"),
                                                         selected = "None")
                                             )
                                  ),
                                  fluidRow(
                                      ## Adds value boxes
                                      mod_value_boxes_ui("value_boxes_1")
                                  ),
                                  fluidRow(
                                      mod_route_map_ui("route_map_1"),
                                      mod_elevation_map_ui("elevation_map_1")
                                  )
                              ), ##tabItem overview
                              tabItem(tabName = "teams",
                                      fluidRow(column(width = 4,
                                                      selectInput(ns("filter_team"),
                                                                  "Team filter",
                                                                  choices = c("None",
                                                                              sort(unique(starting_list$Team))),
                                                                  selected = "None")
                                                      ),
                                               column(width = 4,
                                                      selectInput(ns("filter_country"),
                                                                  "Country filter",
                                                                  choices = c("None",
                                                                              sort(unique(starting_list$Country))),
                                                                  selected = "None"))
                                               ), ## tabItem
                                      mod_team_ui("team_1")
                                      ) ## tabItem teams
                          ) ## tabItems
                      )),
        tags$footer("Created by Vinicius Riffel")
    ) ## tagList
}


#' dashboardPage Server Functions
#'
#' @noRd
mod_dashboardPage_server <- function(id){
  moduleServer(id, function(input, output, session){
      ns <- session$ns
      return(
          list(
              selected_stage = reactive({ input$selected_stage }),
              selected_var = reactive({ input$selected_var }),
              filter_country = reactive({ input$filter_country }),
              filter_team = reactive({ input$filter_team })
          )
      )
  })
}

## To be copied in the UI
# mod_dashboardPage_ui("dashboardPage_1")
##------------------------------------------------------------------------------
