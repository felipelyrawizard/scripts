# teste de funcoes
mylist <- list(a=1,b=2,c=3)
myfxn <- function(var1,var2){
  var1*var2
}
var2 <- 2

#var 1 é o item da lista, var2 é o multiplicador
sapply(mylist,myfxn,var2=var2)

myfxn2 <- function(var1){
  var1+1
}
sapply(mylist,myfxn2)
