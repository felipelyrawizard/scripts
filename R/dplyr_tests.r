# treinando dplyr

library(nycflights13)
library(tidyverse)


head(flights)
tail(flights)

# Pick observations by their values (filter()).
# Reorder the rows (arrange()).
# Pick variables by their names (select()).
# Create new variables with functions of existing variables (mutate()).
# Collapse many values down to a single summary (summarize()).

#filtrando
jan1 <- filter(flights, month == 1, day == 1)

#R either prints out the results, or saves them to a variable. 
#If you want to do both, you can wrap the assignment in parentheses
(dec25 <- filter(flights, month == 12, day == 25))

nov_dec <- filter(flights, month %in% c(11, 12))

# 2 formas de filtrar voos que nao atrasaram
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

#ordenacao
arrange(flights, year, month, day)

arrange(flights, desc(arr_delay)) # quem é NA ficará por último (sempre)

#e como faz para filtrar NA primeiro?
arrange(flights, desc(is.na(arr_delay)))



# Select columns by name
select(flights, year, month, day)

# Select all columns between year and dep_time (inclusive)
select(flights, year:dep_time)

# Select all columns except those from year to day (inclusive)
select(flights, -(year:day))


# filtro de colunas
starts_with("abc") # matches names that begin with “abc”.
ends_with("xyz") # matches names that end with “xyz”.
contains("ijk") # matches names that contain “ijk”.
matches("coluna") #nome da coluna

select(flights, contains("TIME"))
origem_destino <- select(flights,contains("ori"),dest)
origem_destino <- select(flights,matches("ori"),ends_with("dest"))

# Drop variables with -
# retirando origem
NO_origin <- select(flights,-starts_with("ori"))


# alterar o nome de uma coluna
voos <- select(flights, tail_num = tailnum) # no select só vem a coluna especificada
voos <- rename(flights, tail_num = tailnum) #rename preserva toda a tabela


# trazer algumas variaveis, e depois todo o resto, sem duplicar as variais incluidas no começo
voos <- select(flights, time_hour, air_time, everything())

#What happens if you include the name of a variable multiple times in a select() call?
# it came just at once.
voos <- select(flights, time_hour, time_hour, time_hour)


flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time)
flights_sml <- mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60)

# you can refer to columns that you’ve just created
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

#If you only want to keep the new variables, use transmute():
flights_sml_gain <- transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)


#---------
# JOINS
#---------
airlines
airports
planes
weather


# subset
flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

# left join
flights2 %>%
  select(-origin, -dest) %>%
  left_join(airlines, by = "carrier")

# mesma coisa, porem usando mutate
flights2 %>%
  select(-origin, -dest) %>%
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

# join natural
flights2 %>%
  left_join(weather)

# os 2 tem year, mas significam outra coisa, entao, é necessário definir o a chave para join
f <- flights2 %>%
  left_join(planes, by = "tailnum")


# join com aeroportos de origem
flights2 %>%
  left_join(airports, c("origin" = "faa"))

# join com aeroportos de destino
flights2 %>%
  left_join(airports, c("dest" = "faa"))


# mesmo resultado:
#dplyr            base::merge()
#inner_join(x, y)  merge(x, y)
#left_join(x, y)   merge(x, y, all.x = TRUE)
#right_join(x, y)  merge(x, y, all.y = TRUE)
#full_join(x, y)   merge(x, y, all.x = TRUE, all.y = TRUE)

# top 10 destinos 
# faço um count agrupado pelo dest e já pego os 10 primeiros
top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest


#Now you want to find each flight that went to one of those destinations.
#You could construct a filter yourself:
todos_voos_top10 <- flights %>%
                          filter(dest %in% top_dest$dest)
todos_voos_top10

# or like dat:
flights %>%
  semi_join(top_dest)

# voos que nao possuem avioes cadastrados em planes
voos_sem_aviao_reg <- flights %>%
                    anti_join(planes, by = "tailnum") %>%
                    count(tailnum, sort = TRUE)

#Filter flights to only show flights with planes that have flown at least 400 flights.
todos_voos_aviao_400_viajens <- flights %>%
                      count(tailnum, sort = TRUE) %>%
                      filter(n >= 400)
# prova real
# N725MQ - 575 registros
nrow(flights %>% filter(tailnum == 'N725MQ'))



# Tidy Data

#Example: 
# World Health Organization Global Tuberculosis Report
# Afghanistan, Brazil, and China between 1999 and 2000

table1 # country year cases population
table2 #country year type  count
table3 #country year rate
table4a
table4b

#taxa (rate) de casos por população
table1 %>%
  mutate(rate = cases / population * 10000)

#agrupar e somar?
table1 %>%
  dplyr::count(year,  wt = cases)

# tidyr: gather() and spread().

# o 1999 e 2000 deveriam ser linhas, pois representam dados
table4a

#we need to gather those columns into a new pair of variables.
table4a %>%
  gather(`1999`, `2000`, key = "year", value = "cases")

table4b
table4b %>%
  gather(`1999`, `2000`, key = "year", value = "population")

# juntar as duas tabelas, ficar igual a tabela 1
tidy4a <- table4a %>%
  gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>%
  gather(`1999`, `2000`, key = "year", value = "population")
left_join(tidy4a, tidy4b)


# na tabela 2, cases e population sao dados, o ideal seria transforma-los em variaveis (colunas)
table2
spread(table2, key = type, value = count)


