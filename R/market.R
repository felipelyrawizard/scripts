
nullToNA <- function(x) {
  x[sapply(x, is.null)] <- NA
  return(x)
}

url_m <- "http://api.bitcoincharts.com/v1/markets.json"
mkt_data <- fromJSON(url_m)
str(mkt_data)
mkt_data2 <- lapply(mkt_data,nullToNA)
mkt_df <- do.call(rbind,lapply(mkt_data2,data.frame,stringsAsFactors=FALSE))
head(mkt_df)


## another

# Code to read compressed .gz files
# http://api.bitcoincharts.com/v1/csv/
# Data Source
bitcoin_file <- "bitstampUSD.csv.gz"
#bitcoin_file <- "foxbitBRL.csv.gz"
URL <- "http://api.bitcoincharts.com/v1/csv"
source_file <- file.path(URL,bitcoin_file)
# Data destination on local disk
dataDir <-"C:/felipe/"
dest_file <- file.path(dataDir,bitcoin_file)
# Download to disk
download.file(source_file,destfile = dest_file)
# Uncompress .gz file and read into a data frame
raw <- read.csv(gzfile(dest_file),header=FALSE)
head(raw,2)

names(raw) <- c("unixtime","price","amount")
raw$date <- as.Date(as.POSIXct(raw$unixtime, origin="1970-01-01"))
head(raw,2)


install.packages("xts")
install.packages("dygraphs")

library(dplyr)
library(xts)
library(dygraphs)
data_ <- select(raw,-unixtime)
rm(raw)
data_ <- mutate(data_,value = price * amount)
by_date <- group_by(data_,date)
daily <- dplyr::summarise(by_date,count = dplyr::n(),
                   m_price <-  mean(price, na.rm = TRUE),
                   m_amount <- mean(amount, na.rm = TRUE),
                   m_value <-  mean(value, na.rm = TRUE))

names(daily) <- c("date","count","m_value","m_price","m_amount")
head(daily,2)

# Make the m_value variable into a time series object
daily_ts <- xts(daily$m_value,order.by=daily$date)
tail(daily_ts)

# Plot with htmlwidget dygraph
dygraph(daily_ts,ylab="Preço(Dolar)", 
        main="Valor BTC - USD (Compras)") %>%
        dySeries("V1",label="Compra") %>%
        dyRangeSelector(dateWindow = c("2019-05-01","2020-01-20"))



# predict
if(!require(prophet)) install.packages("prophet")

library(prophet)

#We convert dataset as prophet input requires
df <- data.frame(ds = index(daily_ts),
                 y = as.numeric(daily_ts[,1]))

#prophet model application
prophetpred <- prophet(df)
future <- make_future_dataframe(prophetpred, periods = 360)
forecastprophet <- predict(prophetpred, future)
# grafico simples mostrando a predicao
plot(prophetpred, forecastprophet)

prediction_ts <- xts(forecastprophet$trend,order.by=forecastprophet$ds)
prediction_yhat <- xts(forecastprophet$yhat,order.by=forecastprophet$ds)

tail(prediction_ts)

# predicao com variavel yhat (fazer também com a trend)
dygraph(prediction_yhat,ylab="Preço(Dolar)", 
        main="Valor BTC - USD (Compras)") %>%
  dySeries("V1",label="Compra") %>%
  dyRangeSelector(dateWindow = c("2016-06-01","2020-02-19"))
