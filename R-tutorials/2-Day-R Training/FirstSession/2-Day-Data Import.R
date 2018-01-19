
#Different methods of importing data into R

#import packages
#library(readxl) 

#readxl - to read from excel
#data.table - for big data related operation
#foreign - sas and spss file reading
#sas7bdat - sas related new file formate and process
#RCurl - for online data download and process
#XML - to process xml
#dplyr - for data cleanising and manipulate
#iotools - to read length of specific veriables

#head() and tail() to read downloaded file in R in short
#Str() to check the structure of file


#---------------------------------------------------------------------------------------
#To remove the existing variables from Global Environment
#---------------------------------------------------------------------------------------

rm(list=ls())

#---------------------------------------------------------------------------------------
#Setting work directory
#---------------------------------------------------------------------------------------

setwd("C:\\Users\\SHeruwala\\Machine Learning\\R-tutorials\\2-Day-R Training\\FirstSession")

#----------------------------------------------------------------------------------------
#Using scan function
#Scan function reads the data in list data structures
#----------------------------------------------------------------------------------------

#parameter 
#skip=1 if you want to skip first line as header
#what = " " by default scan reads numerical values , to read character we need to specify those veriables in "what"
#scan returns in list

customers=scan("customers.csv",sep=",")
customers


#Introducing "what" parameter to denote the character variable

customers=scan("customers.csv",
               what="",
               sep=",",
               skip=1)

class(customers)

#Using list option to store output as list

customers=scan("customers.csv",
               what=list(first_name="",last_name="",city="",country="",state="",zip=0),
               sep=",",
               skip=1)

#Checking class of customers

class(customers)


#Excluding certain columns by using NULL

customers1=scan("customers.csv",
               what=list(first_name="",last_name=NULL,city="",country="",state="",zip=0),
               sep=",",
               skip=1)

#Tab delimited file

customers_t=scan("customers.txt",
                what=list(first_name="",last_name="",city="",country="",state="",zip=0),
                sep="\t",
                skip=1)
?scan
#----------------------------------------------------------------------------------------
# Using read.table function
#read.table function reads data in data.frame format
#----------------------------------------------------------------------------------------

#StringAsFactors = False, if you dont want to assign dummy numerical values to categorial / characters
#Reading tab delimiter file

customers=read.table("customers.txt",
               header=TRUE,
               sep="\t")

#Checking the class of customers
class(customers)



#Reading csv file

#Reading tab delimiter file

customers=read.table("customers.csv",
                     header=TRUE,
                     sep=",")

#Checking the class of customers
class(customers)

#Introducing dim  and str function

dim(customers)

str(customers)

#Using different file path other than directory
customers=read.table("C:/Users/Mohanaganapathy.K/Desktop/2-R Training/customers.csv",
                     header=TRUE,
                     sep=",")

#Keeping  string variables as-is without converting them to the factors

customers=read.table("C:/Users/Mohanaganapathy.K/Desktop/2-R Training/customers.csv",
                     header=TRUE,
                     sep=",",
                     stringsAsFactors = FALSE)

#Checking the variable types
str(customers)

#Declaring variable types seperately using colclasses parameter

vartypes=c(first_name="character",lastname="character",city="character",country="character",
           state="character",zip="numeric")



customers_new=read.table("customers.csv",
                     header=T,
                     sep=",",
                     skip=1,
                     col.names = names(vartypes),
                     colClasses = vartypes)

class(customers_new)

str(customers_new)

#What happens when we give a long declaration
vartypes=c(first_name="numeric",lastname="character",city="character",country="character",
           state="character",zip="numeric")

customers_new=read.table("customers.csv",
                         header=T,
                         sep=",",
                         skip=0,
                         col.names = names(vartypes),
                         colClasses = vartypes)

class(customers_new)


#Introducing head and tail function

head(customers_new)


tail(customers_new)

#--------------------------------------------------------------------------------------
#using read.delim function - Specially developed for tab delimited files
#read.delim function also saves data in data.frame structure
#read.delim2 function is country specific (dec",",sep=";")
#as.is=T to convert stringAsFactor false
#--------------------------------------------------------------------------------------
#Advantage - to consider comma as dot and dot as comma then use delim2 

customers=read.delim("customers.txt",
                     header=TRUE,
                     as.is=T)

customers

str(customers)

#--------------------------------------------------------------------------------------
#using read.csv2 function - Specially developed for comma seperated files
#read.delim function also saves data in data.frame structure
#read.delim2 function is country specific (dec",",sep=";")
#--------------------------------------------------------------------------------------

customers=read.csv("customers.csv",
                     header=TRUE,
                     as.is=T)

customers

#-------------------------------------------------------------------------------------
#Using read_excel function
#-------------------------------------------------------------------------------------
#install.packages("readxl")

library("readxl")

my_data = read_excel("Dummy.xlsx",sheet=1)

#--------------------------------------------------------------------------------------
#using ReadLines functions
#Reads entire line as a single character.It saves data as character variable
#It is use ful when we deals with completely text data
#--------------------------------------------------------------------------------------

customers=readLines("customers.csv")
         
customers


