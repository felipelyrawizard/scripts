
# selecionar arquivo
stats <- read.csv(file.choose())
stats


# ler informacao do diretorio de trabalho
getwd()

#alterar
setwd("D://Users/felipelyra/Documents")
rm(stats)
stats <- read.csv("P2-Demographic-Data.csv")

#--------------------------

stats

# quantas linhas
nrow(stats)
# quantas colunas
ncol(stats)

# ver as primeiras linhas
head(stats, n = 10)
#ver as ultimas linhas
tail(stats, n = 2)

# estrutura
str(stats)

# sumario das informacoes
summary(stats)


# acessando 
stats[3,3]
stats[3,"Birth.rate"]
stats["Angola",3] #nao dá pois linha o indice nao recebe nome

# usando o $
stats$Internet.users
stats$Internet.users[2]

# vendo os agrupamentos (vindo do summary)
levels(stats$Income.Group)

#operacoes basicas

# as primeiras 10 linhas
stats[1:10,]
stats[3:9,]
stats[c(4,100),]

stats[1,]
is.data.frame(stats[1,])

#coluna
stats[,1]
is.data.frame(stats[,1])
stats[,1,drop=F]
is.data.frame(stats[,1,drop=F])

#multiplicar 
head(stats)
stats$Birth.rate * stats$Internet.users

# adicionar coluna
head(stats, n=10)
stats$MyCalc <- stats$Birth.rate * stats$Internet.users

stats$xyz <- 1:5 # se vc adicionar uma coluna menor, ela se reciclara na quantidade de linhas

# remover coluna
head(stats, n=10)
stats$MyCalc <- NULL













