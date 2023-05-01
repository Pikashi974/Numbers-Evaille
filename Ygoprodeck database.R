library("rjson")
library("stringr")

test <- fromJSON(file = "https://db.ygoprodeck.com/api/v7/cardinfo.php?type=XYZ%20Monster&desc=always%20treated%20as%20%22Number&fname=Number")

liste_csv <- as.data.frame(test$data[[1]])

for (i in 2:length(test$data)) {
  number <- as.data.frame(test$data[[i]])
  for (j in names(number)) {
    liste_csv[i,j] = number[,j]
  }
}

for (i in 1:nrow(liste_csv)) {
  liste_csv$name[i] <- str_extract(string = liste_csv$name[i], pattern = "[a-zA-Z0-9: -/]+")
  #On ajoute les numéros
  liste_csv$Numéro[i] <- str_extract(string = liste_csv$name[i], pattern = "[0-9]+")
  liste_csv$level[i] <- as.integer(liste_csv$level[i])
  #On vérifie si le Numéro était bien dans le nom (cas C39)
  if (is.na(liste_csv$Numéro[i])) {
    #On cherche le pattern indiquant qu'il est toujours traité comme un Number
    query = 'always treated as \\"Number [a-zA-Z]+[0-9]+|always treated as \\"Number [0-9]+'
    #On remplace le Numéro inconnu par celui qu'on a dans la description
    if (is.na(str_extract(string = liste_csv$desc[i], pattern = query))==FALSE) {
      liste_csv$Numéro[i] <- as.integer(str_extract(str_extract(string = liste_csv$desc[i], pattern = query), "[0-9]+"))
    }
  }
  #On vérifié que les F0 soient bien traités comme Rang 1
  if (liste_csv$level[i] == 0) {
    query2 = "This card's original Rank is always treated as [0-9]+"
    if (is.na(str_extract(string = liste_csv$desc[i], pattern = query2))==FALSE) {
      liste_csv$level[i] <- as.integer(str_extract(str_extract(string = liste_csv$desc[i], pattern = query2), "[0-9]+"))
    }
  }
}

#On convertit 
liste_csv$Numéro <- sapply(liste_csv$Numéro, as.numeric)

liste_csv <- liste_csv[is.na(liste_csv$Numéro)==FALSE,]
liste_csv <- liste_csv[order(liste_csv$Numéro),]

liste_short <- liste_csv[,c("name", "level", "Numéro", "card_images.image_url")]

liste_vide <- liste_short
liste_vide[dim(liste_vide)[1]+1, "name"] = "No Number available"
liste_vide <- liste_vide[liste_vide$name=="No Number available",]
liste_vide[liste_vide$name=="No Number available", "Numéro"] = 0
liste_vide[liste_vide$name=="No Number available", "level"] = 0
liste_vide[liste_vide$name=="No Number available", "card_images.image_url"] = as.data.frame(fromJSON(file = "https://db.ygoprodeck.com/api/v7/cardinfo.php?name=Wattcancel")$data[[1]])[, "card_images.image_url"]