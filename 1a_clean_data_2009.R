#clean 2009 data to use for prior distribution
mydir<-'/Users/nbrodnax/Indiana/2014fall/s626_bayesian_analysis/final_project/analysis/'
setwd(mydir)

#school info
setwd("data")
Y1<-read.table("RC09p1.txt",header=F,fill=T,sep=";",stringsAsFactors=F,quote="") #school info
info<-data.frame(Y1[,1],Y1[,3],Y1[,11],Y1[,14],Y1[,19],Y1[,41],Y1[,45])
#info<-data.frame(Y1[,c(1,3,11,14,20,45,53)]) this caused type to be loaded as atomic rather than factor
labels<-c("id","name","type","black09","size09","lep09","lowinc09")
colnames(info)<-labels
info$id<-as.character(info$id)
info$type<-as.factor(info$type)
info$size09<-as.numeric(info$size09)

#achievement scores
Y2<-read.table("RC09p10.txt",header=F,fill=T,sep=";",stringsAsFactors=F,quote="") #ISAT data (no variation in naep data)
scores09<-data.frame(Y2[,c(1:5,18:21)])
labels<-c("id","rwarnp","rbelowp","rmeetp","rexceedp","mwarnp","mbelowp","mmeetp","mexceedp")
colnames(scores09)<-labels
#scores11$id<-as.character(scores11$id)
ildata<-merge(info,scores09,by="id",all=F) #merge IL data
levels(ildata$type)<-c("05","04","02","00","01") #reset the labels for school type
rm(info,scores09,Y1,Y2) #clear out stuff you don't need

#school location
common<-read.csv("common2.csv",header=T,stringsAsFactors=F,quote="") #common core data
cols<-c("school","state","charter","magnet","latitude","longitude","schoolid","schoolid2","agencyid","congress","grade4","county")
colnames(common)<-cols
common$latitude<-as.numeric(common$latitude,length=1)
common$longitude<-as.numeric(common$longitude,length=1)
common$charter<-as.factor(common$charter)
common$magnet<-as.factor(common$magnet)

#create new ids for merging il and common core data
Z<-NULL
ids<-as.vector(as.character(ildata$id))
temp<-strsplit(ids,"") #split id into separate characters
ID<-matrix(unlist(temp),ncol=15,byrow=T) #put the characters into a rowX15 matrix
for (i in 1:nrow(ID)) #create new ids
  {
  Z<-rbind(Z,paste(ID[i,1],ID[i,2],ID[i,3],ID[i,4],ID[i,5],ID[i,6],ID[i,7],ID[i,8],ildata$type[i],ID[i,13],ID[i,14],ID[i,15],sep=""))
}

ildata<-cbind(ildata,Z[,1]) #add the new ids to the dataframe
ildata[,16]<-as.character(ildata[,16]) #change new ideas from factor to character
colnames(ildata)[16]<-"schoolid" #rename new ids

data<-merge(ildata,common,by="schoolid",all=F)
write.table(data,"prior.dat")