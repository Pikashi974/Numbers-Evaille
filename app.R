library(shiny)

library(dplyr)

library(rlist)

getRank <- function(liste, nom) {
  # print(c(nom, liste[liste[, "name"] == nom, "level"]))
  return(as.numeric(liste[liste[, "name"] == nom, "level"]))
}

getNumero <- function(liste, nom) {
  # print(c(nom, liste[liste[, "name"] == nom, "Numéro"]))
  return(as.numeric(liste[liste[, "name"] == nom, "Numéro"]))
}

getImage <- function(liste, nom) {
  return(liste[liste[, "name"] == nom, "card_images.image_url"])
}
getAllAttributes <- function(liste){
  return(unique(liste[, "attribute"]))
}

list_minus_rang <- function(liste, rang) {
  return(liste[liste[, "level"] != rang, ])
}
list_minus_grand_numero <- function(liste, numero) {
  return(liste[liste[, "Numéro"] <= numero, ])
}
check_empty <- function(liste, nom) {
  if (length(liste) == 0) {
    # print(c(nom,": No Number"))
  }
}

addToList <- function(liste1, liste2) {
  for (i in (dim(liste1)[1] + 1):(dim(liste1)[1] + dim(liste2)[1])) {
    j <- i - dim(liste1)[1]
    liste1[i, "name"] <- liste2[j, "name"]
    liste1[i, "level"] <- liste2[j, "level"]
    liste1[i, "Numéro"] <- liste2[j, "Numéro"]
    liste1[i, "card_images.image_url"] <- liste2[j, "card_images.image_url"]
  }
  return(liste1)
}

changeList <- function(liste, input, session) {
  # Liste = the values to add
  # Input = the select to put it in
  # rang = the rank of the number
  # pos = where to place it
  updateSelectInput(
    session = session,
    inputId = input,
    choices = liste[-1, "name"]
  )
  updateSelectInput(
    session = session,
    inputId = input,
    choices = liste[, "name"]
  )
}

getReste <- function(valeurs, pos, init) {
  for (i in 1:pos) {
    init <- init - valeurs[i]
  }
  return(init)
}

values <- reactiveValues()

# Liste d'initialisation
# liste_csv <- read.csv(file = "Liste Numbers.csv")
source(file = "Ygoprodeck database.R", local = TRUE)

