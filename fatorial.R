#The factorial of a number is the product of all the integers from 1 to that number. 
#For example, the factorial of 6 (denoted as 6!) is 1*2*3*4*5*6 = 720.


# take input from the user
num = as.integer(readline(prompt="Enter a number: "))
factorial = 1
# check is the number is negative, positive or zero
if(num < 0) {
  print("Sorry, factorial does not exist for negative numbers")
} else if(num == 0) {
  print("The factorial of 0 is 1")
} else {
  for(i in 1:num) {
    factorial = factorial * i
    print(factorial)
  }
  print(paste("The factorial of", num ,"is",factorial))
}

factorial(8)
