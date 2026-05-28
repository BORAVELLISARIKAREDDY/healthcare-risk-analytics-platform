library(shiny)
library(shinydashboard)
library(plotly)
library(DT)

shinyUI(

dashboardPage(

  dashboardHeader(
    title = "Healthcare Risk Analytics"
  ),

  dashboardSidebar(

    sidebarMenu(

      menuItem(
        "Upload Data",
        tabName = "upload",
        icon = icon("upload")
      ),

      menuItem(
        "Dashboard",
        tabName = "dashboard",
        icon = icon("dashboard")
      ),

      menuItem(
        "Predictions",
        tabName = "predictions",
        icon = icon("heartbeat")
      ),

      menuItem(
        "Model Analytics",
        tabName = "analytics",
        icon = icon("chart-bar")
      )
    )
  ),

  dashboardBody(

    tabItems(

      # ---------------- UPLOAD TAB ----------------

      tabItem(

        tabName = "upload",

        fluidRow(

          box(
            title = "Upload Healthcare Dataset",
            width = 6,
            status = "primary",
            solidHeader = TRUE,

            fileInput(
              "file_upload",
              "Upload CSV File",
              accept = ".csv"
            ),

            br(),

            helpText(
              "Upload healthcare dataset in CSV format"
            )
          )
        )
      ),

      # ---------------- DASHBOARD TAB ----------------

      tabItem(

        tabName = "dashboard",

        fluidRow(

          valueBoxOutput("total_patients"),

          valueBoxOutput("high_risk"),

          valueBoxOutput("avg_bmi")
        ),

        fluidRow(

          box(
            title = "Dataset Preview",
            width = 12,

            DTOutput("data_table")
          )
        ),

        fluidRow(

          box(
            title = "Age Distribution",
            width = 6,

            plotlyOutput("age_plot")
          ),

          box(
            title = "BMI Distribution",
            width = 6,

            plotlyOutput("bmi_plot")
          )
        )
      ),

      # ---------------- PREDICTIONS TAB ----------------

      tabItem(

        tabName = "predictions",

        fluidRow(

          box(
            title = "Risk Prediction",
            width = 6,

            numericInput(
              "glucose",
              "Glucose",
              120
            ),

            numericInput(
              "bmi",
              "BMI",
              25
            ),

            numericInput(
              "age",
              "Age",
              30
            ),

            actionButton(
              "predict_btn",
              "Predict Risk"
            ),

            br(),
            br(),

            textOutput("prediction_result")
          )
        )
      ),

      # ---------------- ANALYTICS TAB ----------------

      tabItem(

        tabName = "analytics",

        fluidRow(

          box(
            title = "Model Accuracy",
            width = 6,
            status = "success",
            solidHeader = TRUE,

            textOutput("accuracy_text")
          ),

          box(
            title = "Confusion Matrix",
            width = 6,
            status = "warning",
            solidHeader = TRUE,

            tableOutput("conf_matrix")
          )
        ),

        fluidRow(

          box(
            title = "Download Analytics Report",
            width = 6,
            status = "primary",
            solidHeader = TRUE,

            downloadButton(
              "download_report",
              "Download CSV Report"
            )
          )
        )
      )
    )
  )
))