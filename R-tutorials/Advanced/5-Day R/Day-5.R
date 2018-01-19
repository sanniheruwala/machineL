#--------------------------------Use of K-Mean------------------------------------
#Cluster analysis break hetrogenous dataset to homogenenous datasets of group
#---------------------------------------------------------------------------------

#-----------------------------Types of clusters------------------------------
#hirarchical
#k-means/k-centroid(highly followed)
#k-prototype
#k-mode
#----------------------------------------------------------------------------

#-----------------------------For categorial clusturing/k-mod------------------------------
#if we have only coategorical variables

#then we have to use k-mod
#it works on hemming distance
#it will compare string by string and keep 1 for miss match char
#same number after summing creates clusters
#----------------------------------------------------------------------------

#------------------------------For Continuous and Categorical variable/k-prototypes--------
#if we have continuous and categorical variables 

#then we have to use k-prototype
#combination of k-means and k-mod
#----------------------------------------------------------------------------

#---------------------------------Steps-----------------------------
# k(2) denotes number of clusters we want to create

#normalise the (dependant)variables before assign it to k-mean
#Methods of scaling :
  #Divide each variable by the range after subtracting the lowest value
  #Divide each variable by the mean of the variable it takes on
  #Normalization of variables / z scoring of variables

# Choose k(2) random numbers(as centroid)
# Find eculcidian distance with those k(2) random numbers to all values in columns
# name them as cluster
# find nearest values for those k(2) cluster and average original values 
# assign those two average value as centroid of k(2) cluster
# again repeate same thing
#-------------------------------------------------------------------

#------------------------------------Accuracy Check------------------
#within sum of square // Should be less
#between sum of square // Should be high
#----------------------------------------------------------------------

#------------------------------------------------------------------------------------------------
#Clearing R temporary memory and setting the working directory
#-----------------------------------------------------------------------------------------------

rm(list=ls())

setwd("C:\\Users\\SHeruwala\\Machine Learning\\R-tutorials\\Advanced\\5-Day R")

#Objective: To classify the direct marketing data into Profitable , Neutral and Non-profitable customers

#------------------------------------------------------------------------------------------------

# Step1 : Reading and exploring the dataset

dm<-read.csv("DirectMarketing.csv")

# No of rows and no of columns in our data (dimension)
dim(dm)

# Structure of the data
str(dm)

# Column names in the data
names(dm)

# Summary of the data
summary(dm)


#---------------------------------------------------------------------------------------------
#Subsetting Data 
#---------------------------------------------------------------------------------------------

sample<-na.omit(dm[,c("Salary", "Catalogs", "AmountSpent")])

# No of rows and no of columns in our data (dimension)
dim(sample)

# Structure of the data
str(sample)

# Column names in the data
names(sample)

# Summary of the data
summary(sample)

##--------------------------------------Step2 : Scaling the data ---------------------------------------------
#(column  - mean(column))/sd(column)
#Repeat for all columns
#########################
#Standardise variable using normalizing
#########################

(sample[,"Salary"]-mean(sample[,"Salary"]))/(sd(sample[,"Salary"]))
(sample[,"Catalogs"]-mean(sample[,"Catalogs"]))/(sd(sample[,"Catalogs"]))
(sample[,"Catalogs"]-mean(sample[,"Catalogs"]))/(sd(sample[,"Catalogs"]))

# Putting in loop

list<-names(sample)
scaled_data<-data.frame(rownum<-1:1000)
for(i in 1:length(list))
{
  
  x<-(sample[,i]-mean(sample[,i]))/(sd(sample[,i]))
  scaled_data<-cbind(scaled_data,x)
  names(scaled_data)[i+1]<-paste("scaled_",list[i])
  print(list[i])
  
}
head(scaled_data)


scaled_data<-scaled_data[,-1]
# 
sample<-cbind(sample,scaled_data)
names(sample)
# head(sample)



##--------------------------------------Step3 : kmeans algorithm ---------------------------------------------

#syntax : kmeans(scaled_data,k) ; where k refers to the number of clusters
set.seed(200)
names(sample)
fit.km<-kmeans(sample[,4:6],2)

#We will get a list object
fit.km$size #No of observations in each cluster
fit.km$withinss #Within sum of squares metric for each cluster
fit.km$totss #The total sum of squares
fit.km$tot.withinss #Total within-cluster sum of squares, i.e., sum(withinss)
fit.km$betweenss #The between-cluster sum of squares, i.e. totss-tot.withinss
head(fit.km$cluster)


##--------------------------------------Step4 : find the optimal number of clusters (k value) ---------------------------------------------

#Create a screeplot-plot of cluster's tot.withinss wrt number of clusters

wss<-1:5
number<-1:5

for (i in 1:5)
  
{
  wss[i]<-kmeans(sample[,4:6],i)$betweenss
}

#Shortlised optimal number of clusters : between 2 and 3

#Better plot using ggplot2
library(ggplot2)
data<-data.frame(wss,number)
p<-ggplot(data,aes(x=number,y=wss),color="red")
p+geom_point()+scale_x_continuous(breaks=seq(1,20,1))


##--------------------------------------Step5a : Rerun the algorithm with k=3(optimal no)---------------------------------------------

#Build 3 cluster model
set.seed(100)
fit.km<-kmeans(sample[,4:6],3)

##Merging the cluster output with original data

head(fit.km$cluster)
sample$cluster<-fit.km$cluster

# Exporting the output to r working directory

write.csv(sample,"output.csv",row.names=FALSE)

##--------------------------------------Step5b : Profile the clusters---------------------------------------------

# 
# #Cluster wise Aggregates
# cmeans<-aggregate(sample[,1:3],by=list(sample$cluster),FUN=mean)
# cmeans
# dim(cmeans)
# 
# #Population Aggregates
# apply(sample[,1:3],2,mean)
# apply(sample[,1:3],2,sd)
# 
# list1<-names(cmeans)
# 
# #Z score calculation
# #z score =population_mean - group_mean /population_sd
# for(i in 1:length(list1))
# {
#   y<-(cmeans[,i+1] - apply(sample[,1:3],2,mean)[i])/(apply(sample[,1:3],2,sd)[i])
#   cmeans<-cbind(cmeans,y)
#   names(cmeans)[i+4]<-paste("z",list1[i+1],sep="_")
#   print(list1[i+1])
# }
# 
# cmeans<-cmeans[,-8]
# names(cmeans)

# Code ends here




