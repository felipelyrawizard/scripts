setwd("C:/felipe/")
getwd()
library (openxlsx)
planilha <- read.xlsx ("untiled.xlsx", sheet = "d_lot", startRow = 1, colNames = TRUE)

planilha <- planilha[complete.cases(planilha$Bola1),]
str(planilha)

length(which(planilha$Bola1 == i))

freq <- data.frame()

for (i in 1:25){
  print (i)
  c <- 0
  c <- c + length(which(planilha$Bola1 == i))
  c <- c + length(which(planilha$Bola2 == i))
  c <- c + length(which(planilha$Bola3 == i))
  c <- c + length(which(planilha$Bola4 == i))
  c <- c + length(which(planilha$Bola5 == i))
  c <- c + length(which(planilha$Bola6 == i))
  c <- c + length(which(planilha$Bola7 == i))
  c <- c + length(which(planilha$Bola8 == i))
  c <- c + length(which(planilha$Bola9 == i))
  c <- c + length(which(planilha$Bola10 == i))
  c <- c + length(which(planilha$Bola11 == i))
  c <- c + length(which(planilha$Bola12 == i))
  c <- c + length(which(planilha$Bola13 == i))
  c <- c + length(which(planilha$Bola14 == i))
  c <- c + length(which(planilha$Bola15 == i))
  print (c)
  freq <- rbind(freq,c(i,c))
}

colnames(freq) <- c("number","freq")

library (ggplot2)
q <- ggplot(data=freq, aes(x=number, 
                             y=freq,
                             colour=number,
                             size=freq))
# add geom layer
q + geom_point() + geom_text(aes(label=number),hjust=0, vjust=0)

#freq de n. primos
primes <<- c(2,3,5,7,11,13,17,19,23)
#par ou impar
pair <<- c(2,4,6,8,10,12,14,16,18,20,22,24)

odds <<- c(1,3,5,7,9,11,13,15,17,19,21,23,25)

indicadores <- data.frame()
for (row in 1:nrow(planilha)){
  game <- as.vector(planilha[row,3:17])
  conc <- planilha[row,1]
  o <- 0
  p <- 0
  pr <- 0
  for (value in game) {
    if (value %in% odds){
      o <- o+1
    }
    if (value %in% pair){
      p <- p+1
    }
    if (value %in% primes){
      pr <- pr+1
    }
  }
  game <- append(game,o)
  game <- append(game,p)
  game <- append(game,pr)
  game <- append(game,conc)
  
  game <- as.data.frame(game)
  colnames(game)[16] <- "qt_odds"
  colnames(game)[17] <- "qt_pairs"
  colnames(game)[18] <- "qt_primes"
  colnames(game)[19] <- "Concurso"
  indicadores <- rbind(indicadores,game)
}


indicadores <- indicadores[,c("Concurso","qt_pairs","qt_odds","qt_primes")]

# adicao de campos - porcentagem dos itens em relacao ao todo
sapply(names(indicadores)[-1], function(x) {
  indicadores[paste(x, "_pct")] <<- indicadores[x] / 15 # bolas
})

planilha <- merge(x = planilha, y = indicadores, by.x = "Concurso", by.y = "Concurso", all.x = TRUE)


graph_prime <- ggplot(data=planilha, aes(x=Concurso, y=qt_primes)) +
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label=qt_primes), vjust=-0.3, size=3.5)+
  theme_minimal()

graph_prime <- graph_prime + coord_cartesian(xlim=c(1850,1888))


graph_odd <- ggplot(data=planilha, aes(x=Concurso, y=qt_odds)) +
  geom_bar(stat="identity", fill="red")+
  geom_text(aes(label=qt_odds), vjust=-0.3, size=3.5)+
  theme_minimal()

graph_odd <- graph_odd + coord_cartesian(xlim=c(1850,1888))

graph_pair <- ggplot(data=planilha, aes(x=Concurso, y=qt_pairs)) +
  geom_bar(stat="identity", fill="blue")+
  geom_text(aes(label=qt_pairs), vjust=-0.3, size=3.5)+
  theme_minimal()

graph_pair <- graph_pair + coord_cartesian(xlim=c(1850,1888))

library(ggpubr)
ggarrange(graph_prime, 
          ggarrange(graph_odd, graph_pair, ncol = 2, labels = c("Odds", "Pairs")), 
          labels = c("Primes"),
          nrow = 2)


gen_lotto<-function(){
  balls<-seq(1:25)
  probs<-balls
  # We need 15 whites
  w<-sample(balls,15,prob=probs)
  w <- as.data.frame(w[order(w)])
  # Print results
  print(w)
  return(w)
}


tenta <- gen_lotto()

for (row in 1:nrow(planilha)){
  game <- as.vector(planilha[1,3:17])
  game <- as.vector(game[order(game)])
}

