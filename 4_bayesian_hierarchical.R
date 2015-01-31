#conduct bayesian data analysis - hierarchical model
mydir<-'/Users/nbrodnax/Indiana/2014fall/s626_bayesian_analysis/final_project/analysis/'
setwd(mydir)

library(extrafont)
opar<-par()

#data for schools and counties
data<-read.table("compete.dat")
prior<-read.table("prior_rate.dat")
Y<-data.frame(county=data$county,rate=data$mmex11)
prior.rate<-na.omit(prior$mmex09)
counties<-levels(Y[,1])

# #data for schools and counties
# data<-read.table("compete.dat")
# data<-na.omit(data)
# setwd(paste(mydir,"/data",sep=""))
# #prior<-read.table("prior.dat")
# #prior<-na.omit(prior)
# Y<-data.frame(county=data$county,rate=data$mmex11)
# prior.rate<-data$mmex09
# counties<-levels(Y[,1])
# setwd(mydir)

#achievement variation by county
setwd(paste(mydir,"/report",sep=""))
pdf("counties.pdf",family="CM Roman")
par(pin=c(5.5,2.5),font.main=1)
boxes<-list(Y[Y[1]==counties[1],2])
for (i in 2:100) {
  county<-Y[Y[1]==counties[i],2]
  boxes<-c(boxes,list(county))
}
title<-"Figure 4: Math Achievement Rates for All Illinois Counties"
boxplot(boxes,range=0,ylab="Math Achievement Rate",main=title,xaxt="n")
abline(h=mean(Y[,2]))
par(opar)
dev.off()

#hierarchical model

#weakly informative priors
nu0<-2 #high uncertainty
s20<-t20<-var(prior.rate) #variance for 2009 scores for all schools
eta0<-2 #high uncertainty
mu0<-mean(prior.rate) #mean of 2009 scores for all schools
g20<-25 #3 standard deviations caps rate at 100

#starting values
m<-length(unique(Y[,1])) 
n<-sv<-ybar<-rep(NA,m) 
for(j in 1:101) 
{ #this is where the problem is
  ybar[j]<-mean(Y[Y[[1]]==counties[j],2])
  n[j]<-length(Y[Y[[1]]==counties[j],2]) 
  sv[j]<-ifelse(n[j]==1,0,var(Y[Y[[1]]==counties[j],2])) #some districts have one school
}
theta<-ybar
sigma2<-mean(sv) #returns NA_real
mu<-mean(theta) #returns NaN
tau2<-var(theta) #returns NA_real

#setup MCMC
set.seed(1)
S<-5000
THETA<-matrix( nrow=S,ncol=m)
MST<-matrix( nrow=S,ncol=3)

#MCMC algorithm
for(s in 1:S) 
{
  
  #sample new values of the thetas
  for(j in 1:m) 
  {
    vtheta<-1/(n[j]/sigma2+1/tau2)
    etheta<-vtheta*(ybar[j]*n[j]/sigma2+mu/tau2)
    theta[j]<-rnorm(1,etheta,sqrt(vtheta))
  }
  
  #sample new value of sigma2
  nun<-nu0+sum(n)
  ss<-nu0*s20;for(j in 1:m){ss<-ss+sum((Y[Y[[1]]==j,2]-theta[j])^2)}
  sigma2<-1/rgamma(1,nun/2,ss/2)
  
  #sample a new value of mu
  vmu<- 1/(m/tau2+1/g20)
  emu<- vmu*(m*mean(theta)/tau2 + mu0/g20)
  mu<-rnorm(1,emu,sqrt(vmu)) 
  
  #sample a new value of tau2
  etam<-eta0+m
  ss<- eta0*t20 + sum( (theta-mu)^2 )
  tau2<-1/rgamma(1,etam/2,ss/2)
  
  #store results
  THETA[s,]<-theta
  MST[s,]<-c(mu,sigma2,tau2)
  
} 

#assess convergence
stationarity.plot<-function(x,...){
  
  S<-length(x)
  scan<-1:S
  ng<-min( round(S/100),10)
  group<-S*ceiling( ng*scan/S) /ng
  
  boxplot(x~group,...)               }

#graph convergence plots
pdf(file="mu.pdf",family="CM Roman")
par(pin=c(5,2),font.main=1)
stationarity.plot(MST[,1],xlab="Iteration",ylab="Achievement Rate",main=expression(paste("Figure 6: Convergence of Population Mean")))
dev.off()

pdf(file="sigma.pdf",family="CM Roman")
par(pin=c(5,2),font.main=1)
stationarity.plot(MST[,2],xlab="Iteration",ylab="Variance",main=expression(paste("Figure 8: Convergence of Within-County Variation")))
dev.off()

pdf(file="tau.pdf",family="CM Roman")
par(pin=c(5,2),font.main=1)
stationarity.plot(MST[,3],xlab="Iteration",ylab="Variance",main=expression(paste("Figure 7: Convergence of Between-County Variation")))
dev.off()

#check the effective sample sizes
library(lattice)
library(coda)
effectiveSize(MST)
summary(effectiveSize(THETA))

#posterior means
for (i in 1:3)
{
  print(mean(MST[,i]))
  print(quantile(MST[,i],c(0.025,0.975)))
}

#graph posterior densities
pdf(file="mu_post.pdf",family="CM Roman")
par(pin=c(3,3),font.main=1)
plot(density(MST[,1]),xlab="Math Achievement Rate",main="Figure 9: Population Mean",xlim=range(65,100))
lines(density(rnorm(5000,mu0,sqrt(g20))),lty=2)
legend(x="topleft",c("Posterior","Prior"),lty=c(1,2),cex=0.8)
dev.off()

pdf(file="sigma_post.pdf",family="CM Roman")
par(pin=c(3,3),font.main=1)
plot(density(MST[,2]),xlab="Variance",main="Figure 11: Within-County Variation")
lines(density(1/rgamma(5000,(nu0/2),(nu0*s20)/2)),lty=2)
legend(x="topright",c("Posterior","Prior"),lty=c(1,2),cex=0.8)
dev.off()

pdf(file="tau_post.pdf",family="CM Roman")
par(pin=c(3,3),font.main=1)
plot(density(MST[,3]),xlab="Variance",main="Figure 10: Between-County Variation")
lines(density(1/rgamma(5000,(eta0/2),(eta0*t20)/2)),lty=2)
legend(x="topright",c("Posterior","Prior"),lty=c(1,2),cex=0.8)
dev.off()

pdf(file="theta_post.pdf",family="CM Roman")
par(pin=c(5.5,2.5),font.main=1)
boxes<-list(THETA[,1])
for (i in 2:100) {
  county<-THETA[,i]
  boxes<-c(boxes,list(county))
}
title<-"Figure 5: Posterior Achievement Rates by County"
boxplot(boxes,range=0,ylab="Math Achievement Rate",main=title,xaxt="n")
abline(h=mean(THETA))
dev.off()
