#--------------------------------------------------------------------------------------------------------------------
#Setting work directory
#--------------------------------------------------------------------------------------------------------------------
setwd("C:\\Users\\SHeruwala\\Machine Learning\\R-tutorials\\3-DayR\\To be shared\\Session 1")

#To remove all the existing dataset,objects from Rmemory

rm(list=ls())

---------------------------------------------------------------------------------------------------
#Introducing lubridate() package in R
#--------------------------------------------------------------------------------------------------------------------

#lubridate() package helps to convert character element to date element with the help of below functions

#It handles date stamp along with date

#It handles a field with multiple date formats

#Functions             #Date
#dmy()                  26/11/2008 # date datatype
#ymd()                  2008/11/26 # date datatype
#mdy()                  11/26/2008 # date datatype
#dmy_hm                 26/11/2008 20:15 #Posixct/Posixt datatype - we have to use .asdate to convert
#dmy_hms                26/11/2008 20:15:12 #Posixct/Posixt datatype - we have to use .asdate to convert


#Installing lubridate() package

library(lubridate)

#--------------------------------------------------------------------------------------------------------------------
#Application of lubridate() package
#-------------------------------------------------------------------------------------------------------------------

#Example 1

#Let us assume an object a with different date elements in it

a=c("24/11/2017","25/11/2017","26/11/2017")

class(a)

#Converting the character elements into date elements

a=dmy(a)

class(a)


#Example 2

#Let us assume an object a with different date elements in it

b=c("24.11.2017","25.11.2017","26.11.2017")

class(b)

#Converting the character elements into date elements

b=dmy(b)

class(b)


#Example 3

#Let us assume an object a with different date elements in it

c=c("01-Jan-2017","01-Feb-2017","02-Mar-2017")

class(c)

#Converting the character elements into date elements

c=dmy(c)

class(c)


#Example 4

#Let us assume an object a with different date elements in it

d=c("Mar-17","Apr-17","May-17")

class(d)


#Introducing "day" argument

full.dates <- paste("01", d, sep = "-")


#Converting the character elements into date elements

full.dates=dmy(full.dates)

class(full.dates)

#Alternative appr

library(zoo)
b=as.yearmon(d,"%b-%y")

#----------------------------------------------------------------------------------------------------------------------
# Unstructured Date
#----------------------------------------------------------------------------------------------------------------------

library(lubridate)

a=c("The date is 24/07/2017","The date is 31/12/2017")

Date=dmy(a)


#-----------------------------------------------------------------------------------------------------------------------
#Different date formats
#----------------------------------------------------------------------------------------------------------------------

library(lubridate)

data <- data.frame(initialDiagnose = c("14.01.2009", "9/22/2005", 
                                       "4/21/2010", "28.01.2010", "09.01.2009", "3/28/2005", 
                                       "04.01.2005", "04.01.2005", "Created on 9/17/2010", "03 01 2010"))



mdy <- mdy(data$initialDiagnose) 
dmy <- dmy(data$initialDiagnose) 
mdy[is.na(mdy)] = dmy[is.na(mdy)] # some dates are ambiguous, here we give 
data$initialDiagnose <- mdy        # mdy precedence over dmy



#---------------------------------------------------------------------------------------------------------------------
#What if we have different date formats in a same column
#---------------------------------------------------------------------------------------------------------------------

#Importing the text file having mixed date formats into R environment
Mixed_Format=read.table("mixed.txt",sep="\t",header=TRUE)

#Checking the structure of the dataset "Mixed_Format"
str(Mixed_Format)

#Using the parse_date_time function to read the dataset "Mixed_Format"

#Loading the library "lubridate"
library(lubridate)

#Defining all the formats existing in the dataset "Mixed_Format"
Mixed_Format$Date=parse_date_time(x = Mixed_Format$Date,
                          orders = c("d-m-y", "d/m/y", "d-m-y"))

#Checking the calss() of the dataset "Mixed_Format"
class(Mixed_Format$Date)


