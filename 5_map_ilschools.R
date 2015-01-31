#create map of public and charter schools
mydir<-'/Users/nbrodnax/Indiana/2014fall/s626_bayesian_analysis/final_project/analysis/'
setwd(mydir)

library(maps)
library(extrafont)

tps<-read.table('compete.dat')
setwd('data')
charter<-read.table('charter.dat')
mappar<-par()

setwd(paste(mydir,"/report",sep=""))
pdf(file="ilmap.pdf",family="CM Roman")
par(mar=c(1,1,1,0.1), font.main=1)
map("county","illinois")
points(tps$longitude,tps$latitude,col="gray",pch=16,cex=0.5)
points(charter$longitude,charter$latitude,col="black",pch=17,cex=0.8)
title("Figure 1: Illinois Public Schools")
legend("bottomleft",c("Traditional","Charter"),title="Public School Type",pch=c(16,17),col=c("gray","black"))
dev.off()