# R Workshop material for ULEAM course
# (c) Diego Lizcano 2015

require(ggplot2)
require(reshape)
require(vegan)
require(MASS)
#################################################
# Parte 1 - R objects functions                  #
#################################################

# a vector of three numbers
numbers <- c(1,2,3)
numbers

# a vector of three strings
names <- c("Sarah","Sandy","Steve")
names

# a data frame that combines both
data <-data.frame(names=names,numbers=numbers)
data
str(data)
# a list that combines all plus a matrix
alist <- list(names=names,numbers=numbers,
              data=data,matrix=matrix(1:25,5,5))
alist
str(alist)

# a function
# returns the sum of the elements of the matrix in the list
f.add <- function(list) {
  sum(list$matrix,na.rm=TRUE)
}
f.add(alist)
str(f.add)

#################################################
# Part 2 - R data manipulation, simple models   #
#################################################

#Data manipulation with TEAM vegetation data
veg.data.FULL<-read.csv("http://dl.dropbox.com/u/5014735/VT-20120201104226_1961.csv",header=T,skip=110)
head(veg.data.FULL)
names(veg.data.FULL)
# get rid of columns 1,6,8 to 11,13,17,18,19,20,22 to 27
veg.data.s<-veg.data.FULL[,-c(1,6,8:11,13,17,18,19,20,22,24:27)]
names(veg.data.s)
names(veg.data.s)[11]<-"Plot"
head(veg.data.s)
#change names
#veg.data.FULL<-veg.data
veg.data<-veg.data.s
head(veg.data)

# Create Genus-species variable
veg.data<-data.frame(veg.data,bin=paste(veg.data$Genus,veg.data$Species,sep=" "))
head(veg.data)

# Lets do some fun things like look at the number of species total, number of species
# per year and number of species per plot per year

# Total number of species
dim(veg.data)
species<-unique(veg.data$bin)
length(species)

# We could also do in one line

length(unique(veg.data$bin))

# Now plot number of species per year

?tapply
#GO TO KEYNOTE!!
species.year<-tapply(veg.data$bin,veg.data$Sampling.Period,
                     function(x){length(unique(x))})
plot(species.year,x=c(2003:2011),xlab="Year",ylab="Number of observed species",type="b")

# Now plot number of species per plot

species.plot<-tapply(veg.data$bin,veg.data$Plot,function(x){length(unique(x))})
barplot(as.numeric(species.plot),names.arg=names(species.plot))

#lets do it both by plot and time
species.plot.year<-tapply(veg.data$bin,list(veg.data$Plot, veg.data$Sampling.Period),
                          function(x){length(unique(x))})
species.plot.year
matplot(t(species.plot.year),t='b',xlab="sampling year",ylab="number of species")

species.plot.year.m<-melt(species.plot.year)
p<-ggplot(data=species.plot.year.m,aes(x=X2,y=value,color=X1))+geom_line()

# Look at the relationship between number of species and number of stems and basal area
# Extract the data from year 8 (2010)

indx<-which(veg.data$Sampling.Period=="2010.01")
length(indx)

d.2010<-veg.data[indx,]
head(d.2010)
tail(d.2010)
#extract number of species
sp.plt.2010<-tapply(d.2010$bin,d.2010$Plot,function(x){length(unique(x))})
sp.plt.2010

#extract the number of individuals
ind.plt.2010<-tapply(d.2010$bin,d.2010$Plot,length)
ind.plt.2010

#extract the basal area of individuals
# First write a helper function for that

f.ba<-function(diameter){
  pi*(diameter/2)^2
}

ba.plt.2010<-tapply(d.2010$Diameter,d.2010$Plot,
                    function(x){sum(f.ba(x),na.rm=TRUE)})
ba.plt.2010
#same thing with one intermediate step
ba<-f.ba(d.2010$Diameter)
tapply(ba,d.2010$Plot,sum,na.rm=TRUE)

#lets put together all these summaries in one place
p.2010<-data.frame(ind=ind.plt.2010,sp=sp.plt.2010,ba=ba.plt.2010)
p.2010
#Look at some plots
par(mfrow=c(1,2))
plot(sp~ind,p.2010,pch=19,cex=2,xlab="Number of stems",ylab="Number of species")
plot(sp~ba,p.2010,pch=19,cex=2,xlab="Basal area (cm2)",ylab="Number of species")
plot(ind~1,p.2010)
plot(ind~1,p.2010,t='l')

plot(sp[-6]~ind[-6],p.2010,pch=19,cex=2,xlab="Number of stems",ylab="Number of species")
plot(sp[-6]~ba[-6],p.2010,pch=19,cex=2,xlab="Basal area (cm2)",ylab="Number of species")

mod0<-lm(sp~1,p.2010,subset=c(1:5,7:9))
mod1<-lm(sp.plt.2010~ind.plt.2010,subset=c(1:5,7:9))
mod2<-lm(sp.plt.2010~ind.plt.2010+ba.plt.2010,subset=c(1:5,7:9))
mod3<-lm(sp.plt.2010~ind.plt.2010*ba.plt.2010,subset=c(1:5,7:9))

