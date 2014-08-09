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
png("plot2.png", width = 480, height = 480)
plot(powerData$dateTime, powerData$Global_active_power, type = "l",
     ylab = "Global Active Power (kilowatts)", xlab = NA)
dev.off()
