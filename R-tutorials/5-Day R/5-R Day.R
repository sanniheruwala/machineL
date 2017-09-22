#----------------------------------------------------------------------------------------------------------------------------------
#Setting work directory
#Andy File for Statestical Practise Book
#ggmap and ggplot2
#univeriate/biveriate - we examine one variable (bar (categorial values), pie, line(continuous value), box plot(to get , min , max, other values in graph), histograms(continuous value))
#Kiesqure - to find reelation between two cetegorial var(positive, negative, no linear relationships) - multiple bar diagram in R
#corelation - to find relation between two continuos var - scatter plot in R
#multiveriate - we examine more than one variable (bubble chart,scatter plot)
#----------------------------------------------------------------------------------------------------------------------------------

rm(list=ls())

setwd("C:\\Users\\SHeruwala\\Machine Learning\\R-tutorials\\5-Day R")
#-----------------------------------------------------------------------------------------------------------------------------------
#Buit in packages and list of functions available in base R package
#-----------------------------------------------------------------------------------------------------------------------------------

library(help = "base")

options("defaultPackages")

#----------------------------------------------------------------------------------------------------------------------------------
#Univariate - Analysis
#----------------------------------------------------------------------------------------------------------------------------------

#Simple Bar Plot

library(datasets)

?mtcars

counts <- table(mtcars$gear)

barplot(counts,
        xlab="Number of Gears",ylim = c(0,20))

barplot(counts, main="Car Distribution", 
        xlab="Number of Gears",col="red")


# Simple Horizontal Bar Plot with Added Labels

counts <- table(mtcars$gear)
barplot(counts, main="Car Distribution", horiz=TRUE,
        names.arg=c("3 Gears", "4 Gears", "5 Gears"),col="blue")



#Pie - Chart

slices <- c(10, 12, 4, 16, 8) 

pie(slices)

lbls <- c("US", "UK", "Australia", "Germany", "France")

pct <- round(slices/sum(slices)*100)

lbls <- paste(lbls, pct) # add percents to labels 

lbls <- paste(lbls,"%",sep="") # ad % to labels 

#--------------------------------------------------------------------------------------------------------------------------------
#Using the default colors :-
#--------------------------------------------------------------------------------------------------------------------------------

pie(slices,labels = lbls,
    main="Pie Chart of Countries")


#--------------------------------------------------------------------------------------------------------------------------------
#Using the color pallets available in R :- 
#--------------------------------------------------------------------------------------------------------------------------------

A=pie(slices,labels = lbls, col=rainbow(length(lbls)),
    main="Pie Chart of Countries")


#Different color pallets in R

#rainbow(n),heat.colors(n),terrain.colors(n),topo.colors(n)

#The pie3D( ) function in the plotrix package provides 3D exploded pie charts


#----------------------------------------------------------------------------------------------------------------------------------
#User defined colrs:-
#----------------------------------------------------------------------------------------------------------------------------------

#Choosing the colors

colors = c("red", "yellow", "green", "violet", 
            "orange", "blue", "pink", "cyan")

#Using the choosen colors inside the chart

pie(slices,col=colors)

#--------------------------------------------------------------------------------------------------------------------------------
#Box plot in R
#--------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------
#Loading the iris data set
#----------------------------------------------------------------------------------------------------------------------------------

library(datasets)

ir=iris

#Basic Box-Plot

boxplot(ir$Petal.Length)


#Improving the asethetics of boxplot

boxplot(ir$Petal.Length,col="red",main="Distribution of Petal Length")


#Drawing series of box plots (In this case across species)

#Please Note: In the below syntax x should have factor variable and y should have continuous variable

plot(x=ir$Species,y=ir$Sepal.Width,xlab="Species",main="Sepal Length across species",col="red")



#---------------------------------------------------------------------------------------------------------------------------------
#Histogram
#---------------------------------------------------------------------------------------------------------------------------------

#Basic Histogram

hist(ir$Sepal.Width,col="Orange")

#To get the labels

hist(ir$Sepal.Width,col="Orange",labels=TRUE)

#---------------------------------------------------------------------------------------------------------------------------------
#Bi variate analysis
#---------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------
#Relationship between two continuous variable can be examined by bi-variate plot or scatter plot
#----------------------------------------------------------------------------------------------------------------------------------

#Basic Plot

plot(x=ir$Petal.Width,y=ir$Petal.Length)

#Adding xlabels,ylabels and title - by using main,xlab and ylab parameters

plot(x=ir$Petal.Width,y=ir$Petal.Length,main=c("Petal Width Vs Petal Length"),xlab=c("Petal Width"),ylab=c("Petal length"))
     
     
#We can further improve othe plot by adding colour to the object that appears in the plot - by using col parameter

