# break statement
x <- 1:5
for (val in x) {
  if (val == 3){
    break # para todo o loop a partir da condicao
  }
  print(val)
}

#next statement
x <- 1:5
for (val in x) {
  if (val == 3){
    next #não executa mais nada na posicao atual do loop, pula para o proximo indice do loop
  }
  print(val)
}


#repeat (tipo um for ou while)
x <- 1
repeat {
  print(x)
  x = x+1
  if (x == 6){
    break
  }
}

###################
#functions
pow <- function(x, y) {
  # function to print x raised to the power y
  result <- x^y
  print(paste(x,"raised to the power", y, "is", result))
}

pow(3,3)

#Named Arguments
pow(8, 2)
pow(x = 8, y = 2)
pow(y = 2, x = 8)

#Default Values for Arguments
pow <- function(x, y = 2) {
  # function to print x raised to the power y
  result <- x^y
  print(paste(x,"raised to the power", y, "is", result))
}
pow(3) # sem passar o y, ele pega o default
pow(3,3)


#functions with return

check <- function(x) {
  if (x > 0) {
    result <- "Positive"
  }
  else if (x < 0) {
    result <- "Negative"
  }
  else {
    result <- "Zero"
  }
  return(result)
}

check(1)
check(-10)
check(0)

multi_return <- function() {
  my_list <- list("color" = "red", "size" = 20, "shape" = "round")
  return(my_list) 
}

a <- multi_return()
a
a$color


##############################
## R Programming Environment

a <- 2
b <- 5
f <- function(x) x<-0

#listar as variaveis e funcoes na memoria
ls()

#current environment
environment()


# we can see that a, b and f are in the R_GlobalEnv environment.
# Notice that x (in the argument of the function) is not in this global environment. 
# When we define a function, a new environment is created.

#Example: Cascading of environments
f <- function(f_x){
  g <- function(g_x){
    print("Inside g")
    print(environment())
    print(ls())
  }
  g(5)
  print("Inside f")
  print(environment())
  print(ls())
}

f(6)


## Scope (Local variables)
outer_func <- function(){
  a <- 20
  inner_func <- function(){
    a <- 30
    print(a)
  }
  inner_func()
  print(a)
}

a <- 80
outer_func()


#Accessing global variables
outer_func <- function(){
  inner_func <- function(){
    a <<- 30
    print(a)
  }
  inner_func()
  print(a)
}

outer_func()
a
print(a)




# Recursive function to find factorial
recursive.factorial <- function(x) {
  if (x == 0)    return (1)
  else           return (x * recursive.factorial(x-1))
}

recursive.factorial(8)
