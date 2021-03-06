################################################################################
#permTestBR.R: permTesBR(A,B,NUM=999,stat="ks.test")
#  
#Description: performs permutation test for various statistics using the 
#             boot function to perform permutations. 
#                
#Input: A - First sample (either matrix or vector)
#       B - Second sample (dimensions must match A)
#       NUM - number of permutations to tes 
#       stat - statistic to use
#
#Output: An array containing the result of the statistic for each permutation 
#        S[1] - the first value in the array - is the value before any permuting
################################################################################

#main function - quit using boot since it was too slow
permTestBR <- function(A,B,num=999,stat,...){
  N=c(NROW(A),NROW(B))
  if(NCOL(A)!=NCOL(B)){stop("Dimensions do not match")}
  numRows<-1:sum(N)
  maxRows<-max(N)
  S<-numeric(num+1)
  z<-rbind(as.matrix(A),as.matrix(B))
  hold<-stat(A,B,...)
  S[1]<-hold$statistic
#   
#    cl<-makeCluster(7) #change the 2 to your number of CPU cores
#    registerDoSNOW(cl)
   
 #temp<-foreach(i = 2:num+1,.export=c("get.knn", "kernelStat")) %dopar% {
    # library("FNN")
  for(i in 2:num+1){
    k<-sample(numRows,maxRows,replace=F)
    x<-z[k,]
    y<-z[-k,]
    hold<-stat(x,y,...)
    S[i]<-hold$statistic
  }
  #stopCluster(cl)
  return(S)
}
  
