library(dplyr)
FolderName="Experiment"
SecondFolder="Selection_Probs1Dataset"
Data = data.frame(data = matrix(nrow = 0, ncol = 0))
ALL_CSV = read.csv("C:/Users/Daniel/Documents/Beacon_Projects/Experiment/Selection_Probs1Dataset/Selection_Probabilities_1Dataset.csv")
for(Selection in c("cohort_0_2","cohort_0_5","downsampled_0_2","downsampled_0_5", "lexicase", "roulette","tournament_2", "tournament_4", "tournament_7")){
  Selection_Scheme = Selection
  Filtered_Selection = filter(ALL_CSV,Selection_Scheme == Selection)
  for(c in c("10","20")){
    Test_Case_Number = c
    Filtered_Testcase = filter(Filtered_Selection, Test_Case_Number== c)
    for(d in c("10","20","100")){
      Population_Size = d
      Filtered_Population = filter(Filtered_Testcase, Population_Size== d)
      for(e in c("1","0_1","0_01")){
        Pass_Probability = e
        Filtered_PassProb = filter(Filtered_Population, Pass_Probability== e)
        Titles = c(Selection_Scheme, Test_Case_Number, Population_Size, Pass_Probability)
        REPNA = rep(NA,100-as.numeric(Population_Size))
        Data_Average = c(Titles, rep(NA,100))
        for(Average in 7:106){
          Data_Average[Average-2] =  mean(Filtered_PassProb[,Average])
        }
        Data = rbind(stringsAsFactors=F, Data_Average,Data)
      }
    }
  }
}

colnames(Data) <- c("Selection_Scheme", "Test_Case_Number", "Population_Size", "Pass_Probability",1:100)
write.csv(Data,file = "AverageDataSets.csv")