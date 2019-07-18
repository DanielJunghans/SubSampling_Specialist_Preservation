rm(list=ls())
ONLY_ONE = T
for(num_tests in c(10,20)){
  for(pop_size in c(10,20,100)){
    for(pass_prob in c(0.9, 0.5, 0.1, 0.01, 1)){
      for(rep_id in 1:100){
        num_non_focal_orgs = pop_size * 0.9
        if(ONLY_ONE){
          num_non_focal_orgs = pop_size - 1
        }
        tmp_vec = rep(0, num_non_focal_orgs)
        data = data.frame(data = matrix(nrow = 0, ncol = num_tests + 1))
        num_focal_orgs = pop_size - num_non_focal_orgs
        for(non_focal_id in 1:num_non_focal_orgs){
          for(test_id in num_tests - 1){ # Do not account for focal test case
            tmp_vec = sample(c(0,1), prob = c(1- pass_prob, pass_prob), size = num_tests - 1, replace = T)
          }
          data = rbind(data, c(0, tmp_vec, 0)) # Don't forget the 0 for fitness and focal case!
        }
        for(focal_id in 1:num_focal_orgs){
          tmp_vec = c(0, rep(0, num_tests - 1), 1) # Fitness, non-focal cases, focal case
          data = rbind(data, tmp_vec)
        }
        Names = NULL
        col_names = c('Fitness', paste('Test_',1:(num_tests-1)), 'Focal')
        colnames(data) = col_names
        data$Fitness <- rowSums(data,na.rm = F,dims = 1L)
        if(ONLY_ONE){
          write.csv(data, file = paste("Population_Single_", num_tests, "_", pop_size, "_", pass_prob, "_", rep_id,".csv",sep=""))
        }
        else{
          write.csv(data, file = paste("Population_", num_tests, "_", pop_size, "_", pass_prob, "_", rep_id,".csv",sep=""))
        }
      }
    }
  }
}