#Getting rid of "Time Zone Extensions" from the dataset "Mixed_Format"
Mixed_Format$Date=as.Date(Mixed_Format$Date)


#Checking the calss() of the new dataset "Mixed_Format"
class(Mixed_Format$Date)



#----------------------------------------------------------------------------------------------------------------------
#Date management based on date variable
#-----------------------------------------------------------------------------------------------------------------------

#Importing News data into R environment
News=read.table("News_Sub.txt",sep="\t",header=TRUE)
News

library(lubridate)

#Checking the structure of the data set "News"
str(News)

#Converting date columns from character to date
News$Sub_St_Date=mdy(News$Sub_St_Date)
News$Sub_En_Date=mdy(News$Sub_En_Date)
str(News)


#Loading dplyr() package to impute a new column(s)
library(dplyr)


#Creating a new variable "subscription start Month"
News2=mutate(News,Sub_St_mth=month(Sub_St_Date))

#Creating a new variable "subscription start year"
News3=mutate(News2,Sub_St_yr=year(Sub_St_Date))


#Filtering the observation(s) who started the subscription in the month of August 15 & 2016
Aug_15_16_Sub=filter(News3,Sub_St_mth==8,Sub_St_yr==2015|Sub_St_yr==2016)


#Filtering the observation(s) who subscribed "Business Standard" in the month of "August 2016"
Aug_16_Busi_Standard=filter(News3,Sub_St_mth==8,Sub_St_yr==2016,New_Paper_Sub=="Business Standard")


#----------------------------------------------------------------------------------------------------------------------
#Using format() to change the default format (YYYY/MM/YY) of R
#----------------------------------------------------------------------------------------------------------------------


start_numeric <- ymd('20170215')
start_numeric


d=format(start_numeric, "%Y%m%d")

#---------------------------------------------------------------------------------------------------------------------

# Different date formats available in R

# Code    -      Value
# %d      -     Day of Month (Number)
# %m      -     Month (number)
# %b      -     Month (Abbrevated (e.g) - Jan,Sep)
# %B      -     Month (Full Name  (e.g) - March, October)
# %y      -     Year  (2 Digits   (e.g) - 2011 as 11)
# %Y      -     Year  (4 Digits   (e.g) - 2014 as 2014)


#Few date format specifiers for better understanding

#Example 1: 25/Aug/14 - has to be read in R as "%d/%b/%y"

#Example 2: 25-August-2017 - has to be read in R as "%d-%B-%Y"

#---------------------------------------------------------------------------------------------------------------------

#Commonly used string operators in R

#---------------------------------------------------------------------------------------------------------------------

#Let us create an object a with string "Bat-Man"

a="Bat-man"

#Substr() helps to create a substring from the existing string

b=substr(a,start=5,stop=7)

#Inorder to know the no of elements in a string, we have a function called nchr()

nchar(a)

#To convert all the elements of a string to lower case, we have fuction called tolower()

tolower(a)

#To convert all the elements of a string to upper case, we have fuction called toupper()
toupper(a)


#To concatenate two objects, we have a function called paste()

a="Super"

b="Man"

c=paste(a,b)

#To replace a certain elements with new elements, we have a function called gsub()

a="Super-Man"

gsub("-","/",a)


#To get the position of a match in a string

a="Super-Man"

regexpr("-",a)


#Using the above functions, we can convert, a string to propercase from uppercase

a="SUPERMAN"

#Step 1 : Seperating "S" from "SUPERMAN"

A=substr(a,1,1)

#Step 2 : Sepearting "UPERMAN" from "SUPERMAN"

B=substr(a,2,nchar(a))

#Step 3 : Conveting the substing obtained in step to lowercase

C=tolower(B)

#Step 4 : Concatenating the substrings obtained in Step 1 and Step 3

D=paste(A,C)

#Step 5 : Replacing the extra space between "S" and "uperman" with ""

E=gsub(" ","",D)









