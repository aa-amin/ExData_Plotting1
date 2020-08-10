#===== Download dataset
filename <- "household_power_consumption.zip"

# Check and download if does not exist:
if (!file.exists(filename)){
      fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      download.file(fileURL, filename, method="curl")
}  

# Check and unzip if folder does not exist:
if (!file.exists("household_power_consumption")) { 
      unzip(filename) 
}

#===== Load  data files 
hpc <- read.table("household_power_consumption.txt", header = T, sep=";")
#===== subset data for two dayes c("1/2/2007", "2/2/2007")  
hpc_2day <- subset(hpc, Date  %in% c("1/2/2007", "2/2/2007") )
#===== create datetime col.
datetime <- paste(hpc_2day$Date, hpc_2day$Time)
hpc_2day$datetime <- strptime(datetime, "%d/%m/%Y %H:%M:%S")
#=== fix datatypes for all the variables except Sub_metering_3 is already numeric
#- first fix missing values with the sign "?"
for (i in 3:8) hpc_2day[hpc_2day[,i]=="?" ,i] <- NA_character_
# transform data from string to be numeric
for (i in 3:8) hpc_2day[,i] <- as.numeric(hpc_2day[,i])



#=== plot ====
png(file= "plot3.png" )
with(hpc_2day, {plot(datetime,Sub_metering_1, type="l", lty= 1, xlab= "", ylab= "Energy sub metering")
   lines(datetime,Sub_metering_2, col="red", type="l", lty= 1)
   lines(datetime,Sub_metering_3, col="blue", type="l", lty= 1)})
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty = 1, col = c("black","red","blue") )
dev.off()

