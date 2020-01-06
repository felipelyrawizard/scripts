# mtcars machine learning
#https://towardsdatascience.com/create-predictive-models-in-r-with-caret-12baf9941236

library(caret)

data(mtcars)    # Load the dataset
head(mtcars)


#Now, let's create regression models to predict how many miles per gallon (mpg) a car model can reach based on the other attributes
#The formula can be written as "x ~ y, z, w" where x is the dependent variable, mpg, in our case, and y, z and w are independent variables
#If you want to pass all attributes you can write it as "x ~ ."

# Simple linear regression model (lm means linear model)
modelS <- train(mpg ~ wt,
               data = mtcars,
               method = "lm")

# Multiple linear regression model
modelM <- train(mpg ~ .,
               data = mtcars,
               method = "lm")

# Ridge regression model
modelR <- train(mpg ~ .,
               data = mtcars,
               method = "ridge") # Try using "lasso"


## 10-fold CV
# possible values: boot", "boot632", "cv", "repeatedcv", "LOOCV", "LGOCV"
fitControl <- trainControl(method = "repeatedcv", 
                           number = 10,     # number of folds
                           repeats = 10)    # repeated ten times

# pre-processamento
# center data (i.e. compute the mean for each column and subtracts it from each respective value);
# scale data (i.e. put all data on the same scale, e.g. a scale from 0 up to 1)
model.cv <- train(mpg ~ .,
                  data = mtcars,
                  method = "lasso", # now we're using the lasso method
                  trControl = fitControl,
                  preProcess = c('scale', 'center')) # default: no pre-processing

model.cv

test <- subset(mtcars,wt > 5)
test$hp <- test$hp * 0.9

# modelo linear simples
predictions <- predict(modelS, test)
predictions

# modelo linear nultiplo (todas as variaveis)
predictions <- predict(modelM, test)
predictions

# com controle e pre-processamento
predictions <- predict(model.cv, test)
predictions

# importancia
bere <- as.data.frame(predictions)
ggplot(varImp(model.cv))


#modelo proprio: usar casaco
library (openxlsx)
getwd()
planilha <- read.xlsx ("usa_casaco.xlsx", sheet = "Planilha1", startRow = 1, colNames = TRUE)

planilha$usa_casaco<-factor(planilha$usa_casaco)

# treino
modelS <- train(usa_casaco ~ .,
                data = planilha,
                method = "rpart",
                trControl = trainControl(method = "boot")
                )

modelS


#verifica_temperatura <- as.data.frame(planilha[,c("temperatura")])
#colnames(verifica_temperatura) <- "temperatura"

temperatura <- 20
horario <- 6
teste <- c(temperatura=temperatura,horario=horario)
predictions <- predict(modelS, newdata = )

predictions


install.packages("rpart.plot")
library(rpart.plot)
prp(modelS$finalModel, box.palette = "Reds", tweak = 1.2)



#-------------------------------------------
# https://www.machinelearningplus.com/machine-learning/caret-package/#61howtotrainthemodelandinterprettheresults?

# install.packages(c('caret', 'skimr', 'RANN', 'randomForest', 'fastAdaboost', 'gbm', 'xgboost', 'caretEnsemble', 'C50', 'earth'))

# Load the caret package
library(caret)

# Import dataset
orange <- read.csv('https://raw.githubusercontent.com/selva86/datasets/master/orange_juice_withmissing.csv')

# Structure of the dataframe
str(orange)

# See top 6 rows and 10 columns
head(orange[, 1:10])


# The first step is to split it into training(80%) and test(20%) datasets using caret’s createDataPartition function.
# Create the training and test datasets
set.seed(100)

# Step 1: Get row numbers for the training data
trainRowNumbers <- createDataPartition(orange$Purchase, p=0.8, list=FALSE) # 80%
length(trainRowNumbers)
# Step 2: Create the training  dataset
trainData <- orange[trainRowNumbers,]

# Step 3: Create the test dataset
testData <- orange[-trainRowNumbers,]


# Descriptive statistics
# The skimr package provides a nice solution to show key descriptive stats for each column.
library(skimr)
skimmed <- skim_to_wide(trainData)

skimmed

# Missing values
# Create the knn imputation model on the training data
preProcess_missingdata_model <- preProcess(trainData, method='knnImpute')
preProcess_missingdata_model

