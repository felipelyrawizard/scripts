
util<- read.csv("P3-Machine-Utilization.csv", na.strings=c(""))
head(util,12)
str(util)

# criar a coluna utilização
util$Utilization = 1 - util$Percent.Idle
head(util,12)

#Datas
tail(util) # verificando o formato (vai ate em baixo para saber o formato da data)

# padrao IEEE para data
?POSIXct
util$PosixTime <- as.POSIXct(util$Timestamp,format="%d/%m/%Y %H:%M")
head(util)
summary(util)

#TIP: reajustar colunas no df
#limpando a coluna
util$Timestamp <- NULL
util<-util[,c(4,1,2,3)]
head(util)

#Lists
RL1 <-util[util$Machine=="RL1",]
RL1$Machine <- factor(RL1$Machine)
str(RL1)

#construir uma lista (minimo, media, maximo):
util_stats_rl1 <- c(min(RL1$Utilization, na.rm=T),
                    mean(RL1$Utilization, na.rm=T),
                    max(RL1$Utilization, na.rm=T))
util_stats_rl1

util_under_90 <- which(RL1$Utilization < 0.9) # which ja ignora NAs
# 27 vezes ficou menor que 90%
length(util_under_90)
util_under_90_flag <- length(util_under_90) > 0

list_rl1 <- list("RL1",util_stats_rl1,util_under_90_flag)
list_rl1


# nomeando componentes da lista
names(list_rl1)

names(list_rl1) <- c("Machine","Stats","Low")

list_rl1

# nomeando como dataframe
rm(list_rl1)
list_rl1 <- list(Machine="RL1", Stats=util_stats_rl1,Low=util_under_90_flag)
list_rl1


#Extraindo componentes de uma lista
# [] retorna a lista
# [[]] retorna o objeto atual
# $ retorna o objeto atual

list_rl1[1]
list_rl1[[1]]
list_rl1$Machine

list_rl1[2] #retorna uma lista
typeof(list_rl1[2])

list_rl1[[2]]
typeof(list_rl1[[2]])

# acessar o 3 elemento do vector (max utilization)?
list_rl1
list_rl1[[2]][3]
list_rl1$Stats[3]

# adding and deleting components
list_rl1[4] <- "New information"
list_rl1

list_rl1$UnknownHours <- RL1[is.na(RL1$Utilization),"PosixTime"]
list_rl1


#removendo um componente:
list_rl1[4] <- NULL
# lembrar que o indice muda (é uma lista)
list_rl1[4]

list_rl1$Data <- RL1
list_rl1
summary(list_rl1)
