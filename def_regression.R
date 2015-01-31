rmvnorm<-function(n,mu,Sigma) #from Hoff code chapter9.r
{ # samples from the multivariate normal distribution
  E<-matrix(rnorm(n*length(mu)),n,length(mu))
  t(  t(E%*%chol(Sigma)) +c(mu))
}

lm.gprior<-function(y,X,g=dim(X)[1],nu0=1,s20=try(summary(lm(y~-1+X))$sigma^2,silent=TRUE),S=1000)
{
  
  n<-dim(X)[1] ; p<-dim(X)[2]
  Hg<- (g/(g+1)) * X%*%solve(t(X)%*%X)%*%t(X)
  SSRg<- t(y)%*%( diag(1,nrow=n)  - Hg ) %*%y
  
  s2<-1/rgamma(S, (nu0+n)/2, (nu0*s20+SSRg)/2 )
  
  Vb<- g*solve(t(X)%*%X)/(g+1)
  Eb<- Vb%*%t(X)%*%y
  
  E<-matrix(rnorm(S*p,0,sqrt(s2)),S,p)
  beta<-t(  t(E%*%chol(Vb)) +c(Eb))
  
  list(beta=beta,s2=s2)                                
}   

rinvwish<-function(n,nu0,iS0) 
{
  sL0 <- chol(iS0) 
  S<-array( dim=c( dim(L0),n ) )
  for(i in 1:n) 
  {
    Z <- matrix(rnorm(nu0 * dim(L0)[1]), nu0, dim(iS0)[1]) %*% sL0  
    S[,,i]<- solve(t(Z)%*%Z)
  }     
  S[,,1:n]
}

### Not sure what this one is
ldmvnorm<-function(y,mu,Sig){  # log mvn density
  c(  -(length(mu)/2)*log(2*pi) -.5*log(det(Sig)) -.5*
        t(y-mu)%*%solve(Sig)%*%(y-mu)   )  
}

### sample from the Wishart distribution
rwish<-function(n,nu0,S0)
{
  sS0 <- chol(S0)
  S<-array( dim=c( dim(S0),n ) )
  for(i in 1:n)
  {
    Z <- matrix(rnorm(nu0 * dim(S0)[1]), nu0, dim(S0)[1]) %*% sS0
    S[,,i]<- t(Z)%*%Z
  }
  S[,,1:n]
}


