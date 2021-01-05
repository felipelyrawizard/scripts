setwd("D:/felipe/")
getwd()
library (openxlsx)
library(ggpubr)
library (ggplot2)
library(tidyverse)
library(dplyr)
library(reshape)

planilha <- read.xlsx ("d_lotfac.xlsx", sheet = "d_lotfac", startRow = 1, colNames = TRUE)

planilha <- planilha[complete.cases(planilha$Bola1),]
planilha$Data.Sorteio <- convertToDate(planilha$Data.Sorteio)
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

graph_prime <- graph_prime + coord_cartesian(xlim=c(1750,1938))
graph_prime

graph_odd <- ggplot(data=planilha, aes(x=Concurso, y=qt_odds)) +
  geom_bar(stat="identity", fill="red")+
  geom_text(aes(label=qt_odds), vjust=-0.3, size=3.5)+
  theme_minimal()

graph_odd <- graph_odd + coord_cartesian(xlim=c(1750,1938))
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

graph_soma <- graph_soma + coord_cartesian(xlim=c(1900,1944))
graph_soma


graph_fibo <- ggplot(data=planilha, aes(x=Concurso, y=qt_fibo)) +
  geom_bar(stat="identity", fill="blue")+
  geom_text(aes(label=qt_fibo), vjust=-0.3, size=3.5)+
  theme_minimal()

graph_fibo <- graph_fibo + coord_cartesian(xlim=c(1900,1944))
graph_fibo


# tendencia:
#Na soma, existe uma tendencia mais visivel de alta ou baixa;
ggplot(indicadores, aes(x=Concurso)) + 
  geom_line(aes(y = soma, colour = "soma")) +
  coord_cartesian(xlim=c(1900,1944))


# os outros indicadores se isolam
# existe uma regra para cada um, é confuso achar um padrão
ggplot(indicadores, aes(x=Concurso)) + 
  geom_line(aes(y = qt_pairs, colour = "qt_pairs")) + 
  geom_line(aes(y = qt_odds, colour = "qt_odds")) +
  geom_line(aes(y = qt_primes, colour = "qt_primes")) +
  geom_line(aes(y = qt_fibo, colour = "qt_fibo")) +
  coord_cartesian(xlim=c(1900,1944))


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
  w <- as.integer(unlist(w))
  w <- as.data.frame(w[order(w)])
  
  typeof(w)
  # Print results
  #print(w)
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
  
  # o jogo precisa ter entre 4 e 7 primos, senão está fora (filtro)
  # minimo de 5 pares
  # minimo de 5 impares
  # o jogo precisa ter entre 2 e 6 fibonacci, senao esta fora
  # o jogo precisa estar dentro da soma (170 a 220)
  jogo_valido <- ifelse ((pr %in% c(4:7))&
                           (o>=5) &
                           (p>=5) & 
                           (fib %in% c(2:6)) &
                           (soma %in% c(170:220)) ,TRUE,FALSE)
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

# se o jogo ja foi realizado em algum momento (historico)
existe_historco <- function(pal){
  
  atual <- as.data.frame(pal)
  atual <- as.data.frame(t(atual))
  colnames(atual) <- c("Bola1","Bola2","Bola3","Bola4","Bola5","Bola6","Bola7",
                      "Bola8","Bola9","Bola10","Bola11","Bola12","Bola13","Bola14","Bola15")
  existe <- FALSE
  lista <- lista %>% select(Bola1:Bola15)
  for(i in 1:nrow(lista)){
    if(all(atual == lista[i,]) == TRUE){
      print('lista ja existe')
      existe <- TRUE
      break
    }  
  }
  return(existe)
}


# criar função que calcula moda
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

#=================================================
# analise por bola (analise de jogadas por bola):
#=================================================

# analise dos ultimos 20 jogos
last_20 <- planilha_ordernada %>% 
  select(Bola1:Bola15) %>%
  tail(20)

library(skimr)
skim(last_20)
summary(last_20)

ggplot(last_20, aes(x=rownames(last_20),group = 1)) + 
  geom_line(aes(y = Bola1)) +
  geom_point(aes(y = Bola1)) +
  geom_line(aes(y = getmode(Bola1)))


