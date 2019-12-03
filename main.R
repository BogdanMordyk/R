library("ggplot2")
library("httr")

response <- GET(
  "https://apidata.mos.ru/v1/datasets/3288/rows?api_key=d709b0f704b1c986bb4207a6bf2ebf4b"
  )
svet <- content(response)

svetdf <- data.frame(matrix(unlist(svet), ncol = 7, byrow = T))

colnames(svetdf) <- c(
  "global_id", "number", "global_id1",
  "duration_of_light", "date", "on_time", "off_time"
  )

svetdf$on_time <- as.POSIXct(svetdf$on_time, format = "%H:%M")
svetdf$off_time <- as.POSIXct(svetdf$off_time, format = "%H:%M")
svetdf$date <- as.Date(svetdf$date, format = "%d.%m.%y")

axes <- ggplot(
  data = svetdf,
  mapping = aes(x = date, ymax = off_time, ymin = on_time))

axes + geom_ribbon() + labs(
  title = "График включения и выключения света") + scale_y_datetime(
    name = "Время", labels = function(x) {
    substr(x, 12, 21)}) + scale_x_date(name = "Дата")
