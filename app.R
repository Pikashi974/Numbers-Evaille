library(shiny)

getRank <- function(liste, nom) {
  return(as.numeric(liste[liste[, "Name"] == nom, "Rank"]))
}

getNumero <- function(liste, nom) {
  return(as.numeric(liste[liste[, "Name"] == nom, "Numéro"]))
}

list_minus_rang <- function(liste, nom, rangs, pos) {
  for (i in rangs[1:pos]) {
    liste <- liste[liste[, "Rank"] != i, ]
  }
  return(liste)
}
list_minus_grand_numero <- function(liste, nom) {
  numero <- as.numeric(liste[liste[, "Name"] == nom, "Numéro"])
  rang <- getRank(liste, nom)
  return(liste[as.numeric(liste[, "Numéro"]) <= numero, ])
}
check_empty <- function(liste) {
  if (length(liste) == 0) {
    print("No Number")
  }
}

values <- reactiveValues()

# Liste d'initialisation
liste_csv <- read.csv(file = "Liste Numbers.csv")

# liste_csv[liste_csv[,"Name"]==liste_csv,]
# Define UI for Numbers Eveil app ----
ui <- fluidPage(

  # App title ----
  headerPanel("Numbers Eveil App"),
  # Sidebar panel for inputs ----
  sidebarPanel(
    selectInput(
      inputId = "list_numbers",
      label = "Choose the Number to summon: ",
      choices = rev(liste_csv[, "Name"])
    ),
    selectInput(
      inputId = "number1",
      label = "Number 1: ",
      choices = rev(liste_csv[, "Name"])
    ),
    selectInput(
      inputId = "number2",
      label = "Number 2: ",
      choices = rev(liste_csv[, "Name"])
    ),
    selectInput(
      inputId = "number3",
      label = "Number 3: ",
      choices = rev(liste_csv[, "Name"])
    ),
    selectInput(
      inputId = "number4",
      label = "Number 4: ",
      choices = rev(liste_csv[, "Name"])
    )
  ),


  # Main panel for displaying outputs ----
  mainPanel(
    textOutput("text1"),
    textOutput("text2"),
    textOutput("text3"),
    textOutput("text4"),
  )
)

# Define server logic to plot various variables against mpg ----
server <- function(input, output, session) {
  output$text1 <- renderText({
    input$number1
  })
  output$text2 <- renderText({
    input$number2
  })
  output$text3 <- renderText({
    input$number3
  })
  output$text4 <- renderText({
    input$number4
  })
  observe({
    updateSelectInput(
      session = session,
      inputId = "number1",
      choices = values$liste_1[, "Name"]
    )
  })
  for (i in 2:4) {
    eval(parse(text = paste0('
                               observe({
                             updateSelectInput(
      session = session,
      inputId = "number', i, '",
      choices = values$liste_', i, '[-1, "Name"]
    )
    updateSelectInput(
      session = session,
      inputId = "number', i, '",
      choices = values$liste_', i, '[, "Name"]
    )
  })')))
  }
  # observe({
  #   values$liste_rank[4] <- getRank(liste_csv,input$number4)
  # })
  observeEvent(input$list_numbers, {
    values$liste_1 <- list_minus_grand_numero(liste_csv, input$list_numbers)
    check_empty(values$liste_1)
    for (i in 1:4) {
      set.seed(872436)
      eval(parse(text = paste0(' 
    updateSelectInput(
      session = session,
      inputId = "number', i, '",
      choices = values$liste_', i, '[-1, "Name"]
    )
    updateSelectInput(
        session = session,
        inputId = "number', i, '",
        #choices = values$liste_', i, '[, "Name"],
      )'
      #choices = sample(values$liste_', i, '[, "Name"], replace=TRUE)
      )))
    }
  })
  observeEvent(input$number1, {
    # If change
    values$liste_rank[1] <- getRank(liste_csv, input$number1)
    # print(c(getNumero(liste_csv,input$list_numbers)," - ",getNumero(liste_csv,input$number1),
    #         " = ",getNumero(liste_csv,input$list_numbers)-getNumero(liste_csv,input$number1)))
    values$liste_2 <- values$liste_1[values$liste_1[, "Rank"] != as.numeric(values$liste_rank[1]), ]
    values$liste_2 <- values$liste_2[values$liste_2[, "Numéro"] <= (getNumero(liste_csv, input$list_numbers) - getNumero(liste_csv, input$number1)), ]
    check_empty(values$liste_2)
    for (i in 2:4) {
      set.seed(872436)
      eval(parse(text = paste0(
        'updateSelectInput(
      session = session,
      inputId = "number', i, '",
      choices = values$liste_', i, '[-1, "Name"]
    )
        updateSelectInput(
        session = session,
        inputId = "number', i, '",
        choices = values$liste_', i, '[, "Name"]
      )'
      )))
    }
  })
  observeEvent(input$number2, {
    values$liste_rank[2] <- getRank(liste_csv, input$number2)
    # print(c(getNumero(liste_csv,input$list_numbers),
    #         " - ",getNumero(liste_csv,input$number1),
    #         " - ",getNumero(liste_csv,input$number2),
    #         " = ",getNumero(liste_csv,input$list_numbers)-getNumero(liste_csv,input$number1)-getNumero(liste_csv,input$number2)))
    values$liste_3 <- values$liste_2[values$liste_2[, "Rank"] != as.numeric(values$liste_rank[2]), ]
    values$liste_3 <- values$liste_3[values$liste_3[, "Numéro"] <=
      (getNumero(liste_csv, input$list_numbers)
      - getNumero(liste_csv, input$number1)
        - getNumero(liste_csv, input$number2)), ]
    check_empty(values$liste_3)
    for (i in 3:4) {
      set.seed(872436)
      eval(parse(text = paste0('
        updateSelectInput(
          session = session,
          inputId = "number', i, '",
          choices = values$liste_', i, '[-1, "Name"]
        )
        updateSelectInput(
        session = session,
        inputId = "number', i, '",
        choices = values$liste_', i, '[, "Name"]
      )'
      )))
    }
  })
  observeEvent(input$number3, {
    values$liste_rank[3] <- getRank(liste_csv, input$number3)
    values$liste_4 <- values$liste_3[values$liste_3[, "Rank"] != as.numeric(values$liste_rank[3]), ]
    values$liste_4 <- values$liste_4[values$liste_4[, "Numéro"] ==
      (getNumero(liste_csv, input$list_numbers)
      - getNumero(liste_csv, input$number1)
        - getNumero(liste_csv, input$number2)
        - getNumero(liste_csv, input$number3)), ]
    # print(c(getNumero(liste_csv,input$list_numbers),
    #         " - ",getNumero(liste_csv,input$number1),
    #         " - ",getNumero(liste_csv,input$number2),
    #         " - ",getNumero(liste_csv,input$number3),
    #         " = ",getNumero(liste_csv,input$list_numbers)-getNumero(liste_csv,input$number1)
    #         -getNumero(liste_csv,input$number2)- getNumero(liste_csv,input$number3)))
    check_empty(values$liste_4)
    set.seed(872436)
    updateSelectInput(
      session = session,
      inputId = "number4",
      choices = ifelse(test = length(values$liste_4[, "Name"]) != 0,
        # yes = sample(values$liste_4[, "Name"], replace=TRUE),
        yes = values$liste_4[, "Name"],
        no = c("No Number available")
      )
    )
  })
}

shinyApp(ui, server)