# ultimos 10:
# nao lancar palpite que seja igual ao historico, pois o mesmo jogo nunca saiu e nunca sairÃ¡ (observaÃ§Ã£o inconclusiva, porÃ©m estÃ¡ funcionando atÃ© hoje)
# lancar palpite observando os ultimos 10 registros, o palpite deve ser validado pelo maximo de minimo de pares, impares e primos 
# observar se o ultimo registro tem pico (primo, par ou impar): 
# se o ultimo for normal, aumentar o range para chance de pico;
# se o ultimo for um pico, apÃ³s este pico o proximo deverÃ¡ ser normal.
# realizar treino e teste com machine learning para induzir as jogadas que deram certo.

#ultimos 10:
#5 q mais sairam
#5 q não sairam ou sairam menos
#soma, fibo, primos

# ultimo 1
#soma, fibo, primos

# ultimo 1 compara com ultimos 10
# se é mais alto comparado com a media ou mais baixo

# analise de cada bola e cada range
# ex.: bola 1: vai de 1 a 6
range_bolas <- data.frame()
range_bolas <- rbind(range_bolas,c('Bola1', min(planilha_ordernada$Bola1), max(planilha_ordernada$Bola1)))
colnames(range_bolas) <- c("bola","minimo","maximo")

range_bolas <- rbind(range_bolas,data.frame(t(c(bola='Bola2', minimo=as.numeric(min(planilha_ordernada$Bola2)), maximo=as.numeric(max(planilha_ordernada$Bola2))))))
range_bolas <- rbind(range_bolas,data.frame(t(c(bola='Bola3', minimo=as.numeric(min(planilha_ordernada$Bola3)), maximo=as.numeric(max(planilha_ordernada$Bola3))))))
range_bolas <- rbind(range_bolas,data.frame(t(c(bola='Bola4', minimo=as.numeric(min(planilha_ordernada$Bola4)), maximo=as.numeric(max(planilha_ordernada$Bola4))))))
range_bolas <- rbind(range_bolas,data.frame(t(c(bola='Bola5', minimo=as.numeric(min(planilha_ordernada$Bola5)), maximo=as.numeric(max(planilha_ordernada$Bola5))))))
range_bolas <- rbind(range_bolas,data.frame(t(c(bola='Bola6', minimo=as.numeric(min(planilha_ordernada$Bola6)), maximo=as.numeric(max(planilha_ordernada$Bola6))))))
range_bolas <- rbind(range_bolas,data.frame(t(c(bola='Bola7', minimo=as.numeric(min(planilha_ordernada$Bola7)), maximo=as.numeric(max(planilha_ordernada$Bola7))))))
range_bolas <- rbind(range_bolas,data.frame(t(c(bola='Bola8', minimo=as.numeric(min(planilha_ordernada$Bola8)), maximo=as.numeric(max(planilha_ordernada$Bola8))))))
range_bolas <- rbind(range_bolas,data.frame(t(c(bola='Bola9', minimo=as.numeric(min(planilha_ordernada$Bola9)), maximo=as.numeric(max(planilha_ordernada$Bola9))))))
range_bolas <- rbind(range_bolas,data.frame(t(c(bola='Bola10', minimo=as.numeric(min(planilha_ordernada$Bola10)), maximo=as.numeric(max(planilha_ordernada$Bola10))))))
range_bolas <- rbind(range_bolas,data.frame(t(c(bola='Bola11', minimo=as.numeric(min(planilha_ordernada$Bola11)), maximo=as.numeric(max(planilha_ordernada$Bola11))))))
range_bolas <- rbind(range_bolas,data.frame(t(c(bola='Bola12', minimo=as.numeric(min(planilha_ordernada$Bola12)), maximo=as.numeric(max(planilha_ordernada$Bola12))))))
range_bolas <- rbind(range_bolas,data.frame(t(c(bola='Bola13', minimo=as.numeric(min(planilha_ordernada$Bola13)), maximo=as.numeric(max(planilha_ordernada$Bola13))))))
range_bolas <- rbind(range_bolas,data.frame(t(c(bola='Bola14', minimo=as.numeric(min(planilha_ordernada$Bola14)), maximo=as.numeric(max(planilha_ordernada$Bola14))))))
range_bolas <- rbind(range_bolas,data.frame(t(c(bola='Bola15', minimo=as.numeric(min(planilha_ordernada$Bola15)), maximo=as.numeric(max(planilha_ordernada$Bola15))))))

# fator para numero
# fator tem que ir para character, dpois para numero
range_bolas$minimo <- as.numeric(as.character(range_bolas$minimo)) 
range_bolas$maximo <- as.numeric(as.character(range_bolas$maximo))

