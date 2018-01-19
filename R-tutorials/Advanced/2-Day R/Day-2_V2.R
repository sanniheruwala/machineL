###############################################

#bivariate - when we want to check effect is positive or negative
#regression - when we want to check how much positive or negative

#multiple independant variable, there we use multi linear regression to predict

#Y=a+b(x)+e

#a = intercept(base line)
#b = slop
#e = error(diff between line and point in graph)

#Ordinary Least Regression (OLS) try's to identify best possible line by minimizing the error (its best for linear graph)

#simple linear regression applies only when we have one dependant and independant variable
#multi linear regression applies only when we have more than one indepedant variable(Here we will see example)

#-------------------------best model----------------------------------
#Avoid correlation between the independent variables(drop the variable)
#Dependent and independent variables should have a linear relationship
#Residuals should have constant variance(no biasness in data)

#Homoscedasticity & Hetroscedasticity(fitted and actual prediction)
  #for simple linear regression data should be homoscedasticity(linear path)
  #if data is hetroscedasticity then we have to change data to homo

#Three thing should follow for best model
#normality(data should have normal distribution)(if we have more than 30 data it will definately follow normality)
#homoscedasticity
#linearity
#---------------------------------------------------------------------

#-----------------------find missing value---------------------------
#to find missing value 
#kNN
#mice
#mean,medain
#---------------------------------------------------------------------

#------------------------Dataset type--------------------------------
#Crossectional(no time as independant)
#Time series(sales / time) time is independant variable
#--------------------------------------------------------------------

#panel structure data

#R2 and adjusted R2 differance is high then, there might be unnnecessary indepandant variable

#adjusted R2 is important
#step wise / forward regression / backward regression for feature selection
#mostly use stepwise regression for better feature selection

###############################################

#----------------------------------------------------------------------------------------
#Linear regression model
#---------------------------------------------------------------------------------------

#clearing the existing R memory

rm(list=ls())

#Setting work directory and 

setwd("C:\\Users\\SHeruwala\\Machine Learning\\R-tutorials\\Advanced\\2-Day R")

# Reading the data into R working directory

data<-read.csv("DirectMarketing.csv")

#----------------------------------------------------------------------------------------
#Packages Required
#---------------------------------------------------------------------------------------

library(dplyr)
library(ggplot2)
library(car)

#car for regression models

#---------------------------------------------------------------------------------------
# Data Check
#---------------------------------------------------------------------------------------

head(data)

#---------------------------------------------------------------------------------------
#For  linearity check
#####################
#*** Univariate and Bi-Variate analysis
#---------------------------------------------------------------------------------------

# Age

#here plot will automatically chooses the plot type 
#here we kept categorial and numerical

plot(data$Age,data$AmountSpent,col="red")

plot(data$Salary,data$AmountSpent,col="red")  #can say hetroscedascticity

#----------------------------------------------------------
#To drop unneccesary cols
#########################
#***Club unnnecessary values by box plot and create new col 
#-----------------------------------------------------------

summary(data$Age)


#Combine the Middle and Old levels together 

data$Age1<-ifelse(data$Age!="Young","Middle-Old","Young") # we can also use dplyr mutate function
data$Age1<-as.factor(data$Age1)
summary(data$Age1)

plot(data$Age1,data$AmountSpent,col="red")

#Gender

plot(data$Gender,data$AmountSpent,col="red")
summary(data$Gender)

#Own house

plot(data$OwnHome,data$AmountSpent,col="red")
summary(data$OwnHome)


#Married
summary(data$Married)
plot(data$Married,data$AmountSpent,col="red")

#Location
summary(data$Location)
plot(data$Location,data$AmountSpent,col="red")

#Salary
summary(data$Salary)
plot(data$Salary,data$AmountSpent)#Might be heteroescadasticity

#Children

summary(data$Children)
data$Children<-as.factor(data$Children)
plot(data$Children,data$AmountSpent,col="red")

data$Children1<-ifelse(data$Children==3|data$Children==2,"3-2",as.character(data$Children))
data$Children1<-as.factor(data$Children1)

summary(data$Children1)
plot(data$Children1,data$AmountSpent,col="red")


#Catalogs

summary(data$Catalogs)

data1<-data[,-c(1,7,8)]

#------------------------------------------------------------------------------------------
# Building initial model
#lm is linear model
#~. to select dependent variable and rest all as independant
#------------------------------------------------------------------------------------------

mod1<-lm(AmountSpent~.,data=data1[,-8])

summary(mod1)#here *** showed in result are most contributing variables

#------------------------------------------------------------------------------------------
#To get important columns
#########################
# Second Iteration - After dropping insignificant variables
#***Avoid correlation between the independent variable
#(dependent ~ independant)
#AmountSpent ~ Location + Salary + Catalogs + Children1
#------------------------------------------------------------------------------------------

mod2<-lm(formula = AmountSpent ~ Location + Salary + Catalogs + Children1, data = data1)

summary(mod2)

mod2$fitted.values

#------------------------------------------------------------------------------------------
#To check co-relation between categorial/independant variable // multicoliniarity
#############################################################
#Assumption checks
#Multicollinearity Check
#***GVIF value should be less than 7 or 1.5, which proves that our categorial values are not correlated/associated
#------------------------------------------------------------------------------------------

#Multicollinearity Check

vif(mod2)

#linearity
#no relation between independant variable

#Constant  variance check

plot(mod2$fitted.values,mod2$residuals) #Funnel shape #hetroscedasticity

#here homoscedacity not setisfied
#bcus of these predicted values are in minus
#mod2$fitted.values

#------------------------------------------------------------------------------------------
# Scoring the predicted value
#------------------------------------------------------------------------------------------

predicted<-mod2$fitted.values
actual<-data1$AmountSpent

dat<-data.frame(predicted,actual)

# Exorting Actual Vs predicted to R environment

write.csv(dat,"Act_Pred.csv",row.names=FALSE)

# Actual Vs Predicted

line(dat$actual,dat$predicted)
p<-ggplot(dat,aes(x=row(dat)[,2],y=predicted))
p+geom_line(colour="blue")+geom_line(data=dat,aes(y=actual),colour="black")



#------------------------------------------------------------------------------------------
#To drop homoscedasticity
#########################
# Third Iteration - After dropping insignificant variables
#homoscedasticity conversion  after applying sqrt
#in mod3 coefficient tess which columns can increse product sell
#------------------------------------------------------------------------------------------

mod3<-lm(formula = sqrt(AmountSpent) ~ Location + Salary + Catalogs + Children1, data = data1)

summary(mod3)

#------------------------------------------------------------------------------------------
#Homoscedascticity check
#########################
#Assumption checks
#------------------------------------------------------------------------------------------

#Multicollinearity Check

vif(mod3)

#Constant  variance check

plot(mod3$fitted.values,mod3$residuals) #Funnel shape
#now it is homoscedasticity


#------------------------------------------------------------------------------------------
# Scoring the predicted value
#------------------------------------------------------------------------------------------

predicted<-mod3$fitted.values
actual<-sqrt(data1$AmountSpent)
dat<-data.frame(predicted,actual)

# Exorting Actual Vs predicted to R environment

write.csv(dat,"Act_Pred_V3.csv",row.names=FALSE)

# Actual Vs Predicted

line(dat$actual,dat$predicted)
p<-ggplot(dat,aes(x=row(dat)[,2],y=predicted))
p+geom_line(colour="blue")+geom_line(data=dat,aes(y=actual),colour="black")


#------------------------------------------------------------------------------------------
#Code ends here
#------------------------------------------------------------------------------------------


