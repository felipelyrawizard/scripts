getwd()
movies <- read.csv("P2-Movie-Ratings.csv")
head(movies)
colnames(movies) <- c("Film", "Genre",
                      "CriticRating","AudienceRating",
                      "BudgetMillions","Year")

str(movies)
summary(movies)

# create a factor (trazer o ano para ser um fator ao inves de int )
factor(movies$Year)
movies$Year <-factor(movies$Year)
str(movies)
summary(movies)

#Aesthetics
install.packages("ggplot2")
library(ggplot2)
ggplot(data=movies, aes(x=CriticRating, y=AudienceRating)) + # o + tem q ficar aqui
  geom_point()

ggplot(data=movies, aes(x=CriticRating, 
                        y=AudienceRating,
                        colour=Genre,
                        size=BudgetMillions)) + geom_point()  # nao quebra o +



#plot with layers

p <- ggplot(data=movies, aes(x=CriticRating, 
                        y=AudienceRating,
                        colour=Genre,
                        size=BudgetMillions))

#lines
p + geom_line()

#multiple layers

p + geom_point() + geom_line()

#####
#overriding aesthetics
#####

#add geom layer
q <- ggplot(data=movies, aes(x=CriticRating, 
                             y=AudienceRating,
                             colour=Genre,
                             size=BudgetMillions))
# add geom layer
q + geom_point()

#overriding aes
#a variavel continua a mesma coisa, so o plot que muda com o override

#ex1
q + geom_point(aes(size=CriticRating))

#ex2
q + geom_point(aes(size=BudgetMillions))

#ex3
q + geom_point(aes(x=BudgetMillions))

#ex4 (reduce line size)
q + geom_line(size=1) + geom_point()


#mappig vs setting


# histograms and density

s <- ggplot(data=movies, aes(x=BudgetMillions))
s + geom_histogram(binwidth=10)

# add colour
s + geom_histogram(binwidth=10,aes(fill=Genre),colour="Black")

#density
s + geom_density(aes(fill=Genre))
s + geom_density(aes(fill=Genre),position="stack")


#-------- layer tips --------

t <-ggplot(data=movies, aes(x=AudienceRating))
t + geom_histogram(binwidth=10,
                   fill="White",colour="Blue")

# outro eito, nao precisa recriar a variavel alterando x
t <-ggplot(data=movies) # sem o aes

t + geom_histogram(binwidth=10,
                   aes(x=AudienceRating),
                   fill="White",colour="Blue")

t + geom_histogram(binwidth=10,
                   aes(x=CriticRating),
                   fill="White",colour="Blue")



