# R CODE FOR IMPORTING, MANIPULATING, AND ANALYZING THE DATASETS USED IN: 


library(tidyverse)
library(RColorBrewer)
# library(grid)
# library(gridExtra)
# library(RGraphics)
# library(rworldmap)
#library(raster)

# READ IN THE DATA FILES
officers<-read.csv("./data_raw/Officers.csv", dec=".", header = TRUE, sep = ",", na.strings=c("","NA"), check.names=FALSE)
officers_gender<-read.csv("./data_raw/officers_for_gender.csv", dec=".", header = TRUE, sep = ",", na.strings=c("","NA"), check.names=FALSE)
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


#################
# adds gender to officers
#################

officers<-left_join(officers,officers_gender,by=NULL)


#################
# filter the officers to include
#################

officers<-officers %>% filter(position=="President"|position=="Secretary"|position=="Executive Director"|position=="Editor"|position=="Councilor"|position=="Treasurer"|position=="Secretary-Treasurer")
summary(officers)

######################################################################
# PLOT: OFFICER GEOGRAPHY - by COUNTRY
######################################################################
# first need to make sure each officer is listed only one
officers_geo<-officers %>% select(position,first_name,last_name,country,geo.code,region) %>% distinct() %>% group_by(geo.code)
officers_geo<-na.omit(officers_geo)
str(officers_geo)
officers_geo<-officers_geo %>% arrange(geo.code,region) %>% count(geo.code,region) %>% arrange(desc(n))
officers_geo$perc<-officers_geo$n/sum(officers_geo$n)*100


# Now the plot


plot_officers<-ggplot(data=officers_geo, 
                      aes(x=reorder(geo.code,perc), y=perc, fill=reorder(region,perc)))

plot_officers<-plot_officers+
  ggtitle("Country in which ATBC Officers are based (1965-2019)") + 
  xlab("country") +
  ylab("percent of officers")+
  scale_fill_brewer(palette="Blues")

plot_officers<-plot_officers+geom_bar(stat="identity")
plot_officers + theme(legend.title = element_text( size=10, 
                                      face="bold"))
plot_officers<-plot_officers + theme_bw()
plot_officers<-plot_officers + coord_flip()

plot_officers<-plot_officers +theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
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
                      aes(x=reorder(region,perc), y=perc, fill=reorder(region,perc)))

plot_officers2<-plot_officers2+
  ggtitle("Region in which ATBC Officers are based (1963-2019") + 
  xlab("region") + 
  ylab("percent of officers")+
  scale_fill_brewer(palette="Blues")
plot_officers2<-plot_officers2+geom_bar(stat="identity")
plot_officers2
plot_officers2<-plot_officers2 + coord_flip()+theme_bw()
plot_officers2<-plot_officers2+  theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
                                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), 
                                     plot.title = element_text(hjust=0.05, vjust=-1.8, face="bold", size=22),        
                                     axis.title.x=element_text(colour="black", size = 18, vjust=-2),            
                                     axis.title.y=element_text(colour="black", size = 18, vjust=2),            
                                     axis.text=element_text(colour="black", size = 16),                              
                                     legend.position = "none")                                                      
plot_officers2








######################################################################
# PLOT: OFFICER GEOGRAPHY - by REGION BY POSITION
######################################################################
officers_region_position<-officers %>% select(position,last_name,country,geo.code,region) %>% distinct() %>% group_by(region)
officers_region_position<-na.omit(officers_region_position)
str(officers_region_position)
officers_region_position<-officers_region_position %>% group_by(position) %>% arrange(position,region) %>% count(region) %>% arrange(desc(n))
officers_region_position$perc<-officers_region_position$n/sum(officers_region_position$n)*100

# Now the plot

plot_officers3<-ggplot(data=officers_region_position, 
                       aes(x=reorder(region,perc), y=perc, fill=reorder(region,perc)))

plot_officers3<-plot_officers3+
  ggtitle("Region in which ATBC Officers are based (1963-2019)") + 
  xlab("region") + 
  ylab("percent of officers")+
  scale_fill_brewer(palette="Blues")
plot_officers3<-plot_officers3+geom_bar(stat="identity")
plot_officers3
plot_officers3<-plot_officers3 + coord_flip()+theme_bw()
plot_officers3<-plot_officers3 + facet_wrap(vars(position), nrow = 5)
plot_officers3<-plot_officers3+  theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
                                       panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), 
                                       plot.title = element_text(hjust=0.05, vjust=-1.8, face="bold", size=16),        
                                       axis.title.x=element_text(colour="black", size = 10, vjust=-2),            
                                       axis.title.y=element_text(colour="black", size = 10, vjust=2),            
                                       axis.text=element_text(colour="black", size = 10),                              
                                       legend.position = "none")                                                      
