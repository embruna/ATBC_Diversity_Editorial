# R CODE FOR IMPORTING, MANIPULATING, AND ANALYZING THE DATASETS USED IN: 


library(tidyverse)
#library(RColorBrewer)
# library(grid)
# library(gridExtra)
# library(RGraphics)
# library(rworldmap)
#library(raster)

# READ IN THE DATA FILES
officers<-read.csv("./data_raw/Officers.csv", dec=".", header = TRUE, sep = ",", na.strings=c("","NA"), check.names=FALSE)
awards<-read.csv("./data_raw/Awards.csv", dec=".", header = TRUE, sep = ",", na.strings=c("","NA"), check.names=FALSE)
fellows<-read.csv("./data_raw/Fellows.csv", dec=".", header = TRUE, sep = ",", na.strings=c("","NA"), check.names=FALSE)

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

# adds the iso3 code for country
source("Country.Codes.R")
officers<-Country.Codes(officers)
fellows<-Country.Codes(fellows)
awards<-Country.Codes(awards)
# Adds the world bank region and income category
source("AddIncomeRegion.R")
officers<-AddIncomeRegion(officers)
officers<-officers %>% rename("region"="REGION")
fellows<-AddIncomeRegion(fellows)
fellows<-fellows %>% rename("region"="REGION")
awards<-AddIncomeRegion(awards)
awards<-awards %>% rename("region"="REGION")


######################################################################
# PLOT: OFFICER GEOGRAPHY - by COUNTRY
######################################################################
# first need to make sure each officer is listed only one
officers_geo<-officers %>% select(position,last_name,country,geo.code,region) %>% distinct() %>% group_by(geo.code)
officers_geo<-na.omit(officers_geo)
str(officers_geo)
officers_geo<-officers_geo %>% arrange(geo.code,region) %>% count(geo.code,region) %>% arrange(desc(n))
officers_geo$perc<-officers_geo$n/sum(officers_geo$n)*100
# Now the plot
plot_officers<-ggplot(data=officers_geo, 
                      aes(x=reorder(geo.code,-perc), y=perc, color=region, fill=region))

plot_officers<-plot_officers+ggtitle("PLOT TITLE") + xlab("country") + ylab("percent of officers")                      
plot_officers<-plot_officers+geom_bar(stat="identity")
plot_officers
plot_officers<-plot_officers + coord_flip()+theme_bw()
plot_officers<-plot_officers+  theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
             panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), 
             plot.title = element_text(hjust=0.05, vjust=-1.8, face="bold", size=22),        
             axis.title.x=element_text(colour="black", size = 18, vjust=-2),            
             axis.title.y=element_text(colour="black", size = 18, vjust=2),            
             axis.text=element_text(colour="black", size = 16),                              
             legend.position = "right")                                                      
plot_officers

######################################################################
# PLOT: OFFICER GEOGRAPHY - by REGION
######################################################################
officers_region<-officers %>% select(position,last_name,country,geo.code,region) %>% distinct() %>% group_by(region)
officers_region<-na.omit(officers_region)
str(officers_region)
officers_region<-officers_region %>% arrange(region) %>% count(region) %>% arrange(desc(n))
officers_region$perc<-officers_region$n/sum(officers_region$n)*100

# Now the plot
plot_officers2<-ggplot(data=officers_region, 
                      aes(x=reorder(region,-perc), y=perc, color=region, fill=region))

plot_officers2<-plot_officers2+ggtitle("PLOT TITLE") + xlab("region") + ylab("percent of officers")                      
plot_officers2<-plot_officers2+geom_bar(stat="identity")
plot_officers2
plot_officers2<-plot_officers2 + coord_flip()+theme_bw()
plot_officers2<-plot_officers2+  theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
                                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), 
                                     plot.title = element_text(hjust=0.05, vjust=-1.8, face="bold", size=22),        
                                     axis.title.x=element_text(colour="black", size = 18, vjust=-2),            
                                     axis.title.y=element_text(colour="black", size = 18, vjust=2),            
                                     axis.text=element_text(colour="black", size = 16),                              
                                     legend.position = "right")                                                      
plot_officers2

