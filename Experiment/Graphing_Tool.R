rm(list = ls())
library(ggplot2)
library(dplyr)
library(stringr)
library(ggpubr)

TNumber = 20
PNumber = 10
PProb = 0.1

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
#Data = filter(Data, Test_Case_Number == TestCaseNumber)
#Data = filter(Data, Pass_Probability == Prob)
Data_Length = length(Data)-6
colnames(Data) <- c("Population_Id","SelectionSchemes","Test_Case_Number","Population_Size","Pass_Probability","Replicate_Id", 1:Data_Length)
Bottom_Value = (.9*PNumber)+7
Top_Value = PNumber+6
Data_Frame = data.frame(data = Data[,Bottom_Value:Top_Value])
Data["Specialist_Sums"] <- rowSums(Data_Frame,na.rm = F)

Test_Case_Names <- c( '10' = "10 Test Cases",
                      '20' = "20 Test Cases"
                      )
Pass_Prob_Names <- c( '0_01' = "1% Baseline Organism\nPass Rate",
                      '0_1' = "10% Baseline Organism\nPass Rate",
                      '0_5' = "50% Baseline Organism\nPass Rate",
                      '0_9' = "90% Baseline Organism\nPass Rate",
                      '1' = "100% Baseline Organism\nPass Rate"
                      )
Data$Selection_Schemes=0
Data[Data$SelectionSchemes == "lexicase",]$Selection_Schemes = "Lexicase"
Data[Data$SelectionSchemes == "tournament_7",]$Selection_Schemes = "Tournament (7)"
Data[Data$SelectionSchemes == "tournament_4",]$Selection_Schemes = "Tournament (4)"
Data[Data$SelectionSchemes == "tournament_2",]$Selection_Schemes = "Tournament (2)"
Data[Data$SelectionSchemes == "roulette",]$Selection_Schemes = "Roulette"
Data[Data$SelectionSchemes == "downsampled_0_5",]$Selection_Schemes = "Down-Sampled (0.5)"
Data[Data$SelectionSchemes == "downsampled_0_2",]$Selection_Schemes = "Down-Sampled (0.2)"
Data[Data$SelectionSchemes == "cohort_0_5",]$Selection_Schemes = "Cohort (0.5)"
Data[Data$SelectionSchemes == "cohort_0_2",]$Selection_Schemes = "Cohort (0.2)"

Lexicase_Var = filter(Data,Selection_Schemes == "Lexicase"|Selection_Schemes == "Cohort (0.2)"|Selection_Schemes == "Cohort (0.5)"|Selection_Schemes == "Down-Sampled (0.2)"|Selection_Schemes == "Down-Sampled (0.5)")

ggplot(data = Data, aes(x=Selection_Schemes,y=Specialist_Sums,color=Selection_Schemes))+
  stat_compare_means(data = Lexicase_Var,label.x = 2.5)+
  stat_compare_means(label="p.signif",method="wilcox.test",ref.group = "Lexicase",label.y = -.1,symnum.args = list(cutpoints = c(0, 0.001, 0.01, 0.05, 1), symbols = c("***", "**", "*", "ns")))+
  geom_hline(aes(yintercept=0))+
  geom_boxplot()+
  facet_grid(rows = vars(Test_Case_Number), cols = vars(Pass_Probability),labeller=labeller(Test_Case_Number = Test_Case_Names, Pass_Probability = Pass_Prob_Names))+
  labs(y = "Focal Specialist Selection Probability",title = paste("Probability a Focal Specialist Will be Selected \n","With a Population Size of",PopulationSize), x = "Selection Schemes")+
  theme(plot.title = element_text(hjust = 0.5))+
  scale_x_discrete()+
  scale_y_continuous(breaks = c(0,.25,.5,.75,1),limits = c(-.25,1.25))+
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+
  guides(color=guide_legend(title = "Selection Schemes"))+
  labs(tag = " *** - p<=0.001\n** - p<=0.01\n * - p<=0.05")+
  theme(plot.tag.position = c(0.92,.1),plot.tag = element_text(size = 10))+
  ggsave("Pop10_Specialist_Preservation.png",height = 5,width = 12,units = "in")