plot(x=ir$Petal.Width,y=ir$Petal.Length,main=c("Petal Width Vs Petal Length"),xlab=c("Petal Width"),ylab=c("Petal length"),col="red")


#Changing the point character of a plot - by using pch parameter

plot(x=ir$Petal.Width,y=ir$Petal.Length,main=c("Petal Width Vs Petal Length"),xlab=c("Petal Width"),ylab=c("Petal length"),col="red",pch=3)

?pch
#We can change the line width of the point character - by using lwd parameter

plot(x=ir$Petal.Width,y=ir$Petal.Length,main=c("Petal Width Vs Petal Length"),xlab=c("Petal Width"),ylab=c("Petal length"),col="red",pch=3,lwd=3)


#Making conditional bivariate plot

#Seeing relationship across different species


plot(x=ir$Petal.Width,y=ir$Petal.Length,main=c("Petal Width Vs Petal Length"),xlab=c("Petal Width"),ylab=c("Petal length"),
     col=ir$Species,pch=3,lwd=5)

#We can also change the shape of point characters - by using pch parameter

plot(x=ir$Petal.Width,y=ir$Petal.Length,main=c("Petal Width Vs Petal Length"),xlab=c("Petal Width"),ylab=c("Petal length"),
     col=ir$Species,pch=as.numeric(ir$Species),lwd=3)

#We can also change the size of the point character - by using cex parameter

plot(x=ir$Petal.Width,y=ir$Petal.Length,main=c("Petal Width Vs Petal Length"),xlab=c("Petal Width"),ylab=c("Petal length"),
     col=ir$Species,pch=as.numeric(ir$Species),lwd=3,cex=as.numeric(ir$Species))


#Adding legends


plot(x=ir$Petal.Width,y=ir$Petal.Length,main=c("Petal Width Vs Petal Length"),xlab=c("Petal Width"),ylab=c("Petal length"),
    pch=as.numeric(ir$Species))

legend(0.5,7,c("Setosa","Versicolor","Verginica"),pch=1:3,col=c("black","red","green"))


#--------------------------------------------------------------------------------------------------------------------------------
#Trend between two or more variables can be examined by line chart
#--------------------------------------------------------------------------------------------------------------------------------

#Creating vectors for line graph

v <- c(7,12,28,3,41)

t <- c(14,7,6,19,3)

u <- c(11,7,6,11,4)


# Saving the graph (png-portable network graphics)
png(file = "line_chart.png")


#Other formats are (png,jpeg,pdf)


# Plotting the lines

plot(v,type = "l",col = "red", xlab = "Month", ylab = "Rain fall", 
     main = "Rain fall chart")

lines(t, type = "l", col = "blue")

lines(u, type = "l", col = "green")

# To return to the default format

dev.off()

#-------------------------------------------------------------------------------------------------------------------------------
# Stacked Bar Plot with Colors and Legend
#-------------------------------------------------------------------------------------------------------------------------------

counts <- table(mtcars$vs, mtcars$gear)

barplot(counts, main="Car Distribution by Gears and VS",
        xlab="Number of Gears", col=c("darkblue","red"),
        legend = rownames(counts))


#-----------------------------------------------------------------------------------------------------------------------------
# Grouped Bar Plot
#-----------------------------------------------------------------------------------------------------------------------------
counts <- table(mtcars$vs, mtcars$gear)

barplot(counts, main="Car Distribution by Gears and VS",
        xlab="Number of Gears", col=c("darkblue","red"),
        legend = rownames(counts), beside=TRUE)
?mtcars


#----------------------------------------------------------------------------------------------------------------------------
#Displaying more than one plot in a ploting window - by using par(), mfrow()
#----------------------------------------------------------------------------------------------------------------------------

#Adding multiple plots in single plotting window
par(mfrow=c(1,2))

plot(x=ir$Species,y=ir$Sepal.Width,xlab="Species",main="Sepal Length across species",col="red")

plot(x=ir$Species,y=ir$Sepal.Width,xlab="Species",main="Sepal Length across species",col="red")


#---------------------------------------------------------------------------------------------------------------------------
#Geo spatial maps
#---------------------------------------------------------------------------------------------------------------------------

#Libraries required

library(ggmap)
library(ggplot2)

#Downloading "Bangalore" map using get map function

map=get_map("bangalore",maptype="hybrid",zoom = "auto",scale = "auto")

ggmap(map)

#Will now read the text file with lat long information and overlay the lat and long info on the downloaded map

#Reading the csv file with lat / long information

loc=read.csv("location.csv",header=TRUE)

ggmap(map)+geom_point(data=loc,aes(x=long,y=lat),color="red")

#---------------------------------------------------------------------------------------------------------------------------

#To return to the default setting
dev.off()
