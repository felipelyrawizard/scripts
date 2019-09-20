#vetores

vector <- c(3,45,56,732)
vector
is.numeric(vector)
is.integer(vector)

#passando integer
vector2 <- c(3L,12L,56L,732L)
vector2
is.numeric(vector2)
is.integer(vector2)

v3 <- c("a","B23","Hello",7)
v3
is.character(v3)
is.numeric(v3)



seq() #sequence

seq(1,15)
seq(1:15)
1:15
seq(1,15,2) # de 2 em 2
seq(1,15,4) # de 4 em 4



rep() #replicate

rep(3,10) # repetir tantas vezes

rep("a",5)

x <- c(80,20)
y <- rep(x,10)



# access the vector
w <- c("a","b","c","d","e")
w
length(w)
w[1] # indice
w[-1] #todos menos o indice 1
w[1:3] # somente os 3 primeiros indices
w[c(2,3,5)] #acessar os itens que vc quiser
w[-3:-5] # todos ate o 3, depois nao pega mais...5


x <- rnorm(5)
for (i in x){
  print(i)
}

#instalar pacote ou biblioteca
install.packages("ggplot2")
?qplot()
?ggplot()
?diamonds

#utilizar biblioteca
library(ggplot2)

