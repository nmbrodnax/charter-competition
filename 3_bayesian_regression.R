#conduct bayesian data analysis - regression with math scores
mydir<-'/Users/nbrodnax/Indiana/2014fall/s626_bayesian_analysis/final_project/analysis/'
setwd(mydir)

library(MASS)
library(xtable)
library(foreign)
library(extrafont)
source('def_backselect.r')
source('def_regression_gprior.r')
source('def_gibbs_normal.r')
source('def_regression.r')

opar<-par() #save parameter settings
data<-read.table('compete.dat')
#data<-na.omit(data)
data10<-data[which(data$dmin<=10),]
prior<-read.table('prior_rate.dat')

#exploratory graphical analysis

#reading achievement all schools
#pdf(file="read_rate_dist.pdf")
#par(pin=c(4,3.5))
#title<-"Figure 2: Reading Achievement by Distance\nto the Nearest Charter School"
#plot(data$dmin,data$rmex11,pch=1,main=title,xlab="Distance (miles)",ylab="Reading Achievement Rate")
#abline(v=10,lty=1,col="black")
#abline(h=50,lty=1,col="black")
#dev.off()

#math achievement all schools
setwd(paste(mydir,"/report",sep=""))
pdf(file="math_rate_dist.pdf",family="CM Roman")
par(pin=c(4,3.5),font.main=1)
title<-"Figure 2: Math Achievement by Distance\nto the Nearest Charter School"
plot(data$dmin,data$mmex11,pch=1,main=title,xlab="Distance (miles)",ylab="Math Achievement Rate")
abline(v=10,lty=1,col="black")
abline(h=70,lty=1,col="black")
dev.off()

#table of descriptive statistics
stats<-matrix(rep(NA,),ncol=4,nrow=6)
colnames(stats)<-c("Mean","S.D.","Min","Max")
rownames(stats)<-c("Achievement Rate","Proximity","Pct Black","Enrollment","Pct English Learners","Pct Low Income")
ivars<-data.frame(data$mmex11,data$dmin,data$black11,data$size11,data$lep11,data$lowinc11)
for (i in 1:length(ivars)) {
  stats[i,1]<-mean(ivars[,i])
  stats[i,2]<-sqrt(var((ivars[,i])))
  stats[i,3]<-min(ivars[,i])
  stats[i,4]<-max(ivars[,i])
}
table<-xtable(stats,digits=3,caption="Descriptive Statistics",align=c("|l","|c","|c","|c","|c|"))
print(table,file="stats.tex",append=F,table.placement="h",caption.placement="top",hline.after=seq(from=-1,to=nrow(table),by=1))

#reshape data to panel
# V<-NULL
# n<-length(data$schoolid)
# for (i in 1:n) {
#   v1<-c(data$schoolid[i],data$dmin[i],data$black11[i],data$size11[i],data$lep11[i],data$lowinc11[i],data$rmex09[i],data$mmex09[i],2009)
#   v2<-c(data$schoolid[i],data$dmin[i],data$black11[i],data$size11[i],data$lep11[i],data$lowinc11[i],data$rmex11[i],data$mmex11[i],2011)
#   V<-rbind(V,v1,v2,deparse.level=0)
# }
# colnames(V)<-c("id","dmin","black","size","lep","lowinc","read","math","year")
# schools<-as.data.frame(V)
# schools$year<-as.factor(schools$year)
# schools$id<-as.character(schools$id)

#create indicator variables for group
# G<-P<-NULL
# n<-length(schools$id)
# for (i in 1:n) {
#   target<-ifelse(schools$dmin[i]<=10,1,0)
#   post<-ifelse(schools$year[i]=="2011",1,0)
#   G<-rbind(G,target,deparse.level=0)
#   P<-rbind(P,post,deparse.level=0)
# }
# colnames(G)<-"target"
# colnames(P)<-"post"
# schools<-cbind(schools,G,P)
# 

#ols regression 
#y<-schools$read 
#n<-length(y)
#X<-cbind(rep(1,n),schools$dmin,schools$black,schools$size,schools$lep,schools$lowinc,schools$post) #dvars all schools
y<-data$mmex11 #math all schools
n<-length(y)
X<-cbind(rep(1,n),data$dmin,data$black11,data$size11,data$lep11,data$lowinc11) #dvars all schools
p<-dim(X)[2]
fit.ls<-lm(y~0+X) #omits intercept since it is included in X 
summary(fit.ls)

#prior data
#rprior<-c(72.9,73.7,73.2,73.8,73.7) #prior achievement rates 2006-2010
#mean.prior.r<-mean(rprior)
#t2.prior.r<-var(rprior)
#mathmex<-c(84.8,86.4,84.6,85.8,85.9) #prior achievement rates 2006-2010
mean.prior.m<-mean(prior$mmex09) #use 2009 scores as prior
t2.prior.m<-var(prior$mmex09) #use 2009 variation as prior

#Bayesian OLS Regression w/ g-prior

fit.g<-lm.gprior(y,X,nu0=2) #bayesian with g-prior
results.g<-matrix(rep(NA,),nrow=6,ncol=3)
colnames(results.g)<-c("beta","lower","upper")
rownames(results.g)<-c("Intercept","Proximity","Pct Black","Enrollment","Pct English Learners","Pct Low Income")

#coeficients and confidence intervals for bayesian with g-prior
for (i in 1:6) { 
  results.g[i,1]<-mean(fit.g$beta[,i])
  results.g[i,2:3]<-quantile(fit.g$beta[,i],c(0.025,0.975))
}
results.g

table<-xtable(results.g,digits=3,caption="Bayesian Estimation Results",align=c("|l","|c","|c","|c|"))
print(table,file="results.tex",append=F,table.placement="h",caption.placement="top",hline.after=seq(from=-1,to=nrow(table),by=1))

#graph results
par(opar)
x<-c(1:130)
pdf(file="post_lines.pdf",family="CM Roman")
par(pin=c(3.5,3.5),font.main=1)
title<-expression(paste("Figure 3: Posterior Estimation with Uncertainty (1000 Samples)"))
plot(range(data$dmin),range(93,103),type="n",xlab="Distance (Miles)",ylab="Math Achievement Rate",main=title)
for (i in 1:1000) {
  y<-fit.g$beta[i,1]+fit.g$beta[i,2]*x
  lines(x,y,col="gray")
}
y<-mean(fit.g$beta[,1])+mean(fit.g$beta[,2])*x
lines(x,y,col="black",lwd=2)
legend("bottomleft",c("Posterior Mean","Posterior Sample"),col=c("black","gray"),lwd=c(2,1),cex=0.8)
dev.off()