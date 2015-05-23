# read in the data, need some time
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# vehicle realted
motor_vehicle_only<-grepl("(vehicle|Vehicle)", SCC[,3])

# unwanted categories that also matches vehicle
unwanted <-grepl("(Chem Manuf|Petrol Trans & Marketg|Surface Coating)", SCC[,3])

# subset type code
SCC_MOTOR_VEHICLE<-SCC[motor_vehicle_only & !unwanted, ]
motor_vehicle_related_code <- SCC_MOTOR_VEHICLE$SCC

# subset to Baltimore City
NEI_24510<-NEI[which(NEI$fips=='24510'),]
# subset to Batltimore City and motor vehicle related data
NEI_24510_VEHICLE <- NEI_24510[NEI_24510$SCC %in% motor_vehicle_related_code,]

# calc motor vehicle related emission by year
EMI_VEHICLE_BY_YEAR<-aggregate(NEI_24510_VEHICLE[, 4:4], list(NEI_24510_VEHICLE$year), sum)

# give meaningful column names
names(EMI_VEHICLE_BY_YEAR) <- c("Year", "Motor.Vehicle.Emission")

barplot(EMI_VEHICLE_BY_YEAR$Motor.Vehicle.Emission, names=EMI_VEHICLE_BY_YEAR$Year, xlab="Year", ylab="Motor Vehicle Emission(tons)", main="Motor Vehicle Related\nPM 2.5 Emission Over Years\nin Baltimore City, Maryland", cex.main=0.85)

dev.copy(png, "plot5.png", width=480, height=480)
dev.off()
