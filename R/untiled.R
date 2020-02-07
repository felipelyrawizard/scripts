setwd("C:/felipe/")
getwd()
library (openxlsx)
library(ggpubr)
library (ggplot2)
library(tidyverse)
library(dplyr)
library(reshape)

planilha <- read.xlsx ("d_lotfac.xlsx", sheet = "d_lotfac", startRow = 1, colNames = TRUE)

planilha <- planilha[complete.cases(planilha$Bola1),]
str(planilha)

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


q <- ggplot(data=freq, aes(x=number, 
                             y=freq,
                             colour=number,
                             size=freq))
# add geom layer
q + geom_point() + geom_text(aes(label=number),hjust=0, vjust=0)

#freq de n. primos
primes <- c(2,3,5,7,11,13,17,19,23)
#par ou impar
pairs <- c(2,4,6,8,10,12,14,16,18,20,22,24)

odds <- c(1,3,5,7,9,11,13,15,17,19,21,23,25)

fibonacci <- c(1, 2, 3, 5, 8, 13, 21)

indicadores <- data.frame()
for (row in 1:nrow(planilha)){
  game <- as.vector(planilha[row,3:17])
  conc <- planilha[row,1]
  o <- 0
  p <- 0
  pr <- 0
  fib <- 0
  for (value in game) {
    if (value %in% odds){
      o <- o+1
    }
    if (value %in% pairs){
      p <- p+1
    }
    if (value %in% primes){
      pr <- pr+1
    }
    if (value %in% fibonacci){
      fib <- fib+1
    }
  }
  game <- append(game,o)
  game <- append(game,p)
  game <- append(game,pr)
  game <- append(game,fib)
  game <- append(game,conc)
  
  game <- as.data.frame(game)
  colnames(game)[16] <- "qt_odds"
  colnames(game)[17] <- "qt_pairs"
  colnames(game)[18] <- "qt_primes"
  colnames(game)[19] <- "qt_fibo"
  colnames(game)[20] <- "Concurso"
  indicadores <- rbind(indicadores,game)
}


indicadores <- indicadores[,c("Concurso","qt_pairs","qt_odds","qt_primes","qt_fibo")]

# adicao de campos - porcentagem dos itens em relacao ao todo
sapply(names(indicadores)[-1], function(x) {
  indicadores[paste(x, "_pct")] <<- indicadores[x] / 15 # bolas
})


planilha <- merge(x = planilha, y = indicadores, by.x = "Concurso", by.y = "Concurso", all.x = TRUE)

graph_prime <- ggplot(data=planilha, aes(x=Concurso, y=qt_primes)) +
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label=qt_primes), vjust=-0.3, size=3.5)+
  theme_minimal()

graph_prime <- graph_prime + coord_cartesian(xlim=c(1750,1925))
graph_prime

graph_odd <- ggplot(data=planilha, aes(x=Concurso, y=qt_odds)) +
  geom_bar(stat="identity", fill="red")+
  geom_text(aes(label=qt_odds), vjust=-0.3, size=3.5)+
  theme_minimal()

graph_odd <- graph_odd + coord_cartesian(xlim=c(1750,1925))
graph_odd

graph_pair <- ggplot(data=planilha, aes(x=Concurso, y=qt_pairs)) +
  geom_bar(stat="identity", fill="blue")+
  geom_text(aes(label=qt_pairs), vjust=-0.3, size=3.5)+
  theme_minimal()

graph_pair <- graph_pair + coord_cartesian(xlim=c(1750,1925))
graph_pair


ggarrange(graph_prime, 
          ggarrange(graph_odd, graph_pair, ncol = 2, labels = c("Odds", "Pairs")), 
          labels = c("Primes"),
          nrow = 2)




colnames(planilha)
planilha <- planilha %>%
  select(-c(Arrecadacao_Total:Valor_Acumulado_Especial))

#sum of numbers 
planilha$soma <-     planilha$Bola1+
                     planilha$Bola2+
                     planilha$Bola3+
                     planilha$Bola4+
                     planilha$Bola5+
                     planilha$Bola6+
                     planilha$Bola7+
                     planilha$Bola8+
                     planilha$Bola9+
                     planilha$Bola10+
                     planilha$Bola11+
                     planilha$Bola12+
                     planilha$Bola13+
                     planilha$Bola14+
                     planilha$Bola15
                     
indicadores$soma <- planilha$soma

graph_soma <- ggplot(data=planilha, aes(x=Concurso, y=soma)) +
  geom_bar(stat="identity", fill="blue")+
  geom_text(aes(label=soma), vjust=-0.3, size=3.5)+
  theme_minimal()

graph_soma <- graph_soma + coord_cartesian(xlim=c(1900,1925))
graph_soma


