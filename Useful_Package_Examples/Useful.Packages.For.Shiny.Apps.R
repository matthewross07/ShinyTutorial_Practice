#This script highlights some useful packages for shiny. 
#Please add reproducible examples in this folder!

#These are two great libraries to download USGS data
library(EGRET)
library('dataRetrieval')


#Read in data from the reservoir in West Virginia that drains our research catchments:
#First number is USGS station id. Second number is data code for water height.
z <- readNWISDaily('03204250','00065')

#Amazing library for dealing with time data
library(lubridate)

#Convert timestamp to a format that R can read.
z$lubridate <- ymd(z$Date,tz='Etc/GMT-5')


#Convert level data into meters
z$meter <- z$Q*.3048
#Setup plot parameters
par(mfrow=c(2,1),cex=1,mar=c(4,4,2,0))
#Highlight days we sampled water chemistry.
sample.dates <- mdy(c('3/5/15','4/4/15'),tz='Etc/GMT-5')
#Subset sambled days from full dataset
smpl <- z[z$lubridate %in% sample.dates,]
#Plot data
plot(z$lubridate,z$meter, col='blue',lwd=2,type='l',ylab="Mean Daily Reservoir Height (m)",main='Mud River Reservoir, All Data',xlab='')
#Get 99.9% quantile
q.99.9 <- quantile(z$meter,probs=0.999)
#Add bar to see events above quantile
abline(h=q.99.9,col='darkgreen',lwd=2)
#Add explanation of line
mtext('99.9% exceedence threshold',line=-2)
#Add points at times where we sampled water chemistry
points(smpl$lubridate,smpl$meter, col='red',pch=19,cex=1)

#Maybe we want to look at a smaller section of data 
#during the water year in which we have sensor data

#Lubridate has a great way to get sections of time series data.
#First setup the interval of time you want.
dat.interval <- interval(mdy('10/1/2014',tz='Etc/GMT-5'),mdy('9/30/2015',tz='Etc/GMT-5'))
#Then subset your data
year2015 <- z[z$lubridate %within% dat.interval,]

#Plot subsetted data
plot(meter~lubridate,data=year2015,col='blue',lwd=2,type='l',ylab="Mean Daily Reservoir Height (m)",main='Mud River Reservoir, Study Period 2014-2015',xlab='Date')
#Add sample points. 
points(smpl$lubridate,smpl$meter, col='red',pch=19,cex=1)


#But that is kind of unsatisfying having to manually subset data. Maybe there is a better way?
#There is! dygraphs
library(xts) # A library to deal with time series data.
library(dygraphs) # A library to plot time series data

#First I need to create a column in the full dataset that holds only the days we sampled
z$Smpl.m <- NA
z[z$lubridate %in% sample.dates,'Smpl.m']<- z[z$lubridate %in% sample.dates,'meter']

#First turn the data into an xts object that holds both 
# the full dataset and the two dates we sampled. 
# Order.by is where you put in the time series data
z.xts <- xts(cbind(MudRiverRes_m = z$meter,Sample_Days = z$Smpl.m),order.by=z$lubridate)
dygraph(z.xts)
#Ok I really like R Markdown better so I stopped here. 

