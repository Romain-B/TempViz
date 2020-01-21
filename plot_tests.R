library(datetime)

incub1 <- read.table("~/Documents/Labwork/incubators/2020-01-21_ST5SMART_ST05190166_DataRecord.csv",
                    h = T, skip = 3, sep = ";", as.is = T)

incub2 <- read.table("~/Documents/Labwork/incubators/2020-01-21_ST2SMART_ST02190250_DataRecord.csv",
                     h = T, skip = 3, sep = ";", as.is = T)

incub3 <- read.table("~/Documents/Labwork/incubators/2020-01-21_ST2SMART_ST02190249_DataRecord.csv",
                     h = T, skip = 3, sep = ";", as.is = T)


incub1$date <- as.POSIXct(incub1$date, format = "%Y.%m.%d %H:%M")
incub2$date <- as.POSIXct(incub2$date, format = "%Y.%m.%d %H:%M")
incub2 <- incub2[incub2$date > as.POSIXct("2020-01-20 00:00:00"),]
incub3$date <- as.POSIXct(incub3$date, format = "%Y.%m.%d %H:%M")
incub3 <- incub3[incub3$date > as.POSIXct("2020-01-20 00:00:00"),]


# incub$date <- as.datetime(incub$date)

ggplot(incub1, aes(x = date, y = temp.)) + 
  geom_point() + geom_line() + 
  geom_hline(yintercept = 15, col = "firebrick", linetype = "dashed", size = 2) +
  geom_hline(yintercept = c(15.5,14.5), col = "royalblue", linetype = "dotted", size = 1) +
  ggtitle("Incubator MFI1 (big one)")


ggplot(incub2, aes(x = date, y = temp.)) + 
  geom_point() + geom_line() + 
  geom_hline(yintercept = 20, col = "firebrick", linetype = "dashed", size = 2) +
  geom_hline(yintercept = c(19.5,20.5), col = "royalblue", linetype = "dotted", size = 1) +
  ggtitle("Incubator MFI2 (small top)")

ggplot(incub3, aes(x = date, y = temp.)) + 
  geom_point() + geom_line() + 
  geom_hline(yintercept = 25, col = "firebrick", linetype = "dashed", size = 2) +
  geom_hline(yintercept = c(24.5,25.5), col = "royalblue", linetype = "dotted", size = 1) +
  ggtitle("Incubator MFI3 (small bottom)")




incub2$date <- as.POSIXct(incub2$date, format = "%Y.%m.%d %H:%M")
incub2 <- incub2[incub2$date < as.POSIXct("2020-01-20 00:00:00"),]


ggplot(incub2[incub2$date < as.POSIXct("2019-12-19 00:00:00") & incub2$date > as.POSIXct("2019-12-12 00:00:00"),], aes(x = date, y = temp.)) + 
  geom_point() + geom_line() + 
  # geom_hline(yintercept = 20, col = "firebrick", linetype = "dashed", size = 2) +
  # geom_hline(yintercept = c(19.5,20.5), col = "royalblue", linetype = "dotted", size = 1) +
  ggtitle("Incubator MFI2 (small top)")

