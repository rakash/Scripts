
### This is to build at ARIMA on 2014-15 and predict for 2016(weeks)

###############Load the data - Start ###############################################

setwd("E:/week_forecast/TMI")

library('xlsx')

fileName = "2014_15_Tickets_Count_weekwise.xlsx"

timeData = read.xlsx (fileName, sheetIndex = 1, startRow=1, endRow=50)

colClasses = lapply (timeData, class)
colClasses = as.vector (colClasses, mode = "character")
colClasses [colClasses == "factor"] = "character"
colClasses [colClasses == "logical"] = "character"


#Use the classes from above to read the full data
timeData = read.xlsx2(fileName, sheetIndex = 1, startRow = 1, 
                         colClasses = colClasses)


View(timeData)
summary(timeData)

############## Load ENDS ######################################


###################### Prior to ARIMA STARTS ##########################################
library(TTR)

attach(timeData)

#itsm.tickets<- ts(TicketCount, start = c(2014,1),end = c(2015,53), frequency=52)

itsm.tickets <- ts(TicketCount, frequency=52, start=c(2014,1))


plot(itsm.tickets)

### Simply Moving Average Start ################
#timeDataSMA3 <- SMA(itsm.tickets,n=3)
#timeDataSMA3
#plot.ts(timeDataSMA3)
### Simply Moving Average END ################


### Decompose Start ################
timeDatacomponents <- decompose(itsm.tickets)
timeDatacomponents
plot(timeDatacomponents)

timeDataseasonallyadjusted <- itsm.tickets - timeDatacomponents$seasonal
plot(timeDataseasonallyadjusted)


timeDataTRENDadjusted <- itsm.tickets - timeDatacomponents$trend
plot(timeDataTRENDadjusted)
### Decompose END ################



##################### Prior to ARIMA ENDS ###########################

## Pre requisites ###
## Install packages : forecast and fpp

##Load the packages

library(forecast)
library(fpp)
library(tseries)


####### Latest ARIMA STARTS ###################
ndiffs(itsm.tickets)

acf(itsm.tickets, lag.max=20)
pacf(itsm.tickets, lag.max=20)

#### so p= 1, q=9 d=1
ticket1diff1 <- diff(itsm.tickets, differences=1)
plot.ts(ticket1diff1)

acf(ticket1diff1, lag.max=20)
pacf(ticket1diff1, lag.max=20)

#### so p= 4, q=1 d=1


#ticket1diff1 <- diff(itsm.tickets, differences=2)
#plot.ts(ticket1diff1)

adf = adf.test(ticket1diff1) 
kpss = kpss.test(ticket1diff1) 
adf
kpss


auto.arima(itsm.tickets, trace= TRUE, ic ="aicc", approximation = FALSE)
#finalmodel = arima(itsm.tickets, order = c(1, 1, 1))
finalmodel = arima(itsm.tickets, order = c(1, 1, 1), seasonal = list(order = c(0,1,1), period = 52))
summary(finalmodel)


# predict the next 12 periods
Forecastmodel = forecast.Arima(finalmodel, h = 52) 
Forecastmodel

plot(Forecastmodel)

####### Latest ARIMA ENDS ###################