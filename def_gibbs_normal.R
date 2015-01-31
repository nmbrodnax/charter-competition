gibbs.normal<-function(mu0,t20,s20,nu0,y,S) {
  n<-length(y) ; mean.y<-mean(y) ; var.y<-var(y)
  set.seed(1)
  PHI<-matrix(nrow=S,ncol=2)
  PHI[1,]<-phi<-c( mean.y, 1/var.y)
  
  ### Gibbs sampling
  for(s in 2:S) {
    
    # generate a new theta value from its full conditional
    mun<-  ( mu0/t20 + n*mean.y*phi[2] ) / ( 1/t20 + n*phi[2] )
    t2n<- 1/( 1/t20 + n*phi[2] )
    phi[1]<-rnorm(1, mun, sqrt(t2n) )
    
    # generate a new sigma^2 value from its full conditional
    nun<- nu0+n
    s2n<- (nu0*s20 + (n-1)*var.y + n*(mean.y-phi[1])^2 ) /nun
    phi[2]<- rgamma(1, nun/2, nun*s2n/2)
    
    PHI[s,]<-phi         }
  return(PHI)
}
