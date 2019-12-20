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


