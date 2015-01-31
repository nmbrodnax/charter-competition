#merge all data into one dataset 
mydir<-'/Users/nbrodnax/Indiana/2014fall/s626_bayesian_analysis/final_project/analysis/'
setwd(mydir)
source("def_distance.r")

setwd("data")
data<-read.table('data.dat')
data<-na.omit(data)
prior<-read.table('prior.dat')
prior<-na.omit(prior)
#data<-merge(data,prior,by="schoolid",all=F)
charter<-read.table('charter.dat')

#get dependent variables
levels(data$grade4)<-c("yes","no")
data4<-data[which(data$grade4=="yes"),] #schools that have fourth graders
scores<-c("rwarn","rbelow","rmeet","rexceed","mwarn","mbelow","mmeet","mexceed")
keep<-c("schoolid","black11","size11","lep11","lowinc11",scores,"latitude","longitude","county")
data4<-data4[keep]
labels<-c("schoolid","black11","size11","lep11","lowinc11",scores,"latitude","longitude","county")
colnames(data4)<-labels

#compute independent variables
charter<-charter[which(charter$current=="y" & charter$open<=2009),] #current charters
X<-NULL
for (i in 1:nrow(data4))
  {
  D<-NULL
  for (s in 1:nrow(charter))
  {
    dist<-distance(data4$latitude[i],charter$latitude[s],data4$longitude[i],charter$longitude[s],miles=T)
    D<-rbind(D,dist)
  }
  dmin<-min(D) #min distance
  dmax<-max(D) #max distance
  rad1<-length(which(D<=1)) #charters within 1 mile radius
  rad2<-length(which(D<=2.5)) #2.5 mile radius
  rad5<-length(which(D<=5)) #5 mile radius
  rad10<-length(which(D<=10)) #10 mile radius
  rmex11<-sum(data4$rmeet[i],data4$rexceed[i])
  mmex11<-sum(data4$mmeet[i],data4$mexceed[i])
  ivars<-c(dmin,dmax,rad1,rad2,rad5,rad10,rmex11,mmex11)
  X<-rbind(X,ivars,deparse.level=0)
}
xcols<-c("dmin","dmax","rad1","rad2","rad5","rad10","rmex11","mmex11")
colnames(X)<-xcols
compete<-cbind(data4,X)
write.table(compete,paste(mydir,"compete.dat",sep=""))

#calculate the prior achievement rates
levels(prior$grade4)<-c("yes","no")
prior4<-prior[which(prior$grade4=="yes"),] #schools that have fourth graders
scores<-c("rwarnp","rbelowp","rmeetp","rexceedp","mwarnp","mbelowp","mmeetp","mexceedp")
keep<-c("schoolid","black09","size09","lep09","lowinc09",scores,"latitude","longitude","county")
prior4<-prior4[keep]
labels<-c("schoolid","black09","size09","lep09","lowinc09",scores,"latitude","longitude","county")
colnames(prior4)<-labels

RATE<-NULL
for (i in 1:nrow(prior4))
  {
  rmex09<-sum(prior4$rmeetp[i],prior4$rexceedp[i])
  mmex09<-sum(prior4$mmeetp[i],prior4$mexceedp[i])
  rates<-c(rmex09,mmex09)
  RATE<-rbind(RATE,rates,deparse.level=0)
}
cols<-c("rmex09","mmex09")
colnames(RATE)<-cols
prior<-cbind(prior4,RATE)
write.table(prior,paste(mydir,"prior_rate.dat",sep=""))