graph_fibo <- ggplot(data=planilha, aes(x=Concurso, y=qt_fibo)) +
  geom_bar(stat="identity", fill="blue")+
  geom_text(aes(label=qt_fibo), vjust=-0.3, size=3.5)+
  theme_minimal()

graph_fibo <- graph_fibo + coord_cartesian(xlim=c(1900,1925))
graph_fibo


# linha dos indicadores

ggplot(data=indicadores, aes(x=Concurso, y=len, group=supp)) +
  geom_line()+
  geom_point()
# Change line types
ggplot(data=df2, aes(x=dose, y=len, group=supp)) +
  geom_line(linetype="dashed", color="blue", size=1.2)+
  geom_point(color="red", size=3)


# tendencia:
#Na soma, existe uma tendencia mais visivel de alta ou baixa;
ggplot(indicadores, aes(x=Concurso)) + 
  geom_line(aes(y = soma, colour = "soma")) +
  coord_cartesian(xlim=c(1900,1925))

# os outros indicadores se isolam
ggplot(indicadores, aes(x=Concurso)) + 
  geom_line(aes(y = qt_pairs, colour = "qt_pairs")) + 
  geom_line(aes(y = qt_odds, colour = "qt_odds")) +
  geom_line(aes(y = qt_primes, colour = "qt_primes")) +
  geom_line(aes(y = qt_fibo, colour = "qt_fibo")) +
  coord_cartesian(xlim=c(1900,1925))


#organizando a tabela os jogos
planilha_ordernada <- data.frame()
for (row in 1:nrow(planilha)){
  game <- as.vector(planilha[row,3:17])
  nada <- as.vector(game[order(game)])
  colnames(nada) <- c("Bola1","Bola2","Bola3","Bola4","Bola5","Bola6","Bola7","Bola8","Bola9","Bola10","Bola11","Bola12","Bola13","Bola14","Bola15")
  planilha_ordernada <- rbind(planilha_ordernada,nada)
}
planilha_ordernada


#--------------------------------------------
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


verificar <-function(game){
  
  game <- as.data.frame(game)
  o <- 0
  p <- 0
  pr <- 0
  fib <- 0
  soma<- 0
  for(value in game){
    for (i in value){
      if (i %in% odds){
        o <- o+1
      }
      if (i %in% pairs){
        p <- p+1
      }
      if (i %in% primes){
        pr <- pr+1
      }
      if (i %in% fibonacci){
        fib <- fib+1
      }
      soma <- soma+i
    }
  }
  
  # o jogo precisa ter entre 4 e 7 primos, sen„o est· fora (filtro)
  # minimo de 5 pares
  # minimo de 5 impares
  # o jogo precisa ter entre 2 e 6 fibonacci, senao esta fora
  # o jogo precisa estar dentro da soma (170 a 220)
  jogo_valido <- ifelse ((!pr %in% c(4:7))| (o<5) | (p<5) | (!fib %in% c(2:6)) | (!soma %in% c(170:220)) ,FALSE,TRUE)
  return (jogo_valido)

}



lista <- data.frame()
for (row in 1:nrow(planilha)){
  game <- as.vector(planilha[row,3:17])
  nada <- as.vector(game[order(game)])
  colnames(nada) <- c("Bola1","Bola2","Bola3","Bola4","Bola5","Bola6","Bola7",
                      "Bola8","Bola9","Bola10","Bola11","Bola12","Bola13","Bola14","Bola15")
  nada <- as.data.frame(nada)
  lista <- rbind(lista,nada)
}