#------------------------------------------------------------------------------------
#Dealing with missing vlaues
#Note : in numerical cell if cell is empty then it will by default assign NA, 
#but for categorial values we have to define something for empty like -/null/nil/?
#------------------------------------------------------------------------------------

missing=read.csv("missing.csv",
                   header=TRUE,
                   as.is=T)

class(missing)
str(missing)

#We are hard-coding the missing infos (?,-,"") in character variables with NA
missing_hardcoded=read.csv("missing.csv",
                 header=TRUE,
                 as.is=T,
                 na.strings = c("","NA","-","?","NULL"))


#------------------------------------------------------------------------------------
#Using Specific parameters to read the unstructured data
#------------------------------------------------------------------------------------
#comment.char to consider # values in read

Tweets=read.table("Tweets.txt",
                     header=F,
                     sep="\n",
                     comment.char="")


#-------------------------------------------------------------------------------------
#How to export the data from R
#-------------------------------------------------------------------------------------

#Loading the customer data

#csv File
customers=read.csv("customers.csv",
                   header=TRUE,
                   as.is=T)


#Text File

customers=read.table("customers.txt",
                     header=TRUE,
                     sep="\t")


#Exporting the loaded customer data from R to csv

write.table(customers,"customers_Exported.csv",sep=",")

#To supress row.names output

write.table(customers,"customers_Exported.csv",sep=",",row.names=F)

#Exporting the loaded customer data from R to text

write.table(customers,"customers_Exported.txt",sep="\t",row.names=F)


#Write.csv
write.csv(customers,"customers_Exported.csv",row.names=F)


#--------------------------------------------------------------------------------------
#To read big data files
#--------------------------------------------------------------------------------------

# To use fread function, first we have to install a package called data.table
#use any other big data file

install.packages("data.table")

library(data.table)
library(stats)

#To Evaluate The run time of the code

customer <-fread("Mast_Comp.csv",header=TRUE,sep=",")

Sys.time()->start;
customers=read.csv("Mast_Comp.csv",header=TRUE,sep=",");
print(Sys.time()-start);

Sys.time()->start;
customers=fread("Mast_Comp.csv",header=TRUE,sep=",");
print(Sys.time()-start);

#----------------------------------------------------------------------------------------
#Importing data into R from statistical softwares like SAS and SPSS
#----------------------------------------------------------------------------------------

#To read SPSS file

#package required

library(foreign)

#If we don't use to.data.frame parameter, R will import the save file in list format and not in data.frame format
#by default it read as list to convert in dataframe we use to.data.frame

spss=read.spss("customers.sav",to.data.frame=TRUE)


#To read SAS file (with .sas7bdat extension)

#package required

library(sas7bdat)

sas=read.sas7bdat("customers.sas7bdat")




#------------------------------------------------------------------------------------------

#To read a tab " " delimited file directly from the web page

#------------------------------------------------------------------------------------------

plants=read.table("http://www.bio.ic.ac.uk/research/mjcraw/therbook/data/taxon.txt",  sep="\t",header=T,stringsAsFactors=F)

plants




#----------------------------------------------------------------------------------------

#To read a semi structured data from web page directly

#To read a ebook from this site :http://www.gutenberg.org/cache/epub/2701/pg2701.txt

#---------------------------------------------------------------------------------------

data= url("http://www.gutenberg.org/cache/epub/2701/pg2701.txt")

ebook=readLines(data,n=200)

#----------------------------------------------------------------------------------------#

#To find the biggest contributor from archives

#This site consists of January 2009 R help Archieves sorted by date: https://stat.ethz.ch/pipermail/r-help/2009-January/date.html

#The goal is to extract authors info and identify the biggest contributors

#----------------------------------------------------------------------------------------

#Required Packages:

library(RCurl)
library(XML)

#Getting the html content from URL

htmlContent=getURL("https://stat.ethz.ch/pipermail/r-help/2009-January/date.html",ssl.verifypeer=FALSE)


#Parsing the html tree structure from html content

htmlparsed=htmlTreeParse(htmlContent,useInternal=TRUE)


authorsOutput=unlist(xpathApply(htmlparsed,'//i',xmlValue))

authorsOutput=gsub("\n",' ',authorsOutput)

#Converting the output to data frame object

output=data.frame(table(authorsOutput))

output=output[order(-output$Freq),]

#-------------------------------------------------------------------------------------------------------
#Fixed length
#-------------------------------------------------------------------------------------------------------

library(iotools)
iotools = input.file("samplefile.txt", formatter = dstrfw, 
                     col_types = rep("character",70), 
                     widths = c(7L,7L,4L,9L,15L,8L,8L,8L,2L,11L,28L,11L,28L,1L,7L,3L,6L,6L,6L,6L,6L,6L,6L,1L,1L,6L,1L,2L,6L,15L,2L,9L,2L,15L,6L,2L,2L,1L,15L,10L,1L,9L,15L,2L,10L,15L,2L,5L,10L,10L,4L,2L,1L,5L,2L,11L,1L,1L,1L,1L,1L,10L,1L,2L,10L,8L,1L,10L,2L,1L))

