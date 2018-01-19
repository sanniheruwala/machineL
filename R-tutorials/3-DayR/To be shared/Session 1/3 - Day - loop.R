#Setting work directory
library(mice)
library(lubridate)
#-------------------------------------
#mice uses pmm and logrig to fill the missing values
#PMM use linear regression
#LogReg is logistics regression 

setwd("C:\\Users\\SHeruwala\\Machine Learning\\R-tutorials\\3-DayR\\To be shared\\Session 1")

#---------------------------------------------------------------------------------------------------------------------------------
#Introducing apply() - 
#loop function - margin 1 to apply loop row wise - margin 2 to apply loop column wise - apply(data,margin,function(data))
#----------------------------------------------------------------------------------------------------------------------------------

#Creating a dummy dataset for analysis

Paper_1=c(43,42,23,32,44,45,12,19,20)

Paper_2=c(44,23,34,32,23,12,34,43,44)

Paper_3=c(43,42,23,32,44,45,12,19,20)

Paper_4=c(44,23,34,32,23,12,34,43,44)

Exam=data.frame(Paper_1,Paper_2,Paper_3,Paper_4)

#Adding the practical marks 50 and converting the total score to 50
#based on function and output deside wheather we need row wise computation or column wise

Revised_Marks=apply(Exam,2,function(x){(x+50)/2})

#-----------------------------------------------------------------------------------------------------------------------------------
#Introducing sapply() - it will aply over columns only
#-----------------------------------------------------------------------------------------------------------------------------------

#Creating a dummy dataset for analysis

Name=c("Raj","Vimal","Rahul")

Age=c(25,26,27)

Salary=c(1000,2000,3000)

Experience=c(2.5,3.5,1)

Emp_Details=data.frame(Name,Age,Salary,Experience)

#Calculate the average of all the numeric variables

#using loop

for(i in 1:length(Emp_Details))
{
  if(class(Emp_Details[,i])=="Integer" || class(Emp_Details[,i])=="numeric")
  {
    print(mean(Emp_Details[,i]))
  }
  else
  {
    print("NA")
  }
}


#using sapply()
#it will aply coulmn wise , so no need to mention margin
#it will handle categorical values
Avg=sapply(Emp_Details,function(x){mean(x)})


#using apply()
#apply wont handle categorical values, so we need dplyr
library(dplyr)
Emp_Deatilss=select_if(Emp_Details,is.numeric)

apply (Emp_Deatilss,2,function(x){mean(x)})
#apply (Emp_Deatilss,2,mean) both are same

#To round off numbers to two digits
#digits=2 to get values upto 2 decimal places
library(dplyr)
Emp_Deatilss=select_if(Emp_Details,is.numeric)

apply (Emp_Deatilss,2,function(x){round(mean(x),digits=2)})


#-----------------------------------------------------------------------------------------------------------------------------------
#Introducing tapply() - tapply(numeric var, categorial var , fun)
#-----------------------------------------------------------------------------------------------------------------------------------

#Creating dummy dataset for analysis

Roll_No=c(2156,1278,3456,5672)

Gender=c("M","F","F","F")

Subject=c("MAT","SCI","MAT","SCI")

Marks=c(98,89,78,99)

Perf=data.frame(Roll_No,Gender,Subject,Marks)

#To find the avg marks scored by M and F

Ag_M_F=tapply(Perf$Marks,Perf$Gender,sum)

#To find the avg marks scored by M and F across different subject

Ag_S_G=tapply(Perf$Marks,list(Perf$Gender,Perf$Subject),sum)


#Task 

#---------------------------------------------------------------------------------------------------------------------------------
#Importing the data into R directory
#---------------------------------------------------------------------------------------------------------------------------------

cricData=read.csv("Cricdata.CSV",header=TRUE)

#Column wise mean

for(i in 1:length(cricData))
{
  if(class(cricData[,i])=="integer" || class(cricData[,i])=="numeric")
  {
    print(paste("mean of column ", colnames(cricData[,i]), " is " ,mean(cricData[,i])))
  }
  else
  {
    print(paste("Column ",  colnames(cricData[,i]), " is of type",class(cricData[,i]) ))
  }
}


#----------------------------------------------------------------------------------------------------------------------------------
#sapply()
#----------------------------------------------------------------------------------------------------------------------------------

sapply(cricData,function(x){
  mean(x)
})


#----------------------------------------------------------------------------------------------------------------------------------
#apply()
#----------------------------------------------------------------------------------------------------------------------------------

library(dplyr)

Con_var=select_if(cricData,is.numeric)

apply (Con_var,2,name <- function(x)
{
  mean(x)
}
)


#----------------------------------------------------------------------------------------------------------------------------------
#tapply()
#----------------------------------------------------------------------------------------------------------------------------------

#One dimensional summarization

