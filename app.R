library(shiny)

getRank <- function(liste, nom) {
  return(as.numeric(liste[liste[,"Name"]==nom, "Rank"]))
}

getNumero <- function(liste, nom) {
  return(as.numeric(liste[liste[,"Name"]==nom, "Numéro"]))
}

list_minus_rang <- function(liste, nom, rangs, pos) {
  for (i in rangs[1:pos]) {
    liste <- liste[liste[,"Rank"]!=i,]
  }
  return(liste)
}
list_minus_grand_numero <- function(liste, nom) {
  numero = as.numeric(liste[liste[,"Name"]==nom, "Numéro"])
  rang = getRank(liste, nom)
  return(liste[as.numeric(liste[,"Numéro"]) <= numero,])
}

values <- reactiveValues()

#Liste d'initialisation
liste_csv <- read.csv(file = "Liste Numbers.csv")


#liste_csv[liste_csv[,"Name"]==liste_csv,]
# Define UI for Numbers Eveil app ----
ui <- fluidPage(
  
  # App title ----
  headerPanel("Numbers Eveil App"),
  
  # Sidebar panel for inputs ----
  selectInput(
    inputId = "list_numbers",
    label = "Choisissez le Numéro à invoquer: ",
    choices = rev(liste_csv[,"Name"])
  ),
  selectInput(
    inputId = "number1",
    label = "Numéro 1: ",
    choices = rev(liste_csv[,"Name"])
  ),
  selectInput(
    inputId = "number2",
    label = "Numéro 2: ",
    choices = rev(liste_csv[,"Name"])
  ),
  selectInput(
    inputId = "number3",
    label = "Numéro 3: ",
    choices = rev(liste_csv[,"Name"])
  ),
  selectInput(
    inputId = "number4",
    label = "Numéro 4: ",
    choices = rev(liste_csv[,"Name"])
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
  observe({
    values$liste_rank[4] <- getRank(liste_csv,input$number4)
  })
  observeEvent(input$list_numbers, {
    values$liste_1 <- list_minus_grand_numero(liste_csv,input$list_numbers)
    
  })
  observeEvent(input$number1,{
    #If change
    values$liste_rank[1] <- getRank(liste_csv,input$number1)
    values$liste_2<- values$liste_1[values$liste_1[,"Rank"]!=as.numeric(values$liste_rank[1]),]
    updateSelectInput(
      session = session,
      inputId = "number2",
      choices = values$liste_2[, "Name"]
    )
  })
  observeEvent(input$number2,{
    values$liste_rank[2] <- getRank(liste_csv,input$number2)
    values$liste_3<- values$liste_2[values$liste_2[,"Rank"]!=as.numeric(values$liste_rank[2]),]
    updateSelectInput(
      session = session,
      inputId = "number3",
      choices = values$liste_3[, "Name"]
    )
  })
  observeEvent(input$number3,{
    values$liste_rank[3] <- getRank(liste_csv,input$number3)
    values$liste_4<- values$liste_3[values$liste_3[,"Rank"]!=as.numeric(values$liste_rank[3]),]
    updateSelectInput(
      session = session,
      inputId = "number4",
      choices = values$liste_4[, "Name"]
    )
  })
}

shinyApp(ui, server)