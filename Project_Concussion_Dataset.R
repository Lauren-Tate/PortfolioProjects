class(Concussion_Injuries_2012_2014)
#Install libraries to use of dataset
library("ggplot2")
library("broom")
library("knitr")
library("tidyr")
library("dplyr")
library("tidyverse")
library("lubridate")
#Change the dataset into a data frame
ConcussionInjuries<- as.data.frame(Concussion_Injuries_2012_2014)
View(ConcussionInjuries)
class(ConcussionInjuries)
#Exploratory analysis of dataset
summary(ConcussionInjuries)
#Split the key variables being looked at
Team = ConcussionInjuries[,c("Team")]
InjuryType = ConcussionInjuries[,c("Reported_Injury_Type")]
Season = ConcussionInjuries[,c("Season")]
Position = ConcussionInjuries[,c("Position")]
#Create a frequency table for variables injury type and team
table_data <- table(ConcussionInjuries$Team,ConcussionInjuries$Reported_Injury_Type)
table_data_injury_team <- as.data.frame(table_data) 
ggplot(table_data_injury_team, aes(x = Var1, y = Freq, fill = Var2)) +
    geom_bar(stat = "identity") +
    labs(
      title = "Injury Types per Team",
      x = "Team",
      y = "Count"
    ) +
    scale_fill_manual(values = c("Head" = "blue", "Concussion" = "red", "Illness" = "green")) +  # Custom color palette
    theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
#Create a frequency table for variables injury type and season they occurred
  table(ConcussionInjuries$Season,ConcussionInjuries$Reported_Injury_Type)
  table_data <- table(ConcussionInjuries$Season,ConcussionInjuries$Reported_Injury_Type)
  table_data_season <- as.data.frame(table_data)  
  ggplot(table_data_season, aes(x = Var1, y = Freq, fill = Var2)) +
    geom_bar(stat = "identity") +
    labs(
      title = "Injury Types per Season",
      x = "Season",
      y = "Count"
    ) +
    scale_fill_manual(values = c("Head" = "blue", "Concussion" = "red", "Illness" = "green")) +  # Custom color palette
    theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
#Create a frequency table for variables team and season injuries occurred         
  table(ConcussionInjuries$Team,ConcussionInjuries$Season)
  table_data <- table(ConcussionInjuries$Team,ConcussionInjuries$Season)
  table_data_teamseason <- as.data.frame(table_data)
  ggplot(table_data_teamseason, aes(x = Var1, y = Freq, fill = Var2)) +
    geom_bar(stat = "identity") +
    labs(
      title = "Team Injuries per Season",
      x = "Team",
      y = "Count"
    ) +
    scale_fill_manual(values = c("2012/2013" = "blue", "2013/2014" = "red", "2014/2015" = "green")) +  # Custom color palette
    theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
#Create a frequency table for variables injury type and position 
  table(ConcussionInjuries$Position,ConcussionInjuries$Reported_Injury_Type)
  table_data <- table(ConcussionInjuries$Position,ConcussionInjuries$Reported_Injury_Type)
  table_data_positioninjuries <- as.data.frame(table_data)
  ggplot(table_data_positioninjuries, aes(x = Var1, y = Freq, fill = Var2)) +
    geom_bar(stat = "identity") +
    labs(
      title = "Injury Type per Position",
      x = "Position",
      y = "Count"
    ) +
    scale_fill_manual(values = c("Head" = "blue", "Concussion" = "red", "Illness" = "green")) +  # Custom color palette
    theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
#Create a frequency table for variables positon and season injuries occurred  
  table(ConcussionInjuries$Position,ConcussionInjuries$Season)
  table_data <- table(ConcussionInjuries$Position,ConcussionInjuries$Season)
  table_data_positionseason <- as.data.frame(table_data)
  ggplot(table_data_positionseason, aes(x = Var1, y = Freq, fill = Var2)) +
    geom_bar(stat = "identity") +
    labs(
      title = "Positional Injuries per Season",
      x = "Position",
      y = "Count"
    ) +
    scale_fill_manual(values = c("2012/2013" = "blue", "2013/2014" = "red", "2014/2015" = "green")) +  # Custom color palette
    theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))