# moda dos ultimos 10, 20 e 30 jogos
range_bolas$moda <- NA
for(i in names(planilha_ordernada %>% select(Bola1:Bola15))){
  #You need to use [[, the programmatic equivalent of $
  print(planilha_ordernada[[i]] %>% tail(10) %>% getmode())
  range_bolas[as.numeric(substr(i,5,6)),]$moda <- planilha_ordernada[[i]] %>% tail(10) %>% getmode() 
}


range_bolas$moda20 <- NA
for(i in names(planilha_ordernada %>% select(Bola1:Bola15))){
  #You need to use [[, the programmatic equivalent of $
  print(planilha_ordernada[[i]] %>% tail(20) %>% getmode())
  range_bolas[as.numeric(substr(i,5,6)),]$moda20 <- planilha_ordernada[[i]] %>% tail(20) %>% getmode() 
}

range_bolas$moda30 <- NA
for(i in names(planilha_ordernada %>% select(Bola1:Bola15))){
  #You need to use [[, the programmatic equivalent of $
  print(planilha_ordernada[[i]] %>% tail(30) %>% getmode())
  range_bolas[as.numeric(substr(i,5,6)),]$moda30 <- planilha_ordernada[[i]] %>% tail(30) %>% getmode() 
}

# range de cada bola de todos os jogos + mediana das bolas dos ultimos 10 jogos
ggplot(range_bolas, label=minimo) + 
  geom_segment(aes(x=bola, 
                   xend=bola, 
                   y=minimo, 
                   yend=maximo), 
               size=3, color="orange") +
  geom_text(aes(x=bola,y=minimo,label=minimo), position=position_dodge(width=0.9), vjust=1) +
  geom_text(aes(x=bola,y=maximo,label=maximo), position=position_dodge(width=0.9), vjust=-0.25) +
  geom_line(aes(x=bola, group = 1, y = moda, colour = "moda")) +
  geom_line(aes(x=bola, group = 1, y = moda20, colour = "moda20")) +
  geom_line(aes(x=bola, group = 1, y = moda30, colour = "moda30")) +
  #geom_point(data=lista_jogos_melted, aes(x=variable,y = value),color="red", size=3)
  theme_bw() +
  theme(axis.text.x=element_text(angle=90))

  
# ABAIXAR O MÁXIMO ATÉ A 7ª BOLA E AUMENTAR O MINIMO ATÉ DA 11ª A 15ª
range_bolas$minimo_permitido <- range_bolas$minimo
range_bolas$maximo_permitido <- range_bolas$maximo

for(i in 1:nrow(range_bolas)){
  if(i <= 7){
    range_bolas$maximo_permitido[i] <- range_bolas$maximo[i] - 3
  }
  if(i>7&i<=9){
    range_bolas$maximo_permitido[i] <- range_bolas$maximo[i] - 1
    range_bolas$minimo_permitido[i] <- range_bolas$minimo[i] + 1
  }
  
  if(i >= 10){
    range_bolas$minimo_permitido[i] <- range_bolas$minimo[i] + 3
  }
}

ggplot(range_bolas, label=minimo) + 
  geom_segment(aes(x=bola, 
                   xend=bola, 
                   y=minimo, 
                   yend=maximo), 
               size=3, color="orange") +
  geom_text(aes(x=bola,y=minimo,label=minimo), position=position_dodge(width=0.9), vjust=1) +
  geom_text(aes(x=bola,y=maximo,label=maximo), position=position_dodge(width=0.9), vjust=-0.25) +
  geom_line(aes(x=bola, group = 1, y = moda, colour = "moda")) +
  geom_line(aes(x=bola, group = 1, y = moda20, colour = "moda20")) +
  geom_line(aes(x=bola, group = 1, y = moda30, colour = "moda30")) +
  geom_segment(aes(x=bola, 
                   xend=bola, 
                   y=minimo_permitido, 
                   yend=maximo_permitido), 
               size=3, color="red") +
  theme_bw() +
  theme(axis.text.x=element_text(angle=90))


# analise por bola: numero par, impar, primo, fibonati
# futuro: analisar, de cada bola, se esta dentro das regras especificas e esta dentro da predição que vou definir
range_bolas


verificar_por_bola <-function(game){
  game <- as.data.frame(game)
  for(value in game){
      # cada bola
      for(j in 1:15){
        # se esta entre o minimo e maximo permitido 
        valido <- ifelse(value[j] >= range_bolas[j,7] & value[j] <= range_bolas[j,8],TRUE,FALSE)
        #print(paste("testando bola n ",j," valor:",value[j],"","entre ",range_bolas[j,7]," e ",range_bolas[j,8],sep=""))
        if (valido == FALSE){
          break()
          return(FALSE)
        } 
      }
  }
  return (TRUE)
}

