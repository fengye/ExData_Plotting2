
# read in the data, need some time
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# subset Baltimore City
NEI_24510<-NEI[which(NEI$fips=='24510'),]

# calc total emission by year
EMI_BY_YEAR<-aggregate(NEI_24510[, 4:4], list(NEI_24510$year), sum)

# give meaningful column names
names(EMI_BY_YEAR) <- c("Year", "Total.Emission")

barplot(EMI_BY_YEAR$Total.Emission, names=EMI_BY_YEAR$Year, xlab="Year", ylab="Total Emission(tons)", main="PM 2.5 Emission Over Years\nin Baltimore City, Maryland")

dev.copy(png, "plot2.png", width=480, height=480)
dev.off()
