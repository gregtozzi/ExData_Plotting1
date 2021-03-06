# Read the data from the file.  Here I take advantage of the ordered data
# in the file only to read in those rows that are necessary for my plot.
# Reading the subset of the total file in from the start reduces the script's
# running time by nearly 80% over reading the entire file and subsetting.
# Because of the nature of the skip and nrow paramaters in read.table(),
# I've chosen to to into the file twice:  once to get the column names, and the
# second time to read the data.

firstRow <- read.table(file = "household_power_consumption.txt",
                       nrows = 1, sep = ";", header = TRUE)
powerData <- read.table(file = "household_power_consumption.txt",
                        skip = 66637, nrows = 2880, sep = ";",
                        na.strings = "?", header = FALSE)

# Use the header data in firstRow to set the column names in the powerData
# data frame.
colnames(powerData) <- colnames(firstRow)

# Concatentate the Date and Time columns of the data frame into a single vector
dateTime <- paste(powerData$Date, powerData$Time)

# Convert the contents of the dateTime vector to POSIXlt
dateTime <- strptime(dateTime, format = "%d/%m/%Y %H:%M:%S")

# Add the POSIXlt vector created above to the powerData data frame
powerData <- cbind(dateTime, powerData)

# Create the plot as a png
png("plot4.png", width = 480, height = 480)

# Establish the 2 x 2 matrix of plots
par(mfrow = c(2, 2))

# Construct the four plots
# Plot 1
plot(powerData$dateTime, powerData$Global_active_power, type = "l",
     ylab = "Global Active Power", xlab = NA)

# Plot 2
plot(powerData$dateTime, powerData$Voltage, type = "l",
     ylab = "Voltage", xlab = "datetime")

# Plot 3 - This one requires the use of lines() to add additional data to the
# plot.  It also requires a call to legend().  I've set the bty parameter in
# the call to legend() to "n" in order to do away with the default box around
# the legend.
plot(powerData$dateTime, powerData$Sub_metering_1, type = "l",
     ylab = "Energy sub metering", xlab = NA)
lines(powerData$dateTime, powerData$Sub_metering_2, col = "red")
lines(powerData$dateTime, powerData$Sub_metering_3, col = "blue")
legend(legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       "topright", lty = 1, col = c("black", "red", "blue"), bty = "n")

# Plot 4
plot(powerData$dateTime, powerData$Global_reactive_power, type = "l",
     ylab = "Global_reactive_power", xlab = "datetime")
dev.off()
