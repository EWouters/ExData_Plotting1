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
png(filename = "plot4.png", width = 504, height = 504, bg = NA)

# Set 2 by 2 plot layout
par(mfrow = c(2, 2))

# Create plot 4 (1,1)
plot(power.df$datetime, power.df$Global_active_power, type = "l",
     ylab = "Global Active Power", xlab = "")
# Create plot 4 (1,2)
plot(power.df$datetime, power.df$Voltage, type = "l",
     ylab = "Voltage", xlab = "datetime")
# Create plot 4 (2,1)
plot(power.df$datetime, power.df$Sub_metering_1, type = "l",
     ylab = "Energy sub metering", xlab = "")
lines(power.df$datetime,power.df$Sub_metering_2, col = "red")
lines(power.df$datetime,power.df$Sub_metering_3, col = "blue")
legend("topright", bty = "n",
       legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       lwd = 1, col = c("black","red","blue"))
# Create plot 4 (2,2)
plot(power.df$datetime, power.df$Global_reactive_power, type = "l",
     ylab = "Global_reactive_power", xlab = "datetime")

# Close the graphics device (saves the image)
dev.off()
