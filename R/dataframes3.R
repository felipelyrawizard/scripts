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


#24/10/2019
# statistical transformation

q <- ggplot(data=movies, aes(x=CriticRating, 
                             y=AudienceRating,
                             colour=Genre))
q + geom_point() + geom_smooth(fill=NA)

#boxplots
q <- ggplot(data=movies, aes(x=Genre, 
                             y=AudienceRating,
                             colour=Genre))
q + geom_boxplot(size=1.2)

q + geom_boxplot(size=1.2) + geom_point()

# jitter (ajuda a ver a quantidade de pontos naquela combinacao)
q + geom_boxplot(size=1.2) + geom_jitter()


# facets

v <- ggplot(data=movies, aes(x=BudgetMillions))
v + geom_histogram(binwidth=10, aes(fill=Genre),colour="Black") + facet_grid(Genre~.,scales="free")


#scatterplots

w <- ggplot(data=movies, aes(x=CriticRating, 
                                 y=AudienceRating,
                                 colour=Genre))
w + geom_point(size=3) + facet_grid(Genre~.)
w + geom_point(size=3) + facet_grid(Year~.)
w + geom_point(size=3) + facet_grid(Genre~Year) + geom_smooth()


# limits and zoom

m <- ggplot(data=movies, aes(x=CriticRating, 
                             y=AudienceRating,
                             size=BudgetMillions,
                             colour=Genre))
m + geom_point()
# ok, quero so apresentar uma parte - corta o grafico e da zoom
m + geom_point() + xlim(50,100) + ylim(50,100)


#------ themes

v <- ggplot(data=movies, aes(x=BudgetMillions))
h <- v + geom_histogram(binwidth=10, aes(fill=Genre),colour="Black")

h

#axes labels
h + 
  xlab("Money Axis") +
  ylab("Number of Movies") +
  ggtitle("Movie Budget Distribution") +
  theme(axis.title.x = element_text(colour="DarkGreen",size=30),
        axis.title.y = element_text(colour="Red",size=30),
        axis.text.x = element_text(size=15),
        axis.text.y = element_text(size=15),
        legend.title = element_text(size=20),
        legend.text = element_text(size=15),
        legend.position = c(1,1),
        legend.justification = c(1,1),
        
        plot.title =  element_text(colour="DarkBlue",size=40,family = "Courier")
        )