# Use the imputation model to predict the values of missing data points
library(RANN)  # required for knnInpute
trainData <- predict(preProcess_missingdata_model, newdata = trainData)
anyNA(trainData)


# See available algorithms in caret
modelnames <- paste(names(getModelInfo()), collapse=',  ')
modelnames

#--------------------------
# SET.SEED.... but why???
# o randomico sempre será qualquer coisa, quando executar set.seed na mesma instrução o randomico sempre será igual:
  
sample(LETTERS, 5)
sample(LETTERS, 5)

set.seed(1); sample(LETTERS, 5)
set.seed(1); sample(LETTERS, 5)

set.seed(1)
rnorm(4)
set.seed(1)
rnorm(4)
#--------------------------

# Set the seed for reproducibility
set.seed(100)

# Train the model using randomForest and predict on the training data itself.
model_mars = train(Purchase ~ ., data=trainData, method='earth')
fitted <- predict(model_mars)

varimp_mars <- varImp(model_mars)
plot(varimp_mars, main="Variable Importance with MARS")


#Prepare the test dataset and predict
predictions <- predict(model_mars, testData)
predictions


#Artigos interessantes:
# https://mineracaodedados.wordpress.com/2015/06/20/qual-a-diferenca-entre-lasso-e-ridge-regression/

# http://rstudio-pubs-static.s3.amazonaws.com/164910_14e8ac4bff4d49b2a0eaf6fe81a71f8b.html

#1. X - x-axis spatial coordinate within the Montesinho park map: 1 to 9
#2. Y - y-axis spatial coordinate within the Montesinho park map: 2 to 9
#3. month - month of the year: "jan" to "dec" 
#4. day - day of the week: "mon" to "sun"
#5. FFMC - FFMC index from the FWI system: 18.7 to 96.20
#6. DMC - DMC index from the FWI system: 1.1 to 291.3 
#7. DC - DC index from the FWI system: 7.9 to 860.6 
#8. ISI - ISI index from the FWI system: 0.0 to 56.10
#9. temp - temperature in Celsius degrees: 2.2 to 33.30
#10. RH - relative humidity in %: 15.0 to 100
#11. wind - wind speed in km/h: 0.40 to 9.40 
#12. rain - outside rain in mm/m2 : 0.0 to 6.4 
#13. area - the burned area of the forest (in ha): 0.00 to 1090.84  # this output variable is very skewed towards 0.0, thus it may make sense to model with the (logarithm transform). 


forestfires <- read.csv("http://www.dsi.uminho.pt/~pcortez/forestfires/forestfires.csv")

summary(forestfires)
str(forestfires)

require(dplyr)
forestfires <- forestfires %>% 
  dplyr::select(-day, -month)

require(reshape2)
require(ggplot2)

# transformando data
forestfires$log.Y <- log(forestfires$Y)
forestfires$log.DC <- log(forestfires$DC + 1)
forestfires$log.RH <- log(forestfires$RH)
forestfires$log.wind <- log(forestfires$wind)
forestfires$log.area <- log(forestfires$area + 1)

df <- melt(forestfires)
ggplot(df,aes(x = value)) + 
  facet_wrap(~variable, scales = "free_x") + 
  geom_histogram()


require(caret)
trainIndex <- createDataPartition(forestfires$log.area, p = .75, list = FALSE)

ttrain <- forestfires[trainIndex,]
test <- forestfires[-trainIndex,]

correlationMatrix <- cor(forestfires)
print(correlationMatrix)

install.packages("corrplot")
library(corrplot)
corrplot(correlationMatrix, method="circle", type="lower", order="hclust")


fitControl <- trainControl(method='cv', number = 10)

lasso.fit <- train(log.area ~ ., data=dplyr::select(train, FFMC,ISI,temp,DMC,log.DC,log.wind,X,log.Y ,RH, log.area), 
                   method='lasso', 
                   metric="RMSE",
                   tuneLength = 10,
                   trControl=fitControl)

plot(varImp(lasso.fit))

lasso_prediction <- predict(lasso.fit, dplyr::select(test, FFMC,ISI,temp,DMC,log.DC,log.wind,X,log.Y ,RH))

exp.lasso_prediction <- exp(lasso_prediction) - 1 #transformando o vetor de predição para a unidade original do problema (em ha).

lasso_prediction <- data.frame(pred = exp.lasso_prediction, obs = test$area)

round(defaultSummary(lasso_prediction), digits = 3)


