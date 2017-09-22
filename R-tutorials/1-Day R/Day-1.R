#-----------------------------------------------------------------------------------------
#General Instructions
#-----------------------------------------------------------------------------------------

# Use "#" to comment a line or syntax (like /*--*/ in SAS) - shortcut = ctrl + shift +c

# To run the syntax, we can use  > Run command (available in Ribbon) (or) Ctrl R

# Objects can be created either by using the assignment operator "=" or "<-"

# R is case sensitive.So, c is different from C

# Character element has to be enclosed in "" (double quotes)

# If we give same name for two different objects, second one will replace the first one

# Use the syntax "rm(list=ls())" to claer the R work Directory

# Ctrl +  L to clear the console window
 
#--------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------
#Buit in packages and list of functions available in base R package
#-------------------------------------------------------------------------------------

library(help = "base")

options("defaultPackages")

#-------------------------------------------------------------------------------------
#List of user-installed R packages and their versions
#-------------------------------------------------------------------------------------

installed.packages()
#--------------------------------------------------------------------------------------
#Let us see how to create different data structures in R
#--------------------------------------------------------------------------------------

#Vector

#Creating Numeric Vector

x=c(1,2,3,4)
x

#Creating Character Vector

x=c("A","B","C","D")
x


#Differentiang Missing Values & No Values

#Missing Values

y=c(NA,4,5)

length(y)

class(y)




#Identifying missing values in a vector

is.na(y) # Gives logical output

sum(is.na(y)) #Gives no of missing elements in an object

y[!is.na(y)] # Removes the missing value from a vector

mean(y,na.rm=TRUE) # To find the mean

y[is.na(y)]=45 # Replace the missing value by constant

y[is.na(y)]=mean(y,na.rm=TRUE) # Replace the missing value by mean of the vector


y

#No Values

y=c(NULL,4,5)

length(y)

class(y)

#Adding "Numeric" aswell as "Character" elements to a vector

x=c(1,"A",2)
x

class(x)

#How to add a constant to all the elements in a vector

x=c(1,2,3,4)

x+5
x-5
x*5
x/5



#We can add two vectors of same length but we cannot add two vector of different length

#Vectors of same length

x=c(1,2,3,4)
x

y=c(1,2,3)
y

#Adding two vectors x and y (of same length)
x+y


#Vectors of different length

x=c(1,2,3,4)
x[5]=5 # Adding an additional element to the vector
x

y=c(1,2,3)
y

#Adding two vectors x and y (of different length)
x+y


#We can extract a specific element(s) from a vector using [] bracket

#To extract the second element of a vector X
x[2]

#To extract all other elements of a vector excluding x
x[-2]

#To extract elements 1 to 3
x[1:3]

#To extract elements (1,3)

x[c(1,3)]

#Elements < 2 can be selected
x[x<2]

#How to get the default work directory

getwd()

#How to set the work directory

setwd("C:\\Users\\SHeruwala\\Documents")


#To save an object
save(x,file="obj_price.rda")


#To save the entire work space
save.image("all_work.Rdata")

#To remove a particular object 
rm(y)

ls()

#To remove all the objects
rm(list=ls())

#---------------------------------------------------------------------------------------
#Matrix
#---------------------------------------------------------------------------------------

#Let us create a matrix 3x2 matrix B
A=matrix(c(1,2,3,4,5,6),nrow=3,ncol=2)
A

#By default R passes value in column wise
B=matrix(c(1,2,3,4,5,6),nrow=3,ncol=2,byrow=TRUE)
B


#How to extract  element(s) from a matrix

#To extract an element in first row and second column
B[1,2]

#To extract all the elements in first row
B[1,]

#To extract all the elements in first column
B[,1]

#To extract the element in first row and second column , in second row and second column
B[c(1,2,3),2]

#To extract the element in first row and first column , in first row and second column
B[1,c(1,2)]

#To identify the dimension of matrix
dim(B)

#We can add two matrix of same dimension

A=matrix(c(1,2,3,4),nrow=2,ncol=2,byrow=TRUE)

B=matrix(c(1,2,3,4),nrow=2,ncol=2,byrow=TRUE)

#Adding two matrix
A+B


#---------------------------------------------------------------------------------------
#Lists
#---------------------------------------------------------------------------------------

#Let us see how to create a list using multiple vectors

y=list(name=c("Robert","James"),age=c(65,54),retired=c(TRUE,FALSE))

y

#Using square bracket, we can view only the first element of name
y[["name"]][2]

y[[1]][1]

y$retired

#---------------------------------------------------------------------------------------
#dataframe
#---------------------------------------------------------------------------------------

#let us see how to create a dataframe using multiple vectors

y=data.frame(name=c("Robert","James"),age=c(65,54),retired=c(TRUE,FALSE))
y

#To know the structure of y
str(y)

as.character(y$name)

#Let us see how to retain the class of a particular vector in data.frame

y=data.frame(name=c("Robert","James"),age=c(65,54),retired=c(TRUE,FALSE),stringsAsFactors = FALSE)
y

#To know the structure of y
str(y)


#To view the element in first row and in first column
y[1,2]

#######################################################################################

