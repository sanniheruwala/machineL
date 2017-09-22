#------------------------------------------------------------------------
# Reading the iris data set
#------------------------------------------------------------------------

library(datasets)

data()

iris

id=iris

#-----------------------------------------------------------------------
#Using dplyr() package
#-----------------------------------------------------------------------

library(dplyr)


group_by(id, Species) %>% slice(n()-1) #To select the last but one occurance

group_by(id, Species) %>% slice(1) # To select the first occurance

#----------------------------------------------------------------------
#To select all the rows in a dataframe except last row
#---------------------------------------------------------------------

Id2=iris

ID3=head(Id2,-1) # to remove last line/row from dataset

#-----------------------------------------------------------------------

#An Introduction to R Notebook