library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(DT)
library(randomForest)

shinyServer(function(input, output) {

  # ---------------- REACTIVE DATA ----------------

  data_reactive <- reactive({

    if (is.null(input$file_upload)) {

      return(default_data)

    } else {

      uploaded_data <- read.csv(
        input$file_upload$datapath
      )

      uploaded_data$Outcome <- as.factor(
        uploaded_data$Outcome
      )

      return(uploaded_data)
    }
  })

  # ---------------- KPI CARDS ----------------

  output$total_patients <- renderValueBox({

    valueBox(
      value = nrow(data_reactive()),
      subtitle = "Total Patients",
      icon = icon("users"),
      color = "blue"
    )
  })

  output$high_risk <- renderValueBox({

    high_risk_count <- sum(
      data_reactive()$Outcome == 1
    )

    valueBox(
      value = high_risk_count,
      subtitle = "High Risk Patients",
      icon = icon("heartbeat"),
      color = "red"
    )
  })

  output$avg_bmi <- renderValueBox({

    avg_bmi <- round(
      mean(data_reactive()$BMI),
      2
    )

    valueBox(
      value = avg_bmi,
      subtitle = "Average BMI",
      icon = icon("chart-line"),
      color = "green"
    )
  })

  # ---------------- DATA TABLE ----------------

  output$data_table <- renderDT({

    datatable(
      data_reactive(),
      options = list(pageLength = 10)
    )
  })

  # ---------------- AGE DISTRIBUTION ----------------

  output$age_plot <- renderPlotly({

    p <- ggplot(
      data_reactive(),
      aes(x = Age)
    ) +

      geom_histogram(
        bins = 20,
        fill = "steelblue"
      ) +

      theme_minimal()

    ggplotly(p)
  })

  # ---------------- BMI DISTRIBUTION ----------------

  output$bmi_plot <- renderPlotly({

    p <- ggplot(
      data_reactive(),
      aes(x = BMI)
    ) +

      geom_histogram(
        bins = 20,
        fill = "darkgreen"
      ) +

      theme_minimal()

    ggplotly(p)
  })

  

 # ---------------- TRAIN TEST SPLIT ----------------

model_data <- reactive({

  dataset <- data_reactive()

  split_index <- sample(
    1:nrow(dataset),
    0.8 * nrow(dataset)
  )

  train_data <- dataset[split_index, ]

  test_data <- dataset[-split_index, ]

  list(
    train = train_data,
    test = test_data
  )
})

# ---------------- MODEL TRAINING ----------------

model <- reactive({

  randomForest(

    Outcome ~ Glucose + BMI + Age,

    data = model_data()$train
  )
})
 # ---------------- MODEL ANALYTICS ----------------

output$accuracy_text <- renderText({

  predictions <- predict(
    model(),
    model_data()$test
  )

  accuracy <- mean(
    predictions == model_data()$test$Outcome
  )

  paste(
    "Model Accuracy:",
    round(accuracy * 100, 2),
    "%"
  )
})

output$conf_matrix <- renderTable({

  predictions <- predict(
    model(),
    model_data()$test
  )

  table(
    Predicted = predictions,
    Actual = model_data()$test$Outcome
  )
})
# ---------------- DOWNLOAD REPORT ----------------

output$download_report <- downloadHandler(

  filename = function() {

    paste(
      "healthcare_analytics_report",
      Sys.Date(),
      ".csv",
      sep = ""
    )
  },

  content = function(file) {

    report_data <- data_reactive()

    write.csv(
      report_data,
      file,
      row.names = FALSE
    )
  }
)

  # ---------------- PREDICTION ----------------

  observeEvent(input$predict_btn, {

    new_data <- data.frame(

      Glucose = input$glucose,
      BMI = input$bmi,
      Age = input$age
    )

    prediction <- predict(
      model(),
      new_data
    )

    result <- ifelse(

      prediction == 1,

      "High Diabetes Risk",

      "Low Diabetes Risk"
    )

    output$prediction_result <- renderText({

      paste(
        "Prediction:",
        result
      )
    })
  })
})