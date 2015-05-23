
# read in the data, need some time
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# calc total emission by year
EMI_BY_YEAR<-aggregate(NEI[, 4:4], list(NEI$year), sum)

# give meaningful column names
names(EMI_BY_YEAR) <- c("Year", "Total.Emission")

# scale the data if you don't need scientific notation on plots
EMI_BY_YEAR$Total.Emission<-EMI_BY_YEAR$Total.Emission/1000

barplot(EMI_BY_YEAR$Total.Emission, names=EMI_BY_YEAR$Year, xlab="Year", ylab="Total Emission(kilo tons)", main="PM 2.5 Emission Over Years")

dev.copy(png, "plot1.png", width=480, height=480)
dev.off()
