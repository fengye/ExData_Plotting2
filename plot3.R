library(ggplot2)

# read in the data, need some time
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# subset Baltimore City
NEI_24510<-NEI[which(NEI$fips=='24510'),]

# calc total emission by year and by type
EMI_BY_YEAR_TYPE<-aggregate(NEI_24510[, 4:4], list(NEI_24510$year, NEI_24510$type), sum)

# give meaningful column names
names(EMI_BY_YEAR_TYPE) <- c("Year", "Type", "Total.Emission")

p <- ggplot(data=EMI_BY_YEAR_TYPE, aes(x=Year, y=Total.Emission, group=Type, colour=Type, shape=Type)) + geom_line() + geom_point() + xlab("Year") + ylab("Total Emission(tons)") + ggtitle("PM 2.5 Emission By Type\nIn Baltimore City, Maryland")
print(p)

dev.copy(png, "plot3.png", width=640, height=480)
dev.off()
