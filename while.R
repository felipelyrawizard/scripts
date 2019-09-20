
while(TRUE){
  print("Hello")
}

counter <- 1
while(counter < 12){
  print(counter)
  counter <- counter + 1
}

# 5 vezes
for(i in 1:5){
  print("Hello R")
}

# 6 vezes
5:10
for(i in 5:10){
  print("Hello R")
}


# -3 a 3
rm(answer)
x <- rnorm(1)
if(x > 1){
  answer <- "Greater than 1"
}else if(x >= -1){
  answer <- "Between -1 and 1"
}else{
  answer <- "Less than 1"
}

y <-rnorm(10)

y

