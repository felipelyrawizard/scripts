#listas

#lista com tags (opcional)
x <- list("a" = 2.5, "b" = TRUE, "c" = 1:3)
str(x)
x

# a mesma lista sem tags
x <- list(2.5,TRUE,1:3)
str(x)
x

#teste
x <- list("name" = "Felipe", "age" = 31, "speaks" = c("Portuguese","English"))
str(x)

x[c(1:2)]    # index using integer vector
x[-2]        # using negative integer to exclude second component
x[c("age","speaks")]    # index using tags
x[c(T,F,F)]  # index using logical vector

#Indexing with [ as shown above will give us sublist not the content inside the component. 
#To retrieve the content, we need to use [[.
x["age"]
typeof(x["age"]) 
x[["age"]]
typeof(x[["age"]])

#modify a list
x[["name"]] <- "Clair"; x

#add components to a list
x[["married"]] <- FALSE; x

#delete components from a list
x[["age"]] <- NULL; x
x$married <- NULL; x
