#Calculate the shortest distance between two points
distance <- function(dlat1,dlat2,dlon1,dlon2,miles=T) {
  #Set values in decimal degrees
  rmi <- 3958.82
  rkm <- 6371.10
  #Set values in radians
  rlat1 <- dlat1*pi/180
  rlat2 <- dlat2*pi/180
  rlon1 <- dlon1*pi/180
  rlon2 <- dlon2*pi/180
  #Calculate formula components
  latdif <- rlat1-rlat2
  londif <- rlon1-rlon2
  #Calculate distance
  dsigma <- 2*asin(sqrt(sin(latdif/2)^2+cos(rlat1)*cos(rlat2)*sin(londif/2)^2))
  ifelse(miles==F,rkm*dsigma,rmi*dsigma)
}

