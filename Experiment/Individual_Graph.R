rm(list = ls())
library(ggplot2)
library(ggbeeswarm)
FolderName="Cohort_DS_Experiment"
SecondFolder="Cohort"
A="Pop18CO"

#data set 1
Population = readLines(paste("C:/Users/Daniel/Documents/Beacon Projects/",FolderName,"/",SecondFolder,"/",A,".csv", sep = ""))
Split_Pop = strsplit(Population,",")
Pop_Vector = as.vector(Split_Pop[[1]])
Numeric_Pop = as.numeric(Pop_Vector)
NP = Numeric_Pop
Popsize = length(NP)
Population_ID = c(1:Popsize)
Data = data.frame(data = matrix(nrow = Popsize, ncol = 0))
Data = cbind(NP,Data)
Data = cbind(Population_ID,Data)
Genlist = .9*Popsize
Data= cbind(Type = c(rep("Generalist",Genlist),rep("Specialist",Popsize-Genlist)),Data)
#Graph #1
ggplot(data = Data,mapping= aes(x=Type,y=NP))+
geom_beeswarm()+
labs(y = "Selection Probability",title = "Cohort Lexicase 50% \nN=20 Prob=.01", x = "Population Rank", colour = "Population \nSize")+
theme(plot.title = element_text(hjust = 0.5))+
theme_bw()
#ggsave(paste("Line_","CohortLexicase18.png",sep=""), width = 5, height = 5, units = "in")
