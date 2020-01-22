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



# the last 10
last_10 <- planilha %>% 
  select(Concurso,Bola1:Bola15) %>%
  arrange(desc(Concurso)) %>%
  left_join(lista) %>%
  head(10) %>%
  select (-Concurso)

#ultimos 10:
  #5 q mais sairam
  #5 q não sairam ou sairam menos
  #soma, fibo, primos

# ultimo 1
  #soma, fibo, primos

# ultimo 1 compara com ultimos 10
  # se é mais alto comparado com a media ou mais baixo




lista <- planilha %>% select (Data.Sorteio,Bola1:Bola15)
lista$Data.Sorteio <- convertToDate(lista$Data.Sorteio)
lista$Data.Sorteio <- as.Date(as.POSIXct(lista$Data.Sorteio, origin="1970-01-01"))


# predicao de valores baseado em historico (prothet)
library(prophet)
library(xts)


# predicao de duas formas:
# 1 - sem ordenacao das sequencias 


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

# preciso multiplicar isso
teste <- lista_ordenada %>% select(Bola1,Data.Sorteio)

# loop entre colunas do df
for(i in names(lista_ordenada %>% select(Bola1:Bola15))){
  
  teste <- lista_ordenada %>% select(Bola1,Data.Sorteio)
  
}