existe_historco <- function(pal){
  
  atual <- as.data.frame(pal)
  atual <- as.data.frame(t(atual))
  colnames(atual) <- c("Bola1","Bola2","Bola3","Bola4","Bola5","Bola6","Bola7",
                      "Bola8","Bola9","Bola10","Bola11","Bola12","Bola13","Bola14","Bola15")
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


##
## gerar 10 palpites baseado em historico e validaÁıes matem·ticas
##
lista_jogos <- data.frame()
repeat {
  tenta <- gen_lotto()
  # se foi verificado nas regras
  jogo_valido <- ifelse(verificar(tenta) == TRUE,as.data.frame(tenta),NA)
  tem_hist<- existe_historco(tenta)
  
  if (!is.na(jogo_valido) & !tem_hist){
    jogo_valido <- as.data.frame(jogo_valido)
    jogo_valido <- t(jogo_valido)
    jogo_valido <- as.data.frame(jogo_valido)
    lista_jogos <- rbind(lista_jogos,jogo_valido)  
  }
  if (nrow(lista_jogos) == 10){
    break
  }
}

row.names(lista_jogos) <- NULL
colnames(lista_jogos) <- c("Bola1","Bola2","Bola3","Bola4","Bola5","Bola6","Bola7","Bola8","Bola9","Bola10","Bola11","Bola12","Bola13","Bola14","Bola15")


#verificar se os jogos gerados estao dentro de um padrao aceitavel (visualmente)
lista_jogos_melted <- melt(lista_jogos)
planilha_ordernada_melted <- melt(planilha_ordernada)

ggplot()+
  geom_point(data=planilha_ordernada_melted, aes(x=variable,y = value),color="grey", size=2) +
  geom_point(data=lista_jogos_melted, aes(x=variable,y = value),color="red", size=3)



# the last 10
last_10 <- planilha %>% 
  select(Concurso,Bola1:Bola15) %>%
  arrange(desc(Concurso)) %>%
  left_join(lista) %>%
  head(10) %>%
  select (-Concurso)

# analises:
# ultimos 10:
# nao lancar palpite que seja igual ao historico, pois o mesmo jogo nunca saiu e nunca sair√° (observa√ß√£o inconclusiva, por√©m est√° funcionando at√© hoje)
# lancar palpite observando os ultimos 10 registros, o palpite deve ser validado pelo maximo de minimo de pares, impares e primos 
# observar se o ultimo registro tem pico (primo, par ou impar): 
#se o ultimo for normal, aumentar o range para chance de pico;
#se o ultimo for um pico, ap√≥s este pico o proximo dever√° ser normal.
# realizar treino e teste com machine learning para induzir as jogadas que deram certo.

#ultimos 10:
#5 q mais sairam
#5 q n„o sairam ou sairam menos
#soma, fibo, primos

# ultimo 1
#soma, fibo, primos

# ultimo 1 compara com ultimos 10
# se È mais alto comparado com a media ou mais baixo


##============================================================================
# prophet
# predicao de valores baseado em historico (prothet)
##============================================================================

library(prophet)
library(xts)

# 1 - sem ordenacao
lista <- planilha %>% select (Data.Sorteio,Bola1:Bola15)
lista$Data.Sorteio <- convertToDate(lista$Data.Sorteio)
lista$Data.Sorteio <- as.Date(as.POSIXct(lista$Data.Sorteio, origin="1970-01-01"))


# 2 - com ordenacao das sequencias
lista_ordenada <- data.frame()
for (row in 1:nrow(planilha)){
  game <- as.vector(planilha[row,3:17])
  nada <- as.vector(game[order(game)])
  colnames(nada) <- c("Bola1","Bola2","Bola3","Bola4","Bola5","Bola6","Bola7",
                      "Bola8","Bola9","Bola10","Bola11","Bola12","Bola13","Bola14","Bola15")
  nada <- as.data.frame(nada)
  lista_ordenada <- rbind(lista_ordenada,nada)
}

# Add an index (numeric ID) column to a data frame
lista_ordenada <- lista_ordenada %>% mutate(Concurso = row_number())
lista_ordenada <- lista_ordenada %>% left_join(select(planilha,Concurso,Data.Sorteio))
lista_ordenada$Data.Sorteio <- convertToDate(lista_ordenada$Data.Sorteio)
lista_ordenada$Data.Sorteio <- as.Date(as.POSIXct(lista_ordenada$Data.Sorteio, origin="1970-01-01"))


# PREVISAO DE TODOS OS 15
#
# loop entre colunas do df, criar um data frame com cada coluna

predicao_custom <- function(lista_bola){
  
  colnames(lista_bola)[1] <- "Bola"
  df_ts <- xts(lista_bola$Bola,order.by=lista_bola$Data.Sorteio)
  
  df <- data.frame(ds = index(df_ts),
                   y = as.numeric(df_ts[,1]))
  
  #prophet model application
  prophetpred <- prophet(df)
  future <- make_future_dataframe(prophetpred, periods = 1)
  
  forecastprophet <- predict(prophetpred, future)
  forecastprophet$yhat <- round(forecastprophet$yhat,digits=0)
  
  ball_pred <- forecastprophet %>% 
    slice(n()) %>% 
    select(yhat)
  return(ball_pred)
  
}


previsao_profeta <- data.frame()
for(i in names(lista_ordenada %>% select(Bola1:Bola15))){
  
  ball_pred <- predicao_custom(assign(paste('df_',i,sep=''), lista_ordenada %>% select(i,Data.Sorteio)))
  
  previsao_profeta <- rbind(previsao_profeta,ball_pred)
}


previsao_profeta2 <- data.frame()
for(i in names(lista %>% select(Bola1:Bola15))){
  
  ball_pred <- predicao_custom(assign(paste('df_',i,sep=''), lista %>% select(i,Data.Sorteio)))
  
  previsao_profeta2 <- rbind(previsao_profeta2,ball_pred)
}

previsao_profeta2 <- previsao_profeta2 %>% arrange(yhat)


previsao_profeta
previsao_profeta2

palpite  <- unique(previsao_profeta)
palpite2 <- unique(previsao_profeta2)
palpites <- data.frame(t(palpite))
palpites$X15 <- NA

palpites <- bind_rows(palpites,data.frame(t(palpite2)))

