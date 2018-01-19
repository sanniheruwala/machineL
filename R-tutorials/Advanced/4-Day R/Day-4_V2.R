#------------------------------------------approch------------------------------------------
#linear regression and logistic regression are peramatric approch
#if we have variable(columns) * 7 theen we can apply linear and logistics regression
#atleast to build base model we should have those many observations

#if we have all previous assumption are true and have enough observation then we can go for statistical/peramatric approch
#if we are violating assumptions and not enough/less observation then can go for datamining approch
#----------------------------------------------------------------------------------------------

#-----------------------------------alternative-----------------------------
#linear regression(statistical model) = regression tree(continuous dependant variable)(datamining approch)/Artificial neural net
#logistic regression(statistical model)= classification tree(categorial depedant variable)(datamining approch)
#---------------------------------------------------------------------------

#----------------------------------------how works-------------------------------------------------
#classsification works on = gini bassed//Gini Coefficients = (p(green))2 + (p(red))2
#random forest works on  = anoova based(analysis of variance)(combination of classification tree and regression tree)
#---------------------------------------------------------------------------------------

#--------------------------------------------classification tree----------------------------------
#in backend classification tree calculate GINI for each variable with combination
#chooses the best variable having more gini
#------------------------------------------------------------------------------------------------

#--------------------------------------------Random forest--------------------------------------
#to increase accuracy - boosting (weightage approch)//linear regression, classification tree

#to make model generalize - bagging (bootstrapping approch)//random forest is upgradded version of bagging
  #generate differant samples and makes multiple trees
  #apply voting and find best tree(classification)
  #apply predict 500 values based on tree and then average them (regression)

#random forest validation not required
#classification requires validation
#-----------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------
#Clearing R temporary memory and setting the working directory
#-----------------------------------------------------------------------------------------------

rm(list=ls())

setwd("C:\\Users\\SHeruwala\\Machine Learning\\R-tutorials\\Advanced\\4-Day R")

install.packages("rpart.plot",dependencies = TRUE)

# Required packages

library(dplyr)
library(irr)
library(rpart)
library(caret)
#Tree plotting
library(rattle)
library(rpart.plot)
library(RColorBrewer)

#Objective: Direct Marketer who wants to come up with a process to identify good customers, identify customer id's who are considered good according to his definition

#------------------------------------------------------------------------------------------------
#Reading the raw data into R
#-----------------------------------------------------------------------------------------------

dm<-read.csv("DirectMarketing.csv")


# # #Making the target variable binary
# # 
# # dm%>%mutate(Target=ifelse(AmountSpent>mean(AmountSpent),1,0))->dm
# # 
# # # Excluding Amount Spent Column
# # 
# # dm%>%select(-AmountSpent)->dm
# # 
# # # dm$Target=as.factor(dm$Target)
# # 
# # summary(dm)
# # 
# # #Minimal Data Prep
# # 
# # dm$History1<-ifelse(is.na(dm$History),"Missing",as.character(dm$History))
# # dm$History1<-as.factor(dm$History1)
# # 
# # summary(dm$History1)
# 
# # dm$Children<-as.factor(dm$Children)
# # dm$Catalogs<-as.factor(dm$Catalogs)

# dm<-dm[,-c(8,10)]


#Splitting into test and training samples
set.seed(200)
index<-sample(nrow(dm),0.70*nrow(dm),replace=F)
train<-dm[index,]
test<-dm[-index,]

#----------------------------------------------------------
#Building classification tree
#target is depndant variable
#method=class (if we have cat4egorial depndant variable) // classification tree
#method=annova(if we have continuos dependant variable) // regression tree
#--------------------------------------------------------------
mod<-rpart(Target~.,data=train[,-9],method="class")


#Base R commands
plot(mod, margin=0.1, main="Classification Tree for Direct Marketing")
text(mod, use.n=TRUE, all=TRUE, cex=.7)

#Fancy R plot using rattle

fancyRpartPlot(mod)
#---------------------------------------------------------------

printcp(mod) #gives error rate

#-----------------re building with diff variable-------------------------

mod<-rpart(Target~Location + Salary + Children + Catalogs ,data=train[,-9],method="class")

fancyRpartPlot(mod)
printcp(mod)
#---------------------------------------------------------------------------------------

# #Creating scree plot (When the screen plot goes underneath the dotted line we can stop the tree)
# plotcp(mod, minline = TRUE)

mod1<-prune(mod,cp= 0.010000)

fancyRpartPlot(mod1)

plot(mod1, margin=0.1, main="Classification Tree for Direct Marketing")
text(mod1, use.n=TRUE, all=TRUE, cex=1.0)


#Model Accuracy

t_pred = predict(mod1,test,type="class") #use annova for regression

confMat <- table(test$Target,t_pred)#confusion matrix

accuracy <- sum(diag(confMat))/sum(confMat)
accuracy=accuracy*100

#-------------------------------------------------------------------------------------------
# Random Forest
#-------------------------------------------------------------------------------------------


#For Random Forest
library(randomForest)
library(randomForestSRC)
library(caret)

# Model Building

set.seed(98040)

library(MASS)
#-------------------------------------------
#ntree should be optimal for better result
#-----------------------------------------

seg.rf = randomForest(as.factor(Target)~Age + Location + Salary + Children + Catalogs ,data=dm,ntree=7000,keep.forest=TRUE,importance=TRUE)


library(caret)

#------------------------------------------
#varImp is variable important
#------------------------------------------

varImp(seg.rf)


library(gplots)
library(RColorBrewer)

heatmap.2(t(varImp(seg.rf)[,1:2]),
          col=brewer.pal(9,"Blues"),
          dend="none",trace="none",key=FALSE,
          margins = c(18,18),cexRow = 1.3,cexcol=1.3,
          main="Variable importance for Amount Spent"
)


t_pred_rf = predict(seg.rf,dm,type = "response")



confMat <- table(dm$Target,t_pred_rf)

accuracy <- sum(diag(confMat))/sum(confMat)
accuracy=accuracy*100


# Code ends here

