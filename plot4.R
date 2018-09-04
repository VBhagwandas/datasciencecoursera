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
hpc_subset <- subset(good_hpc, Date>= "2007-02-01" & Date<="2007-02-02", 
                     select = c(DateTime, Global_active_power, Sub_metering_1, 
                                Sub_metering_2, Sub_metering_3, Voltage, Global_reactive_power))

#clear workspace
rm(hpc, good_hpc, good)

#make plots
par(mfrow = c(2, 2))
with(hpc_subset,{
  plot(DateTime, Global_active_power, 
       col = "black", 
       type = "o",
       pch = ".",
       xlab = paste(""),
       ylab = paste("Global Active Power (kilowatts)"))
  
  plot(DateTime, Voltage, 
       col = "black", 
       type = "o",
       pch = ".",
       xlab = paste("datetime"),
       ylab = paste("Voltage"))
  
  plot(DateTime, Sub_metering_1, 
       col = "black", 
       type = "o",
       pch = ".",
       xlab = paste(""),
       ylab = paste("Energy sub metering"))
  #add extra lines
  lines(DateTime, Sub_metering_2, 
        col = "red", 
        type = "o",
        pch = ".")
  lines(DateTime, Sub_metering_3, 
        col = "blue", 
        type = "o",
        pch = ".")
  #add legend
  legend("topright", 
         col = c("black", "red", "blue"), 
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
         lty=1, cex=0.5, border=)
  
  plot(DateTime, Global_reactive_power, 
       col = "black", 
       type = "o",
       pch = ".",
       xlab = paste("datetime"),
       ylab = paste("Global_reactive_power"))
})


## Copy my plot to a PNG file
dev.copy(png, file = "plot4.png", width = 480, height = 480, units = "px") 
dev.off() 

#clear all variables
rm(list=ls())