tapply(cricData$Price,cricData$Specialty,sum)


#Two dimensional summarixzation

tapply(cricData$Price,list(cricData$Franchise,cricData$Specialty),sum)


#Three dimensional summarization

tapply(cricData$Price,list(Country=cricData$Country,specialty=cricData$Specialty,Franchise=cricData$Franchise),sum)



#-----------------------------------------------------------------------------------------------------------------------------------
# Missing Value Treatment
#-----------------------------------------------------------------------------------------------------------------------------------

#How to identify the missing values
#After identifying how to impute the missing values

#Creating a vector a with missing values

a=c(1,2,3,4,5,6,NA,NA,NA,7,8,9)

is.na(a)

sum(is.na(a))

rm(list=ls())

#Loading the inbuilt dataset airquality

library(datasets)

data()

#-----------------------------------------------------------------------------------------------------------------------
1> iris%>%filter(iris$Species=="setosa",iris$Sepal.Length>5)%>%mean()

2> lakers%>%filter(lakers$player == "Pau Gasol" & lakers$opponent == "POR" & format(ymd(lakers$date),format="%u") == "7")%>%count()

3> lakers%>%filter(lakers$team == "LAL" & lakers$opponent == "POR" )%>%count()

4> mtcars%>%group_by(gear)%>%summarize(mean(mpg))
   
5> lakers%>%filter(lakers$player == "Pau Gasol" & lakers$opponent == "POR")%>%count() 

6> library(arules)
   AdultUCI%>%filter(sex == "Female" & age<50 & race == "Black")%>%count()
   
7> gr_species = group_by(iris,Species)
   gr_species%>%summarise(mean(Sepal.Length))
   
8> lakers%>%filter(lakers$game_type == "home" & lakers$opponent == "PHX" & format(ymd(lakers$date),format="%u") == "3")%>%count()

9> laker_mutate = mutate(lakers,month = format(ymd(lakers$date),format="%B"),count = 1)
   laker_mutate%>%group_by(month)%>%summarise(sum(count))

10> library(arules) 
    AdultUCI%>%filter(sex == "Female" & race == "White" & `hours-per-week` < 25)%>%group_by(income)%>%summarise(mean(age))
#
#-----------------------------------------------------------------------------------------------------------------------

airquality

#Identifying the number of missing values in the variable Ozone

sum(is.na(airquality$Ozone))


#-----------------------------------------------------------------------------------------------------------------------------------
#Identifying the number of missing values in each and every variable
#reduce the above function to one line for all columns
#----------------------------------------------------------------------------------------------------------------------------------

apply(airquality,2,function(x){sum(is.na(x))})


#Missing values can also be identified using summary() function

summary(airquality)


#----------------------------------------------------------------------------------------------------------------------------------
#Imputing the missing cells with some constant number
#filling the missing values
#----------------------------------------------------------------------------------------------------------------------------------

airquality$Ozone[is.na(airquality$Ozone)]=45

#Check

summary(airquality)

#Imputing the missing value with mean

airquality$Solar.R[is.na(airquality$Solar.R)]=mean(airquality$Solar.R,na.rm=TRUE)


#Check
summary(airquality)

#----------------------------------------------------------------------------------------------------------------------------------
#Repeating the above task using sapply function
#reduce the above function to in short for all the columns using sapply()
#----------------------------------------------------------------------------------------------------------------------------------
rm(list=ls())

#Loading the inbuilt dataset airquality

library(datasets)

data()

airquality

#Replace the missising values with the constant 45

d1=airquality

summary(d1)

d1=sapply(d1, function(x) {ifelse(is.na(x), 45, x)})


#Replacing the missing values with mean of the column

d2=airquality

summary(d2)

d2=sapply(d2, function(x) {ifelse(is.na(x), mean(x, na.rm = TRUE), x)})
  

#-----------------------------------------------------------------------------------------------------------------------------------
#Missing value imputation - Multivariate imputation via chained equation
#--------------------------------------------------------------------------------------------------------------------------------

#Installing the package MICE

library(mice)


#loading the inbuilt datasets

library(datasets)
data()

#reading the inbuilt dataset air quality into R directory

impute=airquality

#Using apply function to calculate the percentage of missing values across all the columns in the data set

apply(impute,2,function(x){sum(is.na(x))/length(x)*100})

#Running MICE package to impute the missing values
#by defalut method is PMM bcus it is continuous values
#m is number of iteration

#it will impute 5 diff values for missing columns
impute1=mice(impute,m=5)

#Exploring the imputed values
#imp is imputed dataset by mice and we use that to select imputed values

impute1$imp$Ozone[1:37,]
impute1$imp$Solar.R[1:7,]

#Finalizing the imputed values

completeddata=complete(impute1,1)


#Check

summary(completeddata)
#---------------------------------------------------------------------------------------------------------------------------------#


