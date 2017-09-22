#----------------------------------------------------------------------------------
#Setting work Directory
#---------------------------------------------------------------------------------
rm(list=ls())

setwd("C:\\Users\\SHeruwala\\Machine Learning\\R-tutorials\\4-Day R\\Session 2")

#---------------------------------------------------------------------------------
#Creating two dataframes df1 and df2
#---------------------------------------------------------------------------------

# data frame 1
df1 = data.frame(CustomerId = c(1:6), Product = c(rep("Oven", 3), rep("Television", 3)))
df1

# data frame 2
df2 = data.frame(CustomerId = c(2, 4, 6), State = c(rep("California", 2), rep("Texas", 1)))
df2


#-----------------------------------------------------------------------------------
#Inner Join
#Returns the rows that are common in both the dataframes
#----------------------------------------------------------------------------------

df<-merge(x=df1,y=df2,by="CustomerId")


library(dplyr)

#Inner Join (or) natural join

inner_join(df1, df2,by="CustomerId")

#-----------------------------------------------------------------------------------
#full join
#Returns all the rows from datafram1 and dataframe2
#-----------------------------------------------------------------------------------

df<-merge(x=df1,y=df2,by="CustomerId",all=TRUE)
str(df)

#full join
full_join(df1, df2,by="CustomerId")

#----------------------------------------------------------------------------------
#left join
#Returns all rows from the left dataframe, and any rows with matching keys from 
#the right dataframe
#----------------------------------------------------------------------------------

df<-merge(x=df1,y=df2,by="CustomerId",all.x=TRUE)

#left join
left_join(df1, df2,by="CustomerId")


#-----------------------------------------------------------------------------------
#right join
#Return all rows from the right dataframe, and any rows with matching keys from 
#the left dataframe
#-----------------------------------------------------------------------------------

df<-merge(x=df1,y=df2,by="CustomerId",all.y=TRUE)


#right join
right_join(df1, df2,by="CustomerId")


#-----------------------------------------------------------------------------------
#A Cross Join (also sometimes known as a Cartesian Join)
#Every row of one table being joined to every row of another table
#-----------------------------------------------------------------------------------

df<-merge(x = df1, y = df2, by = NULL)

#----------------------------------------------------------------------------------
#Two additional joins in dplyr(),which are not avaibale in base R
#----------------------------------------------------------------------------------
semi_join(df1,df2,by="CustomerId")   #keep only observations in df1 that match in df2

anti_join(df1,df2,by="CustomerId")  #drops all observations in df1 that match in df2

#----------------------------------------------------------------------------------
#If the two data frames have different names for the columns you want to match on
#----------------------------------------------------------------------------------

#creating two vectors A and B

A=data.frame(customer_id=c(1:10),Name=c("A","B","C","D","E","F","G","H","I","J"))

B=data.frame(id=c(1:10),Marks=c(98,99,98,97,96,99,99,97,96,100))

 
#left join (Base R function) - column name of primary key should remain same
df<-merge(x=A,y=B,by.x="customer_id",by.y="id",all.x=TRUE)


#left join (dplyr() function) - column name of primary key can be different
df1=left_join(A, B, by = c("customer_id" = "id"))

#---------------------------------------------------------------------------------
#Appending multiple dataframes with same variables togethe using rbind()
#---------------------------------------------------------------------------------

#Creating 3 dataframes df1,df2 and df3
df1=data.frame(CustomerId = c(1:6), Product = c(rep("Oven", 3), rep("Television", 3)))
df2=data.frame(CustomerId = c(7:12), Product = c(rep("Fridge", 3), rep("Air Conditioner", 3)))
df3=data.frame(CustomerId = c(7:12), Product = c(rep("Fridge", 3), rep("Air Conditioner", 3)))

#Checking whrther the variable names are same in all the dataframes
#rbind wont work if variable names ar enot same
names(df1) == names(df2) 
names(df1) == names(df3)

#Combining all the three dataframes into one dataframe (using rbind)
#Number of columns and its name should be same in both the tables
Combined=rbind(df1,df2,df3)

#To club new column , we use cbind , but here we need to have same rows in both the tables

#Either we can use the above syntax or the below one
Combined2=do.call(rbind,list(df1,df2,df3))
Combined2

#----------------------------------------------------------------------------------
#reshape2() - helps us to convert a data from long format to wide format and from wide format to long 
#format using the functions melt() and dcast()
#----------------------------------------------------------------------------------

#melt() helps to convert the data from wide format to long format
#dcast() helps to convert the data from long format to wide format

#Loading a package reshape2()
library(reshape2)

#Creating a dataframe in wide format

Person=c("Sankar","Ramesh","Mahesh")
Age=c(26,24,25)
Weight=c(70,60,65)

#by defalut data.frame is in wide format
wide=data.frame(Person,Age,Weight)
wide

str(wide)

#Coverting the data from wide format to long format using the function "melt" from reshape2 library
Long=melt(wide,id.vars="Person",value.name = "Demo Value")

str(Long)

#Coverting the data from long format to wide format using the function "dcast" from reshape2 library
Wide=dcast(Long,Person~variable,value.var = "Demo Value")

#-------------------------------------------------------------------------------
#Long data - Application
#melt() - wide to long
#dcast() - long to wide
#-------------------------------------------------------------------------------

Test_Control=data.frame(Id=c(1,2,3,4,5,6,7),Test=c(153,163,173,183,193,198,123),Control=c(153,163,173,183,193,198,123))
Test_Control

#Convertingg the wide format to long format by using melt()

library(reshape2)
Long=melt(Test_Control,id.vars="Id",value.name = "Demo Value")
Long

Original=dcast(Long,Id~variable,value.var="Demo Value")
Original

#--------------------------------------------------------------------------------
#Data Transpose
#--------------------------------------------------------------------------------

Dat=data.frame(Names=c("A","B","C"),Age=c(12,23,34),Marks=c(98,89,90))

Tran=data.frame(t(Dat))
