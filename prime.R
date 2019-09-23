#A positive integer greater than 1 which has no other factors 
#except 1 and the number itself is called a prime number.
#Numbers 2, 3, 5, 7, 11, 13 etc. are prime numbers as they do not have any other factors.
#But, 6 is not prime (it is composite) since, 2 x 3 = 6.


# Program to check if the input number is prime or not
# take input from the user
num = as.integer(readline(prompt="Enter a number: "))
flag = 0
# prime numbers are greater than 1
if(num > 1) {
  # check for factors
  flag = 1
  for(i in 2:(num-1)) {
    if ((num %% i) == 0) {
      flag = 0
      break
    }
  }
} 
if(num == 2)    flag = 1
if(flag == 1) {
  print(paste(num,"is a prime number"),quote = FALSE) # tira as aspas duplas
} else {
  print(paste(num,"is not a prime number"),quote = FALSE) # tira as aspas duplas
}