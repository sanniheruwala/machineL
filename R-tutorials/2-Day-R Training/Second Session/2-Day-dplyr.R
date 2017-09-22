#Setting work directory for today's session

setwd("C:\\Users\\SHeruwala\\Machine Learning\\R-tutorials\\2-Day-R Training\\FirstSession")

#Removing the existing objects
rm(list=ls())

#----------------------------------------------------------------------------------------------------------------------------------------

#To load the in-built datasets

#----------------------------------------------------------------------------------------------------------------------------------------

library(datasets)
data()

#----------------------------------------------------------------------------------------------------------------------------------------

#To load the iris data sets

#----------------------------------------------------------------------------------------------------------------------------------------

iris

#----------------------------------------------------------------------------------------------------------------------------------------

#Data Check

#----------------------------------------------------------------------------------------------------------------------------------------

class(iris)


head(iris)

str(iris)
#iris$Species = as.character(iris$Species)
#convert the categorial data from factor to character

#------------------------------------------------------------------------------------------------------------------------------------------

#dplyr()-Faster and elegant package for data manipulation
#dplyr()-Works only with data frame

#-----------------------------------------------------------------------------------------------------------------------------------------

#install.packages("dplyr")

library(dplyr)


#-------------------------------------------------------------------------------------------------------------------------------------------

#Subsetting data 

#------------------------------------------------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------------------------------------------------

#Filter () - To select certain rows

#------------------------------------------------------------------------------------------------------------------------------------------

#To select rows where we have only setosa 

Iris_Filter=filter(iris,Species=="setosa")

#Data Check

distinct(Iris_Filter,Species)


#To select rows where we have either setosa or virginica

Iris_Filter=filter(iris,Species=="setosa" | Species=="versicolor")


#Data Check

distinct(Iris_Filter,Species)


#To select rows where we have petal.width <=2.0 and Species == setosa

Iris_Filter=filter(iris,Species=="setosa" ,Petal.Width <=2.0 )


#Data Check

distinct(Iris_Filter,Species)


#------------------------------------------------------------------------------------------------------------------------------------------

#select() - To select certain columns

#-----------------------------------------------------------------------------------------------------------------------------------------


#To select only Sepal.Length and Sepal.Width columns

Iris_Select=select(iris,Sepal.Length,Sepal.Width)


#To drop certain column

Iris_Select=select(iris,-Sepal.Width)


#To select columns whose name starts with "Sepal"

Iris_Select=select(iris,starts_with("Sepal"))


#To select columns whose name ends with "Length"

Iris_Select=select(iris,ends_with("Length"))


#To select columns whose name contains a character string

Iris_Select=select(iris,contains("."))


#To select all the columns between Sepal.Length & Petal.Width

Iris_Select=select(iris,Sepal.Length:Petal.Width)


#To combine categorical variables (like concatenation in R)

Iris_Select=select(iris,Sepal.Length:Petal.Width)



#-----------------------------------------------------------------------------------------------------------------------------------------

#mutate() - To create new column based on existing dataset

#-----------------------------------------------------------------------------------------------------------------------------------------


#To create a new column by taking log for Sepal.Length

Iris_Mutate = mutate(iris,Log.Sepal.Length=log(Sepal.Length))


#To create a new column by taking log for Sepal.Length

Iris_Mutate = mutate(iris,Exp.Sepal.Length=exp(Sepal.Length))


#To create a new column by taking square root for Sepal.Length

Iris_Mutate = mutate(iris,Sqr.Sepal.Length=sqrt(Sepal.Length))


#To craete new column by combining Sepal.Length and Petal.Length

Iris_Mutate = mutate(iris,Length= Sepal.Length + Petal.Length)

#To create a flag variable

Iris_Mutate=mutate(iris,flag=ifelse((Species=="setosa"),"Type1" ,"Type2"))

#To combine two categorical variables

Iris_Mutate=mutate(Iris_Mutate,Flag2=paste(Species,flag))


#To create a flag variable

Iris_Mutate=mutate(iris,PW_Flag=ifelse(Petal.Width <= 1,"Low",ifelse((Petal.Width >= 2) & (Petal.Width <=3),"Medium","High")))


#Renaming the created variable

Iris_Mutate=rename(Iris_Mutate,PW_Flag2=PW_Flag)

#Check
str(Iris_Mutate)


#To change the type of a variable


Iris_Mutate$PW_Flag2=as.factor(Iris_Mutate$PW_Flag2)


#Check

str(Iris_Mutate)



#-----------------------------------------------------------------------------------------------------------------------------------------

#arrange() - To sort the data (In Ascending or descending order)

#-----------------------------------------------------------------------------------------------------------------------------------------

#To arrange the data in ascending order

iris_arrange=arrange(iris,Sepal.Width)


#To arrange the data in descending order

iris_arrange=arrange(iris,-Sepal.Width)


#To arrange the data in descending order (based on more than two columns)

iris_arrange=arrange(iris,desc(Sepal.Width,Petal.Length))


#Importing the dummy dataset (sorting.csv)

sorting=read.table("sorting.csv",sep=",",header=TRUE)


#Sorting the data based on gender and mark columns

sorting_new=arrange(sorting, desc(Gender),desc(Marks))


#----------------------------------------------------------------------------------------------------------------------------------------

# group_by () & summarize () - To find group by summary

#----------------------------------------------------------------------------------------------------------------------------------------

Gr_Species=group_by(iris,Species)

summarize(Gr_Species,mean(Sepal.Length),sd(Sepal.Length))


#---------------------------------------------------------------------------------------------------------------------------------------

#Task 1- Filter the rows with Petal.Length >=1.4 and find the mean of Sepal.Length

#---------------------------------------------------------------------------------------------------------------------------------------

#Normal Method

summarize(filter(iris,Petal.Length>=1.4),mean(Sepal.Length))

#Functional Pipelines %>% - Method
#here in filter need not to mention the dataset

iris%>%filter(Petal.Length>=1.4)%>%summarize(mean(Sepal.Length))

#---------------------------------------------------------------------------------------------------------------------------------------

#anova and ancova for analysis of variance and co-variance




