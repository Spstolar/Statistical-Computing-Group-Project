#Check for packages.  If not installed, install it.
check<-library("FNN",logical.return=T,quietly=T,verbose=F)
if(check=="FALSE"){
  install.packages("FNN")
  library("FNN")
}
library("Hotelling")
check<-library("Hotelling",logical.return=T,quietly=T,verbose=F)
if(check=="FALSE"){
  install.packages("Hotelling")
  library("Hotelling")
}
check<-library("boot",logical.return=T,quietly=T,verbose=F)
if(check=="FALSE"){
  install.packages("boot")
  library("boot")
}
check<-library("ggplot2",logical.return=T,quietly=T,verbose=F)
if(check=="FALSE"){
  install.packages("ggplot2")
  library("ggplot2")
}

################################################################################
#Function: simpleStat(x,y)
#  
#Description: Computes nearest neighbor statiistic 
#                
#Input: x - First sample (either matrix or vector)
#       y - Second sample (dimensions must match A)
#       
#
#Output: data frame, with the value of the statistics in $statistic
################################################################################
simpleStat <- function(x,y){
  statistic<-mean((x-y)^2)
  return(as.data.frame(statistic))
}

################################################################################
#Function: nNeighbor(x,y,k)
#  
#Description: Computes nearest neighbor statiistic 
#                
#Input: x - First sample (either matrix or vector)
#       y - Second sample (dimensions must match A)
#       k - how many neighbors: 1 = closes,2 = 1st and second closest, 3= ... 
#       
#Output: data frame, with the value of the statistics in $statistic
################################################################################
nNeighbor <- function(x,y,k=3) {
  n1 <- NROW(x)
  n2 <- NROW(y)
  n <- n1 + n2
  #if(NCOL(x)==1){
  #  z<-c(x,y)
  #  z<-cbind(z,0)
 # }else{
  #  z <- rbind(x, y)
 # }
  z <- rbind(as.matrix(x),as.matrix(y))
  NN <- get.knn(z, k=3)
  block1 <- NN$nn.index[1:n1, ]
  block2 <- NN$nn.index[(n1+1):n, ]
  i1 <- sum(block1 < n1 + .5)
  i2 <- sum(block2 > n1 + .5)
  statistic<-(i1 + i2) / (k * n)
  return(as.data.frame(statistic))
}

################################################################################
#Function: OLD rbkf
#  
#Description: Computes the MMD statistic using the radal bias kernal function
#                
#Input: x - First sample (either matrix or vector)
#       y - Second sample (dimensions must match A)
#       
#Output: data frame, with the value of the statistics in $statistic
################################################################################

#compute a matrix of RBF kernels
# rbfk <- function(x,y,sigma=1,m,n){
# 
#   x<-as.matrix(x)
#   y<-as.matrix(y)
#   #the array of inner products on the x vectors
#   xInner = apply(x, 1, function(x) x %*% x);
#   
#   #repeat the array to get an mxn matrix whose columns are xInner
#   xInnerM = replicate(n,xInner);
#   
#   #the matrix of inner products on the y vectors
#   yInner = apply(y, 1, function(y) y %*% y);
#   
#   #repeat the array to get an mxn matrix whose rows are yInner
#   yInnerM = t(replicate(m,yInner));
#   
#   #get the mxn matrix whose (i,j) entry is <x_i, y_j>
#   #there's got to be a better way this but...
#   
#   xyInnerM = matrix(data=0, nrow=m, ncol=n);
#   for(column in 1:n){
#     xyInnerM[,column] <- x%*%y[column,]
#   }
#   
#   H = xInnerM + yInnerM - 2*xyInnerM;
#   #This gives us the mxn matrix whose (i,j) entry is k(x_i,y_j)
#   H = exp(-H/(2*sigma));
# }
# 
# #rbfk(A,B,sigma, m,n)
# kernelStat <- function(x,y,sigma=1){
#   
#   m<-NROW(x)
#   n<-NROW(y)
#   K = rbfk(x,x,sigma,m,m);
#   L = rbfk(y,y,sigma,n,n);
#   KL = rbfk(x,y,sigma,m,n);
#   
#   statistic = sum(K/(m*(m-1)) + L/(n*(n-1)) - KL/(m*n) - t(KL)/(m*n));
#   return(as.data.frame(statistic))
# }


################################################################################
#Function: edsist
#  
#Description: Computes the energy statistic
#                
#Input: x - First sample (either matrix or vector)
#       y - Second sample (dimensions must match A)
#       
#Output: data frame, with the value of the statistics in $statistic
################################################################################
edist <- function(x ,y) {
  n1 <- NROW(x)
  n2 <- NROW(y)
  if(NCOL(x)==1){
    z<-c(x,y)
  }else{
    z <- rbind(x,y)
  }
  dst <- as.matrix(dist(z))
  ii <- 1:n1
  jj<-  ii+1:n2
  w <- n1 * n2 / (n1 + n2)
  # permutation applied to rows & cols of dist. matrix
  m11 <- sum(dst[ii,ii]) / (n1 * n1)
  m22 <- sum(dst[jj,jj]) / (n2 * n2)
  m12 <- sum(dst[ii,jj]) / (n1 * n2)
  statistic <- w * ((m12 + m12) - (m11 + m22))
  return (as.data.frame(statistic))
}



