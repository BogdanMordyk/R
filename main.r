library("ggplot2")
library("httr")

response <- GET("https://apidata.mos.ru/v1/datasets/3288/rows?api_key=d709b0f704b1c986bb4207a6bf2ebf4b")
svet <- content(response)

svetdf <- data.frame(matrix(unlist(svet), ncol=7, byrow=T))

colnames(svetdf) <- c("Global id", "Number", "Global id1", "Duration of light", "Date", "OnTime", "OffTime")

svetdf$OnTime <- as.POSIXct(svetdf$OnTime, format="%H:%M")
svetdf$OffTime <- as.POSIXct(svetdf$OffTime, format="%H:%M")
svetdf$Date <- as.Date(svetdf$Date,format="%d.%m.%y")

axes <- ggplot(
  data = svetdf,
  mapping=aes(x=Date, ymax=OffTime, ymin=OnTime))

axes + geom_ribbon() + labs(title = "График включения и выключения света") + scale_y_datetime(name = "Время", labels = function (x) {substr(x, 12, 21)}) + scale_x_date(name = "Дата")