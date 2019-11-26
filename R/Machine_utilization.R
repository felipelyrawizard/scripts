
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






#############################################
#############################################
getwd()
Chicago <- read.csv("Chicago-F.csv", row.names=1)
NewYork <- read.csv("NewYork-F.csv", row.names=1)
Houston <- read.csv("Houston-F.csv", row.names=1)
SanFrancisco <- read.csv("SanFrancisco-F.csv", row.names=1)

?apply

Chicago

# average for every row
apply(Chicago,1,mean)

apply(Chicago,1,max)

apply(Chicago,1,min)

#max or min iin the columns
apply(Chicago,2,max)
apply(Chicago,2,min)

#comparando:
apply(Chicago,1,mean)
apply(NewYork,1,mean)
apply(Houston,1,mean)
apply(SanFrancisco,1,mean)

?lapply
Chicago
t(Chicago) #transpose (alterar linhas em colunas)

#criando uma lista com nomes iguais
Weather <- list(Chicago=Chicago,NewYork=NewYork,Houston=Houston,SanFrancisco=SanFrancisco)
Weather[3]
Weather[[3]]
Weather$Houston

#transpor 
lapply(Weather, t) # transposar cada elemento da lista
# a mesma coisa de t(Weather$Chicago),t(Weather$NewYoork),....  
mynewlist <- lapply(Weather, t)

#adicionando uma nova linha 
lapply(Weather,rbind,NewRow=1:12)

#calcula o mean de todas as linhas
rowMeans(Chicago) # igual a apply(Chicago,1,mean)
lapply(Weather, rowMeans)

#rowMeans
#colMeans
#rowSums
#colSums
Weather
# o primeiro item da primeira linha de cada cidade
lapply(Weather,"[",1,1)

#as primeiras linhas de cada cidade
lapply(Weather,"[",1,)

#pegar a coluna de março
lapply(Weather,"[",,3)

# adicionando as proprias funcoes
lapply(Weather,rowMeans)

lapply(Weather,function(x)x[1,]) # a primeira linha de todas as matrizes
lapply(Weather,function(x)x[,12]) # a 12 coluna de todas as matrizes

Weather
lapply(Weather,function(z)z[1,]-z[2,])

#sapply (versão simplificada) # apresentação em matriz
lapply(Weather,"[",1,1)
sapply(Weather,"[",1,1)

# AvgHigh_F para 4# quarter
lapply(Weather,"[",1,10:12)
sapply(Weather,"[",1,10:12)


lapply(Weather,rowMeans)
sapply(Weather,rowMeans)

round(sapply(Weather,rowMeans),2)
#não dá para usar o round pois nao é uma matriz
round(lapply(Weather,rowMeans),2)

lapply(Weather,function(z)z[1,]-z[2,])
sapply(Weather,function(z)z[1,]-z[2,])

# a proposito:
# simplify = FALSE fica igual lapply
sapply(Weather,rowMeans,simplify = FALSE)

#
#Nesting Apply functions
#

# apply: iterate over rows of the matrix,
# lapply or sapply: iterate over components of the list
apply(Chicago,1,max)

# apply across whole list
lapply(Weather,apply,1,max)
lapply(Weather, function(x) apply(x,1,max))
sapply(Weather,apply,1,max)


#very advanced tutorial!
#which.max
?which.max #Where is the Min() or Max() or first TRUE or FALSE ?

Chicago[1,]
which.max(Chicago[1,]) # vai trazer o indice
names(which.max(Chicago[1,])) # so traz o nome da coluna

# apply: iterate over rows 
# o máximo de cada linha, vai trazer a coluna
apply(Chicago,1,function(x) names(which.max(x)))

# por todas as cidades
lapply(Weather, function(y) apply(y,1,function(x) names(which.max(x))))
