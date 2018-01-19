#exponantial smoothing
#halls
#halls winter
#arch and gorch model - stock



#------------------------------When to choose logistic regression---------------------------------
#linear regression cant pass if there is no continuous variable

#so we used logistics regression
#it gives signoid curve
#to choose classification cut off for prediction from probability use signnoid graph
#it gives probability of class
#------------------------------------------------------------------------------------------------

#------------------------to reduce error from logistic regresion------------
#to resduce error in logistics regression we use maximum likelihood estimate
#---------------------------------------------------------------------------

#-------------------------------svm over logistic----------------------------------
#for non linear SVM is better ... that is advantage og SVM over logistics
#SVM is data mining 
#Logistic regression is statistical 
#-----------------------------------------------------------------

#-----------------------------Choose method-----------------------------------
#simple logistics regression for linear and binary classification

#ordinal / multinomial(if there is order like high,medium,low) for linear and multi class classification
#---------------------------------------------------------------

#---------------------------------Data sampaling for better outcome from logistic regression/classification model-----------------------------------
#Synthatic minority over smapling
#If our data has very less mejority or minority class then we can use smot/ross package to create dummy data 
#which can increase our outcome and predict better 
#--------------------------------------------------------------------------------------

#------------------------best approch for logistic regression-------------------------------
#it follows bernol distribution
#there should not be correlation between independant variable
#rest all asssumption like linear regression wont work here
#--------------------------------------------------------

#--------------------------Probability calsulation from mod1-----------------------------
#logistic regression equation = log(p/1-p)=B0+B1*X1
#here we are trying to get probability which is  P here.
#to get ODDS in mod1 give = exp(estimate(B1))
#to get probability in mod1 give = exp(estimate(B1))/1+exp(estimate(B1))
#in mod1 intercept is base amount client get without doing anything
#-----------------------------------------------------------------------------------------

#step wise / forward regression / backward regression for feature selection
#mostly use stepwise regression for better feature selection

#------------------------------------------------------------------------------------------------
#Clearing R temporary memory and setting the working directory
#-----------------------------------------------------------------------------------------------

rm(list=ls())

setwd("C:\\Users\\SHeruwala\\Machine Learning\\R-tutorials\\Advanced\\3-Day R")


# Required packages

install.packages("gains",dependencies = TRUE)
install.packages("irr",dependencies = TRUE)
install.packages("caret",dependencies = TRUE)

library(gains)
library(dplyr)
library(irr)
library(caret)


#Objective: Direct Marketer who wants to come up with a process to identify good customers, identify customer id's who are considered good according to his definition

#------------------------------------------------------------------------------------------------
#Reading the raw data into R
#-----------------------------------------------------------------------------------------------

dm<-read.csv("DirectMarketing.csv")

#-----------------------------------------------
#Here we are creating target wwhich is classified and the we pass it as depedant variable instead of amount spent
##################################################################################################################
#Making the target variable binary
#-----------------------------------------------

dm%>%mutate(Target=ifelse(AmountSpent>mean(AmountSpent),1,0))->dm

#-----------------------------------
#here we have enough target data 1 and 0 so need not to do synthetic minority over sampling
###########################################################################################
# Excluding Amount Spent Column
#-----------------------------------

dm%>%select(-AmountSpent)->dm

# dm$Target=as.factor(dm$Target)

summary(dm)

#---------------------------
#Minimal Data Prep
#---------------------------

dm$History1<-ifelse(is.na(dm$History),"Missing",as.character(dm$History))#replacing NA with missing rest same as it is
dm$History1<-as.factor(dm$History1)

summary(dm$History1)

# dm$Children<-as.factor(dm$Children)
# dm$Catalogs<-as.factor(dm$Catalogs)

dm<-dm[,-c(8,10)]

#Splitting into test and training samples
set.seed(200)
index<-sample(nrow(dm),0.70*nrow(dm),replace=F)#replace F is to not to pick same record
train<-dm[index,]
test<-dm[-index,]

#----------------------------------------------------
#glm for logistic regression
############################
#Build the first model using all the variables 
#-----------------------------------------------------

#here family for type of classification
#binomial for binary 
#multinomial for multi class

mod1<-glm(formula = Target ~ Age + Location + Salary + Children + Catalogs , family = "binomial", data = train)

#-----------------------------------------------
# step is usefull for column/feature selection
#direction stepwise is better
#it should show(call) same as mod1 for feature selection
#-------------------------------------------------
step(mod1,direction = "both")

summary(mod1)

# #Creating dummies
# 
# train$AgeYoung_d<-ifelse(train$Age=="Young",1,0)
# 
# train$Hist.Mid_d<-ifelse(train$History1=="Medium",1,0)
# 
# train$Children2_d<-ifelse(train$Children=="2",1,0)
# 
# train$Children3_d<-ifelse(train$Children=="3",1,0)
# 
# test$AgeYoung_d<-ifelse(test$Age=="Young",1,0)
# 
# test$Hist.Mid_d<-ifelse(test$History1=="Medium",1,0)
# 
# test$Children2_d<-ifelse(test$Children=="2",1,0)
# 
# test$Children3_d<-ifelse(test$Children=="3",1,0)
# 
# mod2<-glm(Target~AgeYoung_d+Location+Salary+Children3_d+Children2_d+Catalogs+Hist.Mid_d,data=train,family="binomial")
# 
# summary(mod2)

#------------------------
#predict on test data
#------------------------

pred<-predict(mod1,type="response",newdata=test)

head(pred)

#--------------------------------------------------------------------------------------------
# cut-off value to predict the dependent variables
#--------------------------------------------------------------------------------------------

table(dm$Target)/nrow(dm)

pred2<-ifelse(pred>=0.399,1,0)

#--------------------------------------------------------------------------------------------
# Confusion matrix
#--------------------------------------------------------------------------------------------

table(test$Target,pred2)

accuracy = (sum(156,104))/(sum(156,104,14,26))
accuracy


#--------------------------------------------------------------------------------------------
#To give table to client
########################
# Gains Chart - To be targeted
#--------------------------------------------------------------------------------------------

gains(test$Target,predict(mod1,type="response",newdata=test),groups=10)

test2=cbind(test,pred)

quantile(test2$pred,probs =c(0.10,0.20,0.30,0.40,0.50,0.60,0.70,0.80,0.90,1))

targeted=test[test2$pred>0.643997720&test2$pred<=0.999664304,"Cust_Id"]

#-----------------------------------------End--------------------------------------------#

#not needed to execute
#just for reference

# How to change the default refence category in R

class(train$Target)

mod1<-glm(formula = relevel(Target,ref= "0") ~ Age + Location + Salary + Children + Catalogs , family = "binomial", data = train)

summary(mod1)

