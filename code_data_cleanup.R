# R CODE FOR IMPORTING, MANIPULATING, AND ANALYZING THE DATASETS USED IN: 


library(tidyverse)
#library(RColorBrewer)
# library(grid)
# library(gridExtra)
# library(RGraphics)
# library(rworldmap)
#library(raster)

# READ IN THE DATA FILES
officers<-read.csv("./data_raw/Officers.csv", dec=".", header = TRUE, sep = ",", na.strings=NA, check.names=FALSE)
awards<-read.csv("./data_raw/Awards.csv", dec=".", header = TRUE, sep = ",", na.strings=NA, check.names=FALSE)
fellows<-read.csv("./data_raw/Fellows.csv", dec=".", header = TRUE, sep = ",", na.strings=NA, check.names=FALSE)

# CLEAN-UP THE DATA

# trim any leading or following white spaces
fellows$first_name<-trimws(fellows$first_name)
fellows$last_name<-trimws(fellows$last_name)
fellows$country<-trimws(fellows$country)

awards$first_name<-trimws(awards$first_name)
awards$last_name<-trimws(awards$last_name)
awards$country<-trimws(awards$country)

officers$first_name<-trimws(officers$first_name)
officers$last_name<-trimws(officers$last_name)
officers$country<-trimws(officers$country)


# Change data types
# Country
fellows$country<-as.factor(fellows$country)
awards$country<-as.factor(awards$country)
officers$country<-as.factor(officers$country)
# Last name
awards$last_name<-as.factor(awards$last_name)
officers$last_name<-as.factor(officers$last_name)
fellows$last_name<-as.factor(fellows$last_name)
# First name
awards$first_name<-as.factor(awards$first_name)
officers$first_name<-as.factor(officers$first_name)
fellows$first_name<-as.factor(fellows$first_name)

str(officers)