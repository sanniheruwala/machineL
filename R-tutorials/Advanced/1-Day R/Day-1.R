#Packages Required

library(datasets) # To call the inbuilt dataset in R

library(fifer) # To generate stratified random sampling

#--------------------------

#if it gives warning or error while installing then,
#copy temp path(C:\Users\SHeruwala\AppData\Local\Temp\RtmpsFPbFx\downloaded_packages) and 
#extract all those files into documents/r/r 3.4.1/library.

#--------------------------

library(help = fifer) # To get the description about the packages
#for sample selection we use fifar
#also use for Activities, Including Plotting, Data Cleanup, and Data Analysis

############################################Intro#########################################
#we will discuss about 
#statistical conecept(linear regression, logistic regression, k-mean) (Banking and Healthcare domain)
#Datamining concept (Random forest and classification tree) 
#Dataminig concepts are better and more flexible than statistical 

#----------------------

#continuous(numerical values)
#categorical(quality or charecteristics)
  #ordinal (High,medium,low) - it follows some sequence
  #nominal (male , female),(black,white) - there is no order

#time series would be univariate continuous variable

#-----------------------

#independent variable - those variable who effects the other variable
#dependent variablle - those variable who are dependent on other variable /// also called performance variable

#-----------------------

#Univariate // single variable results (how something is performing)
  #Measures of central tendency :(e.g.) sum, mean, median, mode, standard deviation // gives only one value for all
  #Measures of dispersion :(e.g.) variance, standard deviation range // it shows consistancy about data
#if variance is small then we have consistant data

#-----------------------

#Bivariate analysis // directional results (find out relation which can help us to decide about trend/stroy)
  #Always keep independent variable at X-axis and dependent on Y-axis
  #numerical variable always on Y-axis
  #to find relation between two variables/to find pattern between datasets
    #Continuous - Continuous = Scatter plot
    #Categorical - Categorical = Multiple bar diagram
    #Categorical - Continuous = Box-Plot

#-----------------------

#Samples
  #Simple random sample - higher possibility of biasness
  #Stratified random sampling - less possibility of bias(classify category and then use random sample from each)
  #Systamatic sampling - sequential selection from records from data

#-----------------------

#Multivariate analysis
  #Linear regression
  #Logistics regression

#-----------------------

#There are three stages for modeling
  #1-stage we will validate data using bivariate 
  #2-stage we will do proper bivariate and make trends and feature selection
  #3-stage we will go for future predicition
############################################################################################


#------------------------------------------------------------------------------------------------
#Clearing R temporary memory and setting the working directory
#-----------------------------------------------------------------------------------------------

# To clear 

rm(list=ls())

# To set wd

setwd("C:\\Users\\SHeruwala\\Machine Learning\\R-tutorials\\Advanced\\1-Day R")


# Important_shortcuts

# Ctrl + Shift + c - To comment a line in R

# Ctrl + R - To run

# Ctrl + L - To clear the console

# For further short cuts >>> Click >>> Tools

#-----------------------------------------------------------------------------------------------------------------------------------
#Buit in packages and list of functions available in base R package
#-----------------------------------------------------------------------------------------------------------------------------------

library(help = "base")

options("defaultPackages")


#------------------------------------------------------------------------------------------------
# Basic Statistics
#-----------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------
# Univariate analysis
#------------------------------------------------------------------------------------------------

# Sum : Total of all the values in the data series
# Mean : The average of all the values in the data series
# Mid values of sorted data . Meaning : Take the dataset and sort in it in either ascending or descending order and then look at the middle value. If we have odd no of data points middle value is exactly the middle value. If we have even no of data points then middle value is actually two point in that case we have to take the average of two points
# Most frequently occurring value in the data series

#-------------------------------------------------------------------------------------------------
# Creating a vector called Data Series
#-------------------------------------------------------------------------------------------------

Data_Series = c(17, 4, 2, 35, 36, 36, 4, 18, 2, 4, 2, 38)


#-------------------------------------------------------------------------------------------------
# Measures of central tendency
#------------------------------------------------------------------------------------------------


# Calculating total
sum(Data_Series)


# Calculating mean
mean(Data_Series)


#Calculating median
median(Data_Series)


