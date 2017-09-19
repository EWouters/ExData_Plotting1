# Load libraries
library(data.table)
library(lubridate)
library(dplyr)

# Download data
fileName <- "exdata_data_household_power_consumption.zip"
if (!file.exists(fileName)) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile = fileName, method = "curl")
}

# Load data into power.df
power.df <- as.data.table(read.table((unz(fileName,"household_power_consumption.txt")), sep = ";", header = T, na.strings = "?",
                                     colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric")))

# Parse date and time and filter for two days in february
power.df <- power.df %>%
    mutate(datetime := dmy_hms(paste(Date,Time))) %>%
    select(-(Date:Time)) %>%
    filter(datetime >= ymd("2007-02-01") & datetime < ymd("2007-02-03"))

# Open the png graphics device
png(filename = "plot3.png", width = 504, height = 504, bg = NA)

# Create plot 3
plot(power.df$datetime, power.df$Sub_metering_1, type = "l",
     ylab = "Energy sub metering", xlab = "")
lines(power.df$datetime,power.df$Sub_metering_2, col = "red")
lines(power.df$datetime,power.df$Sub_metering_3, col = "blue")
legend("topright",
       legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       lwd = 1, col = c("black","red","blue"))

# Close the graphics device (saves the image)
dev.off()