#Separating and Pull
# if there is a column that contains two (or more) variables

table3

table3 %>%
  separate(rate, into = c("cases", "population")) # By default, separate() will split values wherever it sees a non-alphanumeric character

#forçando a separação
table3 %>%
  separate(rate, into = c("cases", "population"), sep = "/")

# possivel separar uma coluna, passando o numero de caracteres para separacao
table3 %>%
  separate(year, into = c("century", "year"), sep = 2)


# unite() is the inverse of separate(): it combines multiple columns into a single column.
table5
table5 %>%
  unite(new, century, year) # padrao, ele junta com _

table5 %>%
  unite(new, century, year, sep = "")


#
# Strings with stringr
#

library(tidyverse)
library(stringr)

string1 <- "This is a string"
string2 <- 'To put a "quote" inside a string, use single quotes'

# subsetting string
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)

# negative numbers count backwards from end
str_sub(x, -3, -1)

# replace da primeira ocorrencia
x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")

#replace de todas as ocorrencias
str_replace_all(x, "[aeiou]", "-")

#alterar dentro de um vetor também
x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))


sentences %>% 
  head(5)
# flip the order of the second and third words
sentences %>%
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>%
  head(5)

# split the string in pieces
sentences %>%
  head(5) %>%
  str_split(" ")


"a|b|c|d" %>%
  str_split("\\|") %>%
  .[[1]]

fruit
# The regular call:
str_view(fruit, "nana")
# Is shorthand for
str_view(fruit, regex("nana"))


#----------------------
# Factors with forcats
#----------------------

library(tidyverse)
library(forcats)

x1 <- c("Dec", "Apr", "Jan", "Mar")

#It doesn’t sort in a useful way:
sort(x1)

month_levels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
month_levels

#Now you can create a factor:
y1 <- factor(x1, levels = month_levels)
y1

sort(y1)

# quando o fator nao entende uma variavel, ele a transforma em NA
x2 <- c("Dec", "Apr", "Jam", "Mar")
y2 <- factor(x2, levels = month_levels)
y2
sort(y2)

# unload a package
detach("package:reshape2", unload=TRUE) # tirando o plyr

# General Social Survey
gss_cat

gss_cat %>%
  count(race)

ggplot(gss_cat, aes(race)) +
  geom_bar()

#By default, ggplot2 will drop levels that don’t have any values. You can force them to display with:
ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)


# Modifying Factor Order
relig <- gss_cat %>%
  group_by(relig) %>%
  summarize(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
relig
str(relig)

ggplot(relig, aes(tvhours, relig)) + geom_point()

ggplot(relig, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()


rincome <- gss_cat %>%
  group_by(rincome) %>%
  summarize(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
rincome


ggplot(
  rincome,
  aes(age, fct_relevel(rincome, "Not applicable"))
) +
  geom_point()


#Modifying Factor Levels
gss_cat %>% count(partyid)


gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican" = "Strong republican",
                              "Republican" = "Not str republican",
                              "Independent" = "Ind,near rep",
                              "Independent" = "Ind,near dem",
                              "Democrat" = "Not str democrat",
                              "Democrat" = "Strong democrat",
                              "Other" = "No answer",
                              "Other" = "Don't know",
                              "Other" = "Other party")) %>%
  count(partyid)

# outra versao:
gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                Other = c("No answer", "Don't know", "Other party"),
                                Republican = c("Strong republican", "Not str republican"),
                                Independent = c("Ind,near rep", "Independent", "Ind,near dem"),
                                Democrat = c("Not str democrat", "Strong democrat"))) %>%
count(partyid)



#-------------------------------
#Dates and Times with lubridate
#-------------------------------

library(tidyverse)
library(lubridate)
library(nycflights13)

Sys.setenv(TZ='')
Sys.timezone()

today()
now()
# base
Sys.time()


flights %>%
  select(year, month, day, hour, minute) %>%
  mutate(
    departure = make_datetime(year, month, day, hour, minute)
  )



datetime <- ymd_hms("2019-12-26 12:34:56")

year(datetime)
month(datetime)
# dia do mes
mday(datetime)
# dia do ano
yday(datetime)
# dia da semana
wday(datetime)

# alterando componentes da data
(datetime <- ymd_hms("2016-07-08 12:34:56"))

year(datetime) <- 2020
datetime

month(datetime) <- 01
datetime

hour(datetime) <- hour(datetime) + 1
datetime

# alternativa
update(datetime, year = 2020, month = 2, mday = 2, hour = 2)


# Durations
h_age <- today() - ymd(19880324)
h_age

# lubridate
as.duration(h_age)

#Durations come with a bunch of convenient constructors
dseconds(15)
dminutes(10)
dhours(c(12, 24))
ddays(0:5)
dweeks(3)
dyears(1)

#You can add and multiply durations
dyears(1) + dweeks(12) + dhours(15)

#You can add and subtract durations to and from days
tomorrow <- today() + ddays(1)
tomorrow
last_year <- today() - dyears(1)
last_year

bere <- as.numeric(9)

if (bere == 1) {
  # do that
  print("true")
} else if (bere == 0) {
  # do something else
  print("false")
} else {
  # else 
  print("na")
}


do_it <- function(x, y, op) {
switch(op,
      plus = x + y,
      minus = x - y,
      times = x * y,
      divide = x / y,
      stop("Unknown op!")
      )
}
