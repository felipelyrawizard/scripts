# R homeworks
# law of large numbers
# essa regra diz que o padrão 50% vai se ajustando conforme a quantidade de tentativas aumenta

rnorm(100)

N <- 1000000
counter <- 0
for (i in rnorm(N)){
  #print (i)
  if(i > -1 & i < 1){
    counter <- counter + 1
  }
}
counter / N

#------------------------------------
rm(list=ls())

getwd()
setwd("D:/Users/felipelyra/Documents")

fin<- read.csv("P3-Future-500-The-Dataset.csv")

head(fin)
tail(fin,5) #ultimas 5 linhas
str(fin)
summary(fin)

#changing from non-factor to factor
fin$ID
factor(fin$ID)
fin$ID <- factor(fin$ID)
str(fin)

fin$Inception <- factor(fin$Inception)
# o fator torna a variavel agrupável (como se fosse uma string)
summary(fin)

#fvt (factor variable trap) cuidado
a <- c("12","13","14","12","12")
a
typeof(a)
b <- as.numeric(a)
b
typeof(b)


z <- factor(c("12","13","14","12","12"))
z
# the trap
y <- as.numeric(z)
y #pega o agrupamento que o fator criou... nao serve mais
# maneira correta: fator -> caractere -> numerico
y <- as.numeric(as.character(z))
y

#gsub e sub
sub #uma ocorrencia
gsub #todas as ocorrencias

# replace bonitão
# padrao, trocar por, dataset
fin$Expenses <- gsub(" Dollars","",fin$Expenses)
fin$Expenses <- gsub(",","",fin$Expenses)

fin$Revenue <- gsub("$","",fin$Revenue) # nao funcionou pois $ e uma palavra reservada
fin$Revenue <- gsub("\\$","",fin$Revenue) # agora sim vai funcionar, com escape sequence \\
fin$Revenue <- gsub(",","",fin$Revenue)

# NA: not applicable / available
NA


head(fin,24)
# locating missing data
complete.cases(fin)

#elegant way
#porem nao traz todos, pois tem casos que nao sao NA
fin[!complete.cases(fin),]

# trazer com NA campos sem nada
fin<- read.csv("P3-Future-500-The-Dataset.csv", na.strings=c(""))
fin[!complete.cases(fin),]


# filtering with which
fin[fin$City == "Franklin",] #normal
which(fin$City == "Franklin")
fin[which(fin$City == "Franklin"),]


#fintering with is.na()
is.na(fin$Expenses)
fin[is.na(fin$Expenses),]


#remover registros com NA

fin[!complete.cases(fin),]
fin[!is.na(fin$Industry),] #not empty

fin <- fin[!is.na(fin$Industry),]

fin[is.na(fin$Industry),]

# resetando o indice de um data frame
rownames(fin) < 1:nrow(fin)
fin

#replace missing data
miss_state <- fin[is.na(fin$State) & fin$City=="New York",]

#BRUXARIA
fin[is.na(fin$State) & fin$City=="New York","State"] <- "NY"

miss_state <- fin[is.na(fin$State) & fin$City=="New York",]


# replace missing data com mediana
med_emp_retail <- median(fin[fin$Industry=="Retail","Employees"], na.rm=TRUE) #remove NAs
med_emp_retail
#media
mean(fin[fin$Industry=="Retail","Employees"], na.rm=TRUE) #remove NAs

med_emp_retail
# alterando o NA pelo valor
fin[is.na(fin$Employees) & fin$Industry=="Retail","Employees"] <- med_emp_retail


fin[3,]

#replacing: deriving values








load_packs <- function() {
  # Instala ou carrega automaticamente as bibliotecas definidas aqui
  list.of.packages <- c("dplyr", "plyr", "data.table","devtools", "openxlsx", "reshape2",
                        "lubridate", "scales", "RODBC", "ggplot2", "xtable","RPostgres",
                        "RPostgreSQL","zip", "ROracle", "dbConnect","odbc","RCurl", "lubridate","zipR","dbplyr")
  new.packages <- list.of.packages[!(list.of.packages
                                     %in% installed.packages()[,"Package"])]
  if(length(new.packages))
    install.packages(new.packages)
  lapply(list.of.packages,function(x){library(x,character.only=TRUE)})
}

#load_packs()

#library(RPostgreSQL)
library (RPostgres)

fStrConPostgres <- function()
{
  drv<-dbDriver("PostgreSQL")
  conPG <- dbConnect(RPostgres::Postgres(),dbname="dbfies",host="pgpool-la-02.mec.gov.br",port="6533", user="yvessobral",password="mec123")
}

con <- fStrConPostgres()

query <- "select * from inscricao.tb_fies_inscricao limit 10"
tabela <- base<-dbGetQuery(con,query)

str(tabela)

Sys.sleep(3)
