rm(list = ls())
library(ggplot2)
library(ggbeeswarm)
library(dplyr)
library(stringr)

TNumber = 10
PNumber = 10
PProb = .1

TestCaseNumber = as.character(TNumber)
PopulationSize = as.character(PNumber)
PassProbability = as.character(PProb)
Prob = str_replace(PassProbability,"\\.","_")
FolderName="Experiment"
SecondFolder="Selection_Probs1Dataset"
Data_Set="Selection_Probabilities_1Dataset"
Data = data.frame(data = matrix(ncol = 0,nrow = 0))
Data = read.csv(paste("C:/Users/Daniel/Documents/Beacon_Projects/",FolderName,"/",SecondFolder,"/",Data_Set,".csv", sep = ""))
Data = filter(Data, Population_Size == PopulationSize)
Data = filter(Data, Test_Case_Number == TestCaseNumber)
Data = filter(Data, Pass_Probability == Prob)
Data_Length = length(Data)-6
colnames(Data) <- c("Population_Id","SelectionSchemes","Test_Case_Number","Population_Size","Pass_Probability","Replicate_Id", 1:Data_Length)
Bottom_Value = (.9*PNumber)+7
Top_Value = PNumber+6
Data_Frame = data.frame(data = Data[,Bottom_Value:Top_Value])
Data["Specialist_Sums"] <- rowSums(Data_Frame,na.rm = F)

Selection_Vector = dplyr::pull(Data, Specialist_Sums)
Tournament_Seven <- Selection_Vector[1:100]
Tournament_Four <- Selection_Vector[101:200]
Tournament_Two <- Selection_Vector[201:300]
Roulette <- Selection_Vector[301:400]
Lexicase <- Selection_Vector[401:500]
Down_Sampled_50 <- Selection_Vector[501:600]
Down_Sampled_20 <- Selection_Vector[601:700]
Cohort_50 <- Selection_Vector[701:800]
Cohort_20 <- Selection_Vector[801:900]

kruskal.test(list(Lexicase, Down_Sampled_20, Down_Sampled_50))