# Define UI for Numbers Eveil app ----
ui <- fluidPage(
  tags$head(
    # Note the wrapping of the string in HTML()
    tags$style(HTML("
    .shiny-input-container:not(.shiny-input-container-inline) {
      width: 100%;
    }
    .col-sm-3,.col-sm-4{
      display: grid;
      align-items: center;
      justify-items: center;
      align-content: center;
    }
    img {
      max-width: 75%;
    }
    .form-group.shiny-input-container, #image1, #image2, #image3, #image4 {
      display: contents;
    }
    #imageres, #image1, #image2, #image3, #image4{
        display: grid;
        justify-items: center;
    }"))
  ),
  # App title ----
  div(
    class = "col-sm-12",
    # Sidebar panel for inputs ----
    # sidebarPanel(
    div(
      class = "col-sm-8",
      style = "display: grid;
    grid-template-columns: 50% 50%;",
      h1( "Numbers Eveil App"),
    div(
        id = "listnumberinit",
        selectInput(
          inputId = "list_numbers",
          label = "Choose the Number to summon: ",
          width = "inherit",
          choices = rev(liste_csv[, "name"])
        )
      ),
    # div(
    #   h2("Options"),
    #   checkboxGroupInput(
    #     inputId = "option_attributes",
    #     label = "Attributes",
    #     choices = getAllAttributes(liste_csv),
    #     selected = getAllAttributes(liste_csv)
    #   )
    # )
    ),
    div(
      class = "col-sm-4",
      uiOutput("imageres")
    )
  ),
  tags$div(
    class = "col-sm-12",
    div(
      class = "col-sm-3",
      selectInput(
        inputId = "number1",
        label = "Number 1: ",
        width = "inherit",
        choices = (liste_csv[, "name"])
      ),
      uiOutput("image1"),
    ),
    div(
      class = "col-sm-3",
      selectInput(
        inputId = "number2",
        label = "Number 2: ",
        width = "inherit",
        choices = (liste_csv[, "name"])
      ),
      uiOutput("image2"),
    ),
    div(
      class = "col-sm-3",
      selectInput(
        inputId = "number3",
        label = "Number 3: ",
        width = "inherit",
        choices = (liste_csv[, "name"])
      ),
      uiOutput("image3"),
    ),
    div(
      class = "col-sm-3",
      selectInput(
        inputId = "number4",
        label = "Number 4: ",
        width = "inherit",
        choices = (liste_csv[, "name"])
      ),
      uiOutput("image4")
    )
  )
  # )
  ,
  # Main panel for displaying outputs ----
  mainPanel(
    withTags(div(
      id = "Test", # col-sm-6
    )),
    # textOutput("text1"),
    # textOutput("text2"),
    # textOutput("text3"),
    # textOutput("text4"),
  )
)
# Define server logic to plot various variables against mpg ----
server <- function(input, output, session) {
  # Text output for knowing what cards to use (useful for Japanease card art)
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
  # Image output for card art
  for (i in 1:4) {
    eval(parse(text = paste0(
      "output$image", i, " <- renderUI({
        tags$img(src=getImage(addToList(liste_short, liste_vide),
                              input$number", i, "))
      })"
    )))
  }
  output$imageres <- renderUI({
    tags$img(src = getImage(liste_short, input$list_numbers))
  })
  # Change the inputs based on what Number is choosed
  observeEvent(input$list_numbers, {
    values$initial <- getNumero(liste = liste_short, nom = input$list_numbers)
    # We remove all big Numbers from the list
    values$liste_1 <- list_minus_grand_numero(liste_csv, values$initial)
    # We update the first list
    changeList(liste = values$liste_1, input = "number1", session)
  })
  observeEvent(input$number1, {
    #   Liste 1 donne le premier élément (valeur : 0/1 pour Numéro/Rang)
    values$liste_rank[1] <- getRank(liste = liste_short, nom = input$number1)
    values$liste_numero[1] <- getNumero(liste = liste_short, input$number1)
    values$liste_numero[2] <- getReste(
      valeurs = values$liste_numero, pos = 1,
      init = getNumero(
        liste = liste_short,
        nom = input$list_numbers
      )
    )
    #   Je retire tout les rang 1 de la liste 1
    values$liste_2 <- list_minus_rang(
      liste = values$liste_1,
      rang = values$liste_rank[1]
    )
    #   Je retire tout les nombres de la liste 1 > 1000-0
    values$liste_2 <- list_minus_grand_numero(
      liste = values$liste_2,
      numero = values$liste_numero[2]
    )
    #   Je vérifie que la liste réduite n'est pas vide
    check_empty(values$liste_2)
    #   Si la liste est vide, on utilise l'élément vide pour liste 2 et les autres
    if (dim(values$liste_2)[1] == 0) {
      # print("Vide")
      values$liste_2 <- liste_vide
    }
    #   Je convertis cette liste en liste 2
    #   Liste 2 est créé avec tout les Numéros > 1000-0 et n'ayant pas de rang 1
    changeList(liste = values$liste_2, input = "number2", session)
  })
  observeEvent(input$number2, {
    if (input$number2 == "No Number available") {
      values$liste_3 <- liste_vide
    } else {
      #   Liste 2 donne le premier élément (valeur : 1/2 pour Numéro/Rang)
      values$liste_rank[2] <- getRank(liste = liste_short, nom = input$number2)
      values$liste_numero[2] <- getNumero(liste = liste_short, input$number2)
      values$liste_numero[3] <- getReste(
        valeurs = values$liste_numero, pos = 2,
        init = getNumero(
          liste = liste_short,
          nom = input$list_numbers
        )
      )
      #   Je retire tout les rang 2 de la liste 2
      values$liste_3 <- list_minus_rang(
        liste = values$liste_2,
        rang = values$liste_rank[2]
      )
      #   Je retire tout les nombres de la liste 2 > 1000-0-1
      values$liste_3 <- list_minus_grand_numero(
        liste = values$liste_3,
        numero = values$liste_numero[3]
      )
      #   Je vérifie que la liste réduite n'est pas vide
      check_empty(values$liste_3)
      #   Si la liste est vide, on utilise l'élément vide pour liste 3 et les autres
      if (dim(values$liste_3)[1] == 0) {
        # print("Vide")
        values$liste_3 <- liste_vide
      }
      #   Je convertis cette liste en liste 3
    }
    changeList(liste = values$liste_3, input = "number3", session)
  })
  observeEvent(input$number3, {
    if (input$number3 == "No Number available") {
      values$liste_4 <- liste_vide
    } else {
      values$liste_rank[3] <- getRank(liste = liste_short, nom = input$number3)
      values$liste_numero[3] <- getNumero(liste = liste_short, input$number3)
      #   Je calcule le numéro pour compléter liste 4 (1000-0-1-990 = 9)
      values$liste_numero[4] <- getReste(
        valeurs = values$liste_numero, pos = 3,
        init = getNumero(
          liste = liste_short,
          nom = input$list_numbers
        )
      )
      values$liste_4 <- liste_short[liste_short$Numéro == values$liste_numero[4], ]
      # On vérifie si les 3 autres rangs sont bien retirés de la liste des numéros
      for (i in 1:3) {
        values$liste_4 <- list_minus_rang(
          liste = values$liste_4,
          rang = values$liste_rank[i]
        )
      }
      #   Si le numéro est trouvé, liste 4 vaut l'élément de ce numéro
      # any(liste_short$Numéro==values$liste_numero[4])
      if (dim(values$liste_4)[1] == 0) {
        values$liste_4 <- liste_vide
      }
    }
    changeList(liste = values$liste_4, input = "number4", session)
  })
}

shinyApp(ui, server)