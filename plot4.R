# read in the data, need some time
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# find coal combustion related code using regex
coal_comb_index<-grepl('(Comb|Combustion|comb|combustion).*(Coal|coal)', SCC[,3])

# subset the code reference
coal_comb_only <- (SCC[coal_comb_index,])
coal_comb_related_code<-coal_comb_only$SCC

# subset the emission data, which should only contains coal combustion related emission
NEI_COAL_COMB <- NEI[NEI$SCC %in% coal_comb_related_code,]

# calc coal combustion related total emission by year
EMI_COAL_COMB_BY_YEAR<-aggregate(NEI_COAL_COMB[, 4:4], list(NEI_COAL_COMB$year), sum)

# give meaningful column names
names(EMI_COAL_COMB_BY_YEAR) <- c("Year", "Coal.Comb.Emission")

# scale the data if you don't need scientific notation on plots
EMI_COAL_COMB_BY_YEAR$Coal.Comb.Emission<-EMI_COAL_COMB_BY_YEAR$Coal.Comb.Emission/1000

barplot(EMI_COAL_COMB_BY_YEAR$Coal.Comb.Emission, names=EMI_COAL_COMB_BY_YEAR$Year, xlab="Year", ylab="Coal Combustion Related Emission(kilo tons)", main="Coal Combustion Related\nPM 2.5 Emission Over Years")

dev.copy(png, "plot4.png", width=480, height=480)
dev.off()
