gen_lotto<-function(){
  white<-seq(1:25)
  
  probs<-white
  # Decrease probabilities for commonly chosen numbers
  #probs[probs<=15]<-1/(2*25)
  #probs[probs>15]<-1/14
  
  # We need 15 whites
  w<-sample(white,15,prob=probs)
  # Print results
  cat(" White Balls:",w[order(w)])
}

gen_lotto()

setwd("C:/felipe/")
getwd()
library (openxlsx)
planilha <- read.xlsx ("d_lot.xlsx", sheet = "d_lot", startRow = 1, colNames = TRUE)

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
q + geom_point()