plot_officers3



#######################
# Officer Gender
#######################

officers_gender<-officers %>% select(position,last_name,country,geo.code,region,gender) %>% distinct() %>% group_by(gender)
officers_gender<-na.omit(officers_gender)
officers_gender<-officers_gender %>% count(gender) %>% arrange(desc(n))
officers_gender$perc<-officers_gender$n/sum(officers_gender$n)*100

# Now the plot

plot_officers4<-ggplot(data=officers_gender, 
                       aes(x=reorder(gender,perc), y=perc))

plot_officers4<-plot_officers4+
  ggtitle("ATBC Officers Gender (1963-2019") + 
  xlab("region") + 
  ylab("percent of officers")
plot_officers4<-plot_officers4+geom_bar(stat="identity")
plot_officers4<-plot_officers4 + theme_bw()
plot_officers4<-plot_officers4+  theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
                                       panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), 
                                       plot.title = element_text(hjust=0.05, vjust=-1.8, face="bold", size=22),        
                                       axis.title.x=element_text(colour="black", size = 18, vjust=-2),            
                                       axis.title.y=element_text(colour="black", size = 18, vjust=2),            
                                       axis.text=element_text(colour="black", size = 16),                              
                                       legend.position = "none")                                                      
plot_officers4









######################################################################
# PLOT: FELLOWS GEOGRAPHY - by REGION
######################################################################
fellows_region<-fellows %>% select(last_name,country,geo.code,region,gender) %>% distinct() %>% group_by(region)
fellows_region<-na.omit(fellows_region)
str(fellows_region)
fellows_region<-fellows_region %>% arrange(region) %>% count(region,gender) %>% arrange(desc(n))
fellows_region$perc<-fellows_region$n/sum(fellows_region$n)*100

# Now the plot

plot_fellows2<-ggplot(data=fellows_region, 
                       aes(x=reorder(region,perc), y=perc, fill=reorder(gender,perc)))

plot_fellows2<-plot_fellows2+
  ggtitle("Region in which ATBC Fellows are based (1963-2019") + 
  xlab("region") + 
  ylab("percent of fellows")+
  scale_fill_brewer(palette="Blues")
plot_fellows2<-plot_fellows2+geom_bar(stat="identity")
plot_fellows2
plot_fellows2<-plot_fellows2 + coord_flip()+theme_bw()
plot_fellows2<-plot_fellows2+  theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
                                       panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), 
                                       plot.title = element_text(hjust=0.05, vjust=-1.8, face="bold", size=22),        
                                       axis.title.x=element_text(colour="black", size = 18, vjust=-2),            
                                       axis.title.y=element_text(colour="black", size = 18, vjust=2),            
                                       axis.text=element_text(colour="black", size = 16),                              
                                       legend.position = "right")                                                      
plot_fellows2

####################
# OR ALTERNATIVELY
####################
fellows_gender<-fellows %>% select(last_name,country,geo.code,region,gender) %>% distinct() %>% group_by(gender)
fellows_gender<-fellows_gender %>% count(gender) %>% arrange(desc(n))
fellows_gender$perc<-fellows_gender$n/sum(fellows_gender$n)*100

plot_fellows_gender<-ggplot(data=fellows_gender, 
                      aes(x=reorder(gender,perc), y=perc))

plot_fellows_gender<-plot_fellows_gender+
  ggtitle("ATBC Fellows by Gender (1963-2019") + 
  xlab("gender") + 
  ylab("percent of fellows")
plot_fellows_gender<-plot_fellows_gender+geom_bar(stat="identity")
plot_fellows_gender
plot_fellows_gender<-plot_fellows_gender +theme_bw()
plot_fellows_gender<-plot_fellows_gender+  theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
                                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), 
                                     plot.title = element_text(hjust=0.05, vjust=-1.8, face="bold", size=22),        
                                     axis.title.x=element_text(colour="black", size = 18, vjust=-2),            
                                     axis.title.y=element_text(colour="black", size = 18, vjust=2),            
                                     axis.text=element_text(colour="black", size = 16),                              
                                     legend.position = "right")                                                      
plot_fellows_gender






