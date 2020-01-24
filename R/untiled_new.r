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
q + geom_point() + geom_text(aes(label=number),hjust=0, vjust=0)

#freq de n. primos
primes <- c(2,3,5,7,11,13,17,19,23)
#par ou impar
pairs <- c(2,4,6,8,10,12,14,16,18,20,22,24)

odds <- c(1,3,5,7,9,11,13,15,17,19,21,23,25)

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
    if (value %in% pairs){
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

# analises:
# ultimos 10:
# nao lancar palpite que seja igual ao historico, pois o mesmo jogo nunca saiu e nunca sairá (observação inconclusiva, porém está funcionando até hoje)
# lancar palpite observando os ultimos 10 registros, o palpite deve ser validado pelo maximo de minimo de pares, impares e primos 
# observar se o ultimo registro tem pico (primo, par ou impar): 
#se o ultimo for normal, aumentar o range para chance de pico;
#se o ultimo for um pico, após este pico o proximo deverá ser normal.
# realizar treino e teste com machine learning para induzir as jogadas que deram certo.


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

lista <- planilha %>% select (Data.Sorteio,Bola1:Bola15)
lista$Data.Sorteio <- convertToDate(lista$Data.Sorteio)
lista$Data.Sorteio <- as.Date(as.POSIXct(lista$Data.Sorteio, origin="1970-01-01"))


# predicao de valores baseado em historico (prothet)
library(prophet)
library(xts)


# predicao de duas formas:
# 1 - sem ordenacao das sequencias 
# 2 - com ordenacao das sequencias 

#We convert dataset as prophet input requires
df_ts <- xts(lista$Bola1,order.by=lista$Data.Sorteio)

df <- data.frame(ds = index(df_ts),
                 y = as.numeric(df_ts[,1]))

#prophet model application
prophetpred <- prophet(df)
future <- make_future_dataframe(prophetpred, periods = 10)

forecastprophet <- predict(prophetpred, future)
# grafico simples mostrando a predicao
plot(prophetpred, forecastprophet)

forecastprophet$yhat <- round(forecastprophet$yhat,digits=0)

prediction_ts <- xts(forecastprophet$trend,order.by=forecastprophet$ds)
prediction_yhat <- xts(forecastprophet$yhat,order.by=forecastprophet$ds)

tail(prediction_ts)
tail(prediction_yhat)

# predicao com variavel yhat (fazer também com a trend)
dygraph(prediction_yhat,ylab="Previsão yhat", 
        main="Previsão") %>%
  dySeries("V1",label="Bola") %>%
  dyRangeSelector(dateWindow = c("2019-06-01","2019-11-19"))


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

lista_ordenada
# Add an index (numeric ID) column to a data frame
lista_ordenada <- lista_ordenada %>% mutate(Concurso = row_number())
lista_ordenada <- lista_ordenada %>% left_join(select(planilha,Concurso,Data.Sorteio))
lista_ordenada$Data.Sorteio <- convertToDate(lista_ordenada$Data.Sorteio)
lista_ordenada$Data.Sorteio <- as.Date(as.POSIXct(lista_ordenada$Data.Sorteio, origin="1970-01-01"))

#We convert dataset as prophet input requires
df_ts <- xts(lista_ordenada$Bola1,order.by=lista_ordenada$Data.Sorteio)

df <- data.frame(ds = index(df_ts),
                 y = as.numeric(df_ts[,1]))

#prophet model application
prophetpred <- prophet(df)
future <- make_future_dataframe(prophetpred, periods = 1)

forecastprophet <- predict(prophetpred, future)
forecastprophet$yhat <- round(forecastprophet$yhat,digits=0)

# grafico simples mostrando a predicao (corretamente os dados passados)
plot(prophetpred, forecastprophet)
prophet_plot_components(prophetpred, forecastprophet)


# Need to transform forecasted values to back to their original units
# you are able to visualize the forecasted values alongside the historical values:
"install.packages('forecast', dependencies = TRUE)
library(forecast)
inverse_forecast <- forecastprophet
inverse_forecast <- column_to_rownames(inverse_forecast, var = "ds")
lam = BoxCox.lambda(df$y, method = "loglik")
inverse_forecast$yhat_untransformed = InvBoxCox(forecastprophet$yhat, lam)
plot(prophetpred, inverse_forecast)"

# fazendo verificacoes
lista_ordenada %>% filter(Bola1 == 6) # bola 6 aparece somente 4 vezes mesmo... =D

prediction_ts <- xts(forecastprophet$trend,order.by=forecastprophet$ds)
prediction_yhat <- xts(forecastprophet$yhat,order.by=forecastprophet$ds)

tail(prediction_ts)
tail(prediction_yhat)

# predicao com variavel yhat (fazer também com a trend)
dygraph(prediction_yhat,ylab="Previsão yhat", 
        main="Previsão") %>%
  dySeries("V1",label="Bola") %>%
  dyRangeSelector(dateWindow = c("2019-06-01","2019-11-19"))

ball_pred <- forecastprophet %>% 
              slice(n()) %>% 
              select(yhat)

ball_pred

#
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
#reordenando um coluna
palpites = palpites %>% select(X1:X9, X10, X11:X15)
palpites



# http://www.sthda.com/english/articles/40-regression-analysis/166-predict-in-r-model-predictions-and-confidence-intervals/


# We start by building a simple linear regression model that predicts the stopping distances of cars on the basis of the speed.
# stopping distance for speed value
# the units of the variable speed and dist are respectively, mph and ft.

# Load the data
data("cars", package = "datasets")
# Build the model
model <- lm(dist ~ speed, data = cars)

# The linear model equation can be written as follow: dist = -17.579 + 3.932*speed.
model

#então, 25mph --> 85 ft para parar
# mais ou menos 40kmh, são 25 metros para parar
# mais ou menos né: é um modelo linear
-17.579 + 3.932*25 #era para dar 85... deu 80
-17.579 + 3.932*12 # outros testes

new.speeds <- data.frame(speed = c(12, 19, 24))

new.speeds

predicao <- data.frame(predict(model, newdata = new.speeds))
predicao

# 0. Build linear model 
data("cars", package = "datasets")
model <- lm(dist ~ speed, data = cars)
# 1. Add predictions 
pred.int <- predict(model, interval = "prediction")
mydata <- cbind(cars, pred.int)
# 2. Regression line + confidence intervals
library("ggplot2")
p <- ggplot(mydata, aes(speed, dist)) +
  geom_point() +
  stat_smooth(method = lm)
# 3. Add prediction intervals
p + geom_line(aes(y = lwr), color = "red", linetype = "dashed")+
  geom_line(aes(y = upr), color = "red", linetype = "dashed")
