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

# subset to Baltimore City and Los Angels
NEI_24510<-NEI[which(NEI$fips=='24510'),]
NEI_06037<-NEI[which(NEI$fips=='06037'),]
# subset to Batltimore City and motor vehicle related data
NEI_24510_VEHICLE <- NEI_24510[NEI_24510$SCC %in% motor_vehicle_related_code,]
# subset to Los Angels and motor vehicle related data
NEI_06037_VEHICLE <- NEI_06037[NEI_06037$SCC %in% motor_vehicle_related_code,]

# calc motor vehicle related emission by year
EMI_VEHICLE_24510_BY_YEAR<-aggregate(NEI_24510_VEHICLE[, 4:4], list(NEI_24510_VEHICLE$year), sum)
EMI_VEHICLE_06037_BY_YEAR<-aggregate(NEI_06037_VEHICLE[, 4:4], list(NEI_06037_VEHICLE$year), sum)

# give meaningful column names
names(EMI_VEHICLE_24510_BY_YEAR) <- c("Year", "Motor.Vehicle.Emission")
names(EMI_VEHICLE_06037_BY_YEAR) <- c("Year", "Motor.Vehicle.Emission")

# draw plots
par(mar=c(5, 4, 4, 6) + 0.1)

# baltimore plot
plot(EMI_VEHICLE_24510_BY_YEAR$Year, EMI_VEHICLE_24510_BY_YEAR$Motor.Vehicle.Emission, xlab="Year", ylab="", yaxt="n", pch=16, ylim=c(0,100), col='blue', main="Motor Vehicle Related\nPM 2.5 Emission Over Years Comparison", cex.main=0.85)
lines(EMI_VEHICLE_24510_BY_YEAR$Year, EMI_VEHICLE_24510_BY_YEAR$Motor.Vehicle.Emission, col='blue')
mtext("Baltimore City(tons)",side=2,line=2.5)
box()
axis(2, ylim=c(0,100),col="blue",las=1)  ## las=1 makes horizontal labels

# draw over
par(new=TRUE)

# los angels plot
plot(EMI_VEHICLE_06037_BY_YEAR$Year, EMI_VEHICLE_06037_BY_YEAR$Motor.Vehicle.Emission, xlab="", ylab="", pch=15, axes=FALSE, ylim=c(0,2000), col='red', main="", cex.main=0.85)
lines(EMI_VEHICLE_06037_BY_YEAR$Year, EMI_VEHICLE_06037_BY_YEAR$Motor.Vehicle.Emission, col='red')
axis(4, ylim=c(0,2000),col="red",las=1)  ## las=1 makes horizontal labels
mtext("Los Angels(tons)",side=4,line=4)

# legend
legend("bottomleft",legend=c("Baltimore","Los Angels"),
  text.col=c("blue","red"),pch=c(16,15),col=c("black","red"))

dev.copy(png, "plot6.png", width=640, height=480)
dev.off()
