#unzip files
unzip("household_power_consumption.zip")
list.files()

#load household_power_consumption
#replace the "?" in text to NA with: na.strings = "?"
hpc = read.table("household_power_consumption.txt", sep=";", na.strings = "?", header=TRUE)

#remove NA
good <- complete.cases(hpc)
good_hpc <- hpc[good,]

#convert date and time to the date and time class and make 1 column
good_hpc[,"Date"] <- as.Date(good_hpc[,"Date"], "%d/%m/%Y")
good_hpc$DateTime <- strptime(paste(good_hpc$Date,good_hpc$Time), "%Y-%m-%d %H:%M:%S")

#create subset from the 2 day period in february 2007 (2007-02-01 and 2007-02-02)
hpc_subset <- subset(good_hpc, Date>= "2007-02-01" & Date<="2007-02-02", select = c(DateTime,Global_active_power))

#clear workspace
rm(hpc, good_hpc, good)

hist(hpc_subset$Global_active_power, col = "red", 
     main = paste("Global Active Power"), 
     xlab = paste("Global Active Power (kilowatts)"))

## Copy my plot to a PNG file
dev.copy(png, file = "plot1.png", width = 480, height = 480, units = "px") 
dev.off() 

#clear all variables
rm(list=ls())