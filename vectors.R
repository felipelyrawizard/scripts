# https://www.datamentor.io/r-programming/vector/


#vetor
x <- c(1,5,4,9,0)
typeof(x)
length(x)
#transforma para o mais forte 
x <-c(1,5.4,TRUE,"nada")

#vetor de 1 a 7
x <- 1:7; x

#vetor de 
y <- 10:-10; y

seq(1, 3, by=0.2)          # specify step size

seq(1, 5, length.out=4)    # specify length of the vector

# acessando elementos
x
x[3] # access 3rd element
x[c(2, 4)]     # access 2nd and 4th element
x[-1]          # access all but 1st element
x[c(2, -4)]    # cannot mix positive and negative integers, only 0's may be mixed with negative subscripts
x[c(2.4, 4.12)]    # real numbers are truncated to integers

#modificando elementos
x <- -2:2
x[2] <- 0; x # modify 2nd element
x[x<0] <- 5; x   # modify elements less than 0
x <- x[1:4]; x      # truncate x to first 4 elements

#We can delete a vector by simply assigning a NULL to it.
x <- -2:2
x <- NULL
x[4]
#excluir variavel
rm(x)



