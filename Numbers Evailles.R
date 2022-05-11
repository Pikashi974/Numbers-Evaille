#Entrée : le tableau des éléments utilisables
#Sortie : la liste des 4 chiffres qui permetent de faire ce nombre


Create_comb <- function(tableau, Number, liste, Ranks, result) {
  for(len in 1:max(nrow(tableau), 1)){
    current = tableau[len, "Rank"]
    Ranks <- c(Ranks, tableau[len, "Rank"])
    liste <- c(liste, tableau[len, "Number"])
    total <- sum(as.numeric(liste))
    if (is.na(total) == FALSE && i >= total && length(liste) < 4) {
      #We didn't go beyond the Number sought and the list is still less than 4
      #(Possibility the Number 0 are usable)
      tab <- tableau[as.numeric(tableau[,"Number"]) <= i - sum(as.numeric(liste)),]
      result <- c(result, Create_comb(tableau = tab[(tab[,"Rank"] != current),],
                  Number = Number,
                  liste = liste,
                  Ranks = Ranks,
                  result = result))
    }
    else if(i == total && length(liste) == 4 && anyNA(liste) == FALSE){
      #We got the right combination of 4, and the tableau didn't crash
      liste <- order(liste)
      if (paste0("c(",toString(liste),")") %in% result == FALSE) {
        #Check if we didn't already add the list
        result <- c(result, paste0("c(",toString(liste),")"))
      }
    }
    else{ 
#(i != total || length(liste) > 4 || (is.na(tableau[1,"Rank"]) <= 0 && length(liste) < 4)) 
      #The sum of 4 was not good, the list was somehow too big 
      #Or the tableau is empty and you can't complete the list of 4
      result
    }
    
    liste <- head(liste, -1)
    Ranks <- head(Ranks, -1)
  }
  return(result)
}

x <- Create_comb(df_viable, i, c(), c(), c())