summary(mod0)
summary(mod1)
summary(mod2)
summary(mod3)


par(mfrow=c(1,1))

AIC(mod0,mod1,mod2,mod3)


#fit a linear model to the original data
lmeData<-read.csv("http://dl.dropbox.com/u/5014735/dataMatrix.csv",h=T)
head(lmeData)
plot(totcatch~speciesRichness,lmeData)
#fit a linear model to the original data
mod0<-lm(totcatch~speciesRichness,lmeData)
abline(mod0)

#find the bext transformation with a box-cox transformation
library(MASS)
bx<-boxcox(mod0)
bx
which(bx$y==max(bx$y))
lambda<-bx$x[which(bx$y==max(bx$y))]
lambda
mod0<-lm(totcatch^lambda~speciesRichness,lmeData)
summary(mod0)
plot(totcatch^lambda~speciesRichness,lmeData)
abline(mod0)

#fit some models and graph model fits
#simple linear model
plot(log(totcatch)~speciesRichness,lmeData)

mod1<-lm(log(totcatch)~speciesRichness,lmeData)
summary(mod1)

#generate predictions from the model
pred1<-predict(mod1,newdata=pred.range<-data.frame(speciesRichness=seq(0,4000,
                                            by=100)),interval="confidence")
pred1

#graph model fit
par(mfrow=c(2,2))
plot(log(totcatch)~speciesRichness,lmeData,main="mod1")
lines(pred.range[,1],pred1[,1],lwd=2)
lines(pred.range[,1],pred1[,2],lty=2)
lines(pred.range[,1],pred1[,3],lty=2)

#fit a model with log(speciesRichess), plot results
mod2<-lm(log(totcatch)~log(speciesRichness),lmeData)
summary(mod2)
pred2<-predict(mod2,newdata=pred.range,interval="confidence")
plot(log(totcatch)~speciesRichness,lmeData,main="mod2")
lines(pred.range[,1],pred2[,1],lwd=2)
lines(pred.range[,1],pred2[,2],lty=2)
lines(pred.range[,1],pred2[,3],lty=2)

#fit a polynomial of degree 3
mod3<-lm(log(totcatch)~poly(speciesRichness,3),lmeData)
plot(log(totcatch)~speciesRichness,lmeData,main="mod3")
pred3<-predict(mod3,newdata=pred.range,interval="confidence")
lines(pred.range[,1],pred3[,1],lwd=2)
lines(pred.range[,1],pred3[,2],lty=2)
lines(pred.range[,1],pred3[,3],lty=2)

#fit a polynomial of degree 4
mod4<-lm(log(totcatch)~poly(speciesRichness,5),lmeData)
plot(log(totcatch)~speciesRichness,lmeData,main="mod4")
pred4<-predict(mod4,newdata=pred.range,interval="confidence")
lines(pred.range[,1],pred4[,1],lwd=2)
lines(pred.range[,1],pred4[,2],lty=2)
lines(pred.range[,1],pred4[,3],lty=2)

#compare model AIC's
AIC(mod1,mod2,mod3,mod4)
anova(mod1,mod2,mod3,mod4)
par(mfrow=c(1,1))

#################################################
# Part 3 - Explore BiodiversityR                #
#################################################

#import fish species data
spSite<-read.csv("http://dl.dropbox.com/u/5014735/speciesBySite.csv",row.names=1,
                 header=TRUE)
dim(spSite)
ran<-sample(1:12332,5000,replace=F)
head(ran)
spSiteSub<-spSite[,ran]

#install.packages("BiodiversityR",dependencies=TRUE)
library(BiodiversityR)
?BiodiversityR
?accumresult
resEx<-accumresult(spSiteSub)
accumplot(resEx)

# takes a little longer resRar<-accumresult(spSiteSub,method="rarefaction") 

#An example from the documentation for species accumulation curves

library(vegan)
data(dune.env)
data(dune)
head(dune);head(dune.env)
dune.env$site.totals <- apply(dune,1,sum)
Accum.1 <- accumresult(dune, y=dune.env, scale='site.totals', method='exact', 
                       conditioned=TRUE)
Accum.1
accumplot(Accum.1)
accumcomp(dune, y=dune.env, factor='Management', method='exact', legend=TRUE, 
          conditioned=TRUE)
## CLICK IN THE GRAPH TO INDICATE WHERE THE LEGEND NEEDS TO BE PLACED FOR
## OPTION WHERE LEGEND=TRUE (DEFAULT).

#Other diversity indexes
?diversityresult
Diversity.1 <- diversityresult(dune, y=dune.env, factor='Management',
                               level='NM', index='Shannon' ,method='s',
                               sortit=TRUE, digits=3)
Diversity.1
diversitycomp(dune, y=dune.env, factor1='Management', factor2="Moisture", 
              index='Shannon' ,method='all', sortit=TRUE, digits=3)

#rank-abundance curves

?rankabundance
rankRes<-rankabundance(spSite)
rankabunplot(rankRes,scale="logabun",specnames=c(1,1000,5000,10000),type="l")
str(Diversity.1)
