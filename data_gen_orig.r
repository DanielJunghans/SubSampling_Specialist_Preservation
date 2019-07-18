for(c in c(10,20)){
  TestCase_Count = c
  for(d in c(10,20,100)){
    PopulationSize = d
    for(e in c(.9,.5)){
      PassProbability = e
      for(u in 1:100){
        Generalists = .9*PopulationSize #number of individuals in a population
        Population = rep(0,Generalists)
        Data = data.frame(data = matrix(nrow = Generalists, ncol = 0))
        SData = data.frame(data = matrix(nrow = 1, ncol = TestCase_Count-1))
        Specialist = PopulationSize-Generalists
        PassFail_Calculation = function(Pass_Prob){
          if(rbinom(1,1,PassProbability) == 0){ #probability of passing if function
            return(0)
          }else{
            return(1)
          }
        }
        for(z in 1:(TestCase_Count-1)){
          for(x in 1:Generalists){
            Population[x] = PassFail_Calculation(PassProbability)
          }
          Data = cbind(Population,Data,deparse.level = 0)
        }
        Data["Focal"] <- rep(0,Generalists)
        for(B in 1:Specialist){
          SData = c(rep(0,TestCase_Count-1),1)
          Data = rbind(Data,SData)
        }
        Names = NULL
        for(G in 1:(TestCase_Count-1)){
          Names = c(Names,paste("Test_",G,sep=""))
        }
        Names = c(Names,"Focal")
        colnames(Data) = Names
        Data["Fitness"] <- rowSums(Data,na.rm = F,dims = 1L)
        Data <- Data[c('Fitness',Names)]
        write.csv(Data,file = paste("Population","",c,"",d,"",e,"",u,".csv",sep=""))
      }
    }
  }
}