#Max in the data series
max(Data_Series)


#Min in the data series
min(Data_Series)


#Most repeated element in the vector
mode(Data_Series)


#-------------------------------------------------------------------------------------------------
# Measures of central tendency
#------------------------------------------------------------------------------------------------

#Variance

var(Data_Series)

# Standard Deviation

sd(Data_Series)

# Range

range(Data_Series)

max(Data_Series)

#-----------------------------------------------------------------------------------------------
# Introducing categorical vector
#-----------------------------------------------------------------------------------------------

Gender=c("Male","Male","Female","Female","Female","Male")

#Mean,median,max,min,standarddeviation,variance and range are not applicable in cataegorical vector

# Most occured category # Equivalent to mode function of numeric variables

table(Gender)

#-----------------------------------------------------------------------------------------------
# Case study - 1
#-----------------------------------------------------------------------------------------------

# You are trying to pick stock for investing in the equity market. 
# Shown below are the annual return summary for stocks A, B and C over period of 10 years. 
# If you were risk averse, which would you choose?


Stock_A = c(0.55,0.183,0.021,0.47,0.344,0.239,0.032,0.34,0.013,0.275)

Stock_B = c(0.305,0.15,0.151,0.15,0.376,0.231,0.334,0.286,0.21,0.265)

Stock_C = c(0.35,0.183,0.021,0.47,0.344,0.25,0.032,0.32,0.23,0.275)


# Creating dataframe to comapre variance at a shot

Decision=data.frame(Stock_A,Stock_B,Stock_C)


# standard deviation

#apply function loop through all the column and use user defined logic
#here(Decision,2,sd) 2 is to apply column wise  

Check=apply(Decision,2,sd) # Standard deviation reveals that it is good to invest in Stock B when compared to A and C

#-----------------------------------------------------------------------------------------------
# Case study - 2
#-----------------------------------------------------------------------------------------------

# Bivariate analysis

# Using direct marketing  dataset from a direct marketer, we have to identify and tell the factors that are 
# influencing some customers to spend more than other customers

# Reading the marketing data

Data=read.csv("DirectMarketing.csv",header=TRUE)

#Data=read.table("DirectMarketing.csv",header=TRUE,sep=",",skip=1)

class(Data)


#------------------------------------------------------------------------------------------------
# 1 - Is salary influencing customers to spent more?
#------------------------------------------------------------------------------------------------

plot(x=Data$Salary,y=Data$AmountSpent,main=c("Scatter plot - Salary vs Amount Spent
"),xlab=c("Salary"),ylab=c("Amount Spent"),col="Blue")

# Observation : There is a positive linear relationship between the variable salary and
# amount spent

#------------------------------------------------------------------------------------------------
# 2 - Is there any association between age and amount spent?
#-----------------------------------------------------------------------------------------------

#Please Note: In the below syntax x should have factor variable and y should have 
# continuous variable

plot(x=Data$Age,y=Data$AmountSpent,main=c("Box plot - Age vs Amount Spent
"),xlab=c("Age"),ylab=c("Amount Spent"),col="Blue")

# Observation : We could see that, middle and old age customers are spending more


#------------------------------------------------------------------------------------------------
# 3 - Is there any association between marital status and own hose / rental house ?
#------------------------------------------------------------------------------------------------

# Step : 1

#contigency/cross table

counts <- table(Data$Married,Data$OwnHome)

# Step : 2

barplot(counts, main="Marital status vs own house / rental house",
        ylab="counts", col=c("darkblue","Orange"),
        legend = rownames(counts), beside=TRUE)


#------------------------------------------------------------------------------------------------
# Generating simple random sampling and stratified random sampling from iris data
#------------------------------------------------------------------------------------------------

# Packages required
library(fifer)
library(devtools)

#Loading the inbuilt datasets
library(datasets)
data()


#Generating simple random sampling
index <- sample(1:nrow(iris), 5)
iris[index, ]

?stratified

#install.packages("car",dependencies = TRUE)

# Generating startified random sampling(dataset,Categorial column,numbers in percentage,selection from categorial column)
Setosa=stratified(iris, "Species",0.1,select = list(Species = c("virginica", "versicolor","setosa")))

# -----------------------------------------------End--------------------------------------------
