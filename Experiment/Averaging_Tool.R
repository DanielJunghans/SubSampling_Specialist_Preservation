FolderName="Experiment"
SecondFolder="Experiment_Selection_Probs"
Data = data.frame(data = matrix(nrow = 0, ncol = 0)) #as.numeric(Population_Size))
for(Selection in c("cohort_0_2","cohort_0_5","downsampled_0_2","downsampled_0_5", "lexicase", "roulette","tournament_2", "tournament_4", "tournament_7")){
  Selection_Scheme = Selection
  for(c in c("10","20")){
    Test_Case_Number = c
    for(d in c("10","20","100")){
      Population_Size = d
      for(e in c("1","0_9","0_5","0_1","0_01")){
        Pass_Probability = e
        for(u in 1:100){
          Titles = c(Selection_Scheme, Test_Case_Number, Population_Size, Pass_Probability, u)
          CSV =  as.numeric(read.csv(header=F,paste("C:/Users/Daniel/Documents/Beacon_Projects/",FolderName,"/",SecondFolder,"/",Selection_Scheme,"__",Test_Case_Number,"__",Population_Size,"__",Pass_Probability,"__",u,".csv", sep = "")))
          REPNA = rep(NA,100-as.numeric(Population_Size))
          Data = rbind(stringsAsFactors=F,c(Titles,CSV,REPNA),Data)
        }
      }
    }
  }
}
colnames(Data) <- c("Selection_Scheme", "Test_Case_Number", "Population_Size", "Pass_Probability", "Replicate_ID",1:100)
write.csv(Data,file = "Selection_Probabilities_1Dataset.csv")