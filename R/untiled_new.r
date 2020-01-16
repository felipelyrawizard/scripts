tenta <- gen_lotto()
nada <- as.data.frame(t(tenta))
colnames(nada) <- c("Bola1","Bola2","Bola3","Bola4","Bola5","Bola6","Bola7",
                    "Bola8","Bola9","Bola10","Bola11","Bola12","Bola13","Bola14","Bola15")

lista <- data.frame()
for (row in 1:nrow(planilha)){
  game <- as.vector(planilha[row,3:17])
  nada <- as.vector(game[order(game)])
  colnames(nada) <- c("Bola1","Bola2","Bola3","Bola4","Bola5","Bola6","Bola7",
                      "Bola8","Bola9","Bola10","Bola11","Bola12","Bola13","Bola14","Bola15")
  nada <- as.data.frame(nada)
  lista <- rbind(lista,nada)
}

lista
#reordenar indice da lista
rownames(lista) <- 1 : length(rownames(lista))
verificacao <- data.frame()
# verificar se ja existe na lista (mais de uma vez)
for (row in 1:nrow(lista)){
  
  atual <- lista[row,1:15]
  #print (atual)
  outros <- lista %>% slice(-row)
  #print (outros)
  # verificacao se esta funcionando
  outros <- atual
  #verificacao <- rbind(verificacao,atual %in% outros)
  for(i in atual %in% outros){
    if(i == TRUE)
      print('lista ja existe')
      existe <- TRUE
      break
  }
}

head(atual)
head(outros)
tail(outros)

head(lista)
tail(lista)
verificacao

existe_historco <- function(pal){
  
    atual <- as.data.frame(pal)
    existe <- FALSE
    
    for(i in 1:nrow(lista)){
      if(all(atual == lista[i,]) == TRUE){
        print('lista ja existe')
        existe <- TRUE
        break
      }  
    }
    return(existe)
}


# se ja existe na lista
existe_historco(nada)

nada
lista[row,1:15]
