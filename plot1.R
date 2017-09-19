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
png(filename = "plot1.png", width = 504, height = 504, bg = NA)

# Create plot 1
hist(power.df$Global_active_power,
     col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")

# Close the graphics device (saves the image)
dev.off()