##================================================================
## gerar X palpites baseado em historico e validações matemáticas
##================================================================
lista_jogos <- data.frame()
repeat {
  jogo_valido <- NA
  while(is.na(jogo_valido)){
    tenta <- gen_lotto()
    # se foi verificado nas regras
    jogo_valido <- ifelse(verificar(tenta) & verificar_por_bola(tenta),data.frame(tenta),NA)
  }
  
  #se existe na lista de histórico (ja foi jogado)
  tem_hist <- existe_historco(tenta)
  
  if (!tem_hist){
    jogo_valido <- as.data.frame(jogo_valido)
    jogo_valido <- t(jogo_valido)
    jogo_valido <- as.data.frame(jogo_valido)
    lista_jogos <- rbind(lista_jogos,jogo_valido)  
  }
  if (nrow(lista_jogos) == 100){
    break
  }
}

row.names(lista_jogos) <- NULL
colnames(lista_jogos) <- c("Bola1","Bola2","Bola3","Bola4","Bola5","Bola6","Bola7","Bola8","Bola9","Bola10","Bola11","Bola12","Bola13","Bola14","Bola15")


#verificar se os jogos gerados estao dentro de um padrao aceitavel (visualmente)
lista_jogos_melted <- melt(lista_jogos)
planilha_ordernada_melted <- melt(planilha_ordernada)

ggplot()+
  geom_point(data=planilha_ordernada_melted, aes(x=variable,y = value),color="grey", size=2)+
  geom_point(data=lista_jogos_melted, aes(x=variable,y = value),color="red", size=3)
  

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

# organizando os palpites
palpites[1,"X15"] <- 25
palpites <- palpites[1,]

lista_jogos <- rbind(lista_jogos,palpites)

file <- "jogos_20200219.xlsx"
write.xlsx(lista_jogos, file, sheetName = "Sheet1", 
           col.names = TRUE, row.names = TRUE, append = FALSE)



#=================================================================
# poderia fazer rodar os jogos até dar o ultimo jogo que foi ganho (mas nao esta na planilha ainda)
jackpot <- c(03,04,05,08,09,10,12,15,17,19,20,22,23,24,25)
jackpot <- lista_jogos[5,]
#verifica este jogo
verificar(jackpot)
verificar_por_bola(jackpot)
existe_historco(jackpot)

setwd("D:\\felipe\\")
log_con <- file("test.log",open="a")
close(log_con)

i=0
repeat {
  i <- i+1
    jogo_valido <- NA
    while(is.na(jogo_valido)){
      tenta <- gen_lotto()
      # se foi verificado nas regras
      jogo_valido <- ifelse(verificar(tenta) & verificar_por_bola(tenta),data.frame(tenta),NA)
    }
  
    
  if (!is.na(jogo_valido)){
    jogo_valido <- as.data.frame(jogo_valido)
    jogo_valido <- t(jogo_valido)
    jogo_valido <- as.data.frame(jogo_valido)
    row.names(jogo_valido) <- "game"
    
    #se e igual
    if (!is.na(all(jogo_valido))){
      print(jogo_valido)
      #cat(as.character(jogo_valido), file = log_con, append = TRUE) # creates file and writes to it
      if(all(jackpot == jogo_valido[]) == TRUE){
        print(paste('=========================================achei na tentativa:',i))
        break
      }
    }
  }
}



#
# processo organico: construir aleatoriedade de bolas igual ocorre no sorteio
#

#install.packages("plotly")
#install.packages("gapminder")
library(plotly)
library(gapminder)
p <- gapminder %>%
  plot_ly(
    x = ~gdpPercap, 
    y = ~lifeExp, 
    size = ~pop, 
    color = ~continent, 
    frame = ~year, 
    text = ~country, 
    hoverinfo = "text",
    type = 'scatter',
    mode = 'markers'
  ) %>%
  layout(
    xaxis = list(
      type = "log"
    )
  )
p



p <- indicadores %>%
  plot_ly(
    #x = ~,
    y = ~qt_pairs, 
    size = ~qt_pairs, 
    #color = ~continent, 
    frame = ~Concurso, 
    #text = ~Bola1, 
    hoverinfo = "text",
    type = 'scatter',
    mode = 'markers'
  ) 
p
