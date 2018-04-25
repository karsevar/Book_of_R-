gg.static <- ggplot(data=mtcars,mapping=aes(x=hp)) +
ggtitle("Horsepower") + labs(x="HP")
mtcars.mm <-  data.frame(mm=c(mean(mtcars$hp),median(mtcars$hp)),stats=factor(c("mean","median")))
gg.lines <- geom_vline(mapping=aes(xintercept=mm,linetype=stats),show.legend=TRUE,data=mtcars.mm)

gg.static + geom_histogram(color="black",fill="white", breaks=seq(0,400,25),closed="right") + gg.lines + scale_linetype_manual(values=c(2,3)) + labs(linestype="")# ggplot2 illustration of horsepower values according to the number of cars in the study. Tilman says that if you want to only create a histogram without the mean and median lines all you need to do is process the code:

gg.static + geom_histogram(color="black",fill="white",breaks=seq(0,300,15),closed="right")

library("MASS")
surv <- na.omit(survey[,c("Sex","Wr.Hnd","Height")])
ggplot(surv,aes(x=Wr.Hnd, y=Height)) + 
geom_point(aes(col=Sex,shape=Sex)) + geom_smooth(method="loess")

dev.new()
plot(surv$Wr.Hnd, surv$Height,col=surv$Sex, pch=c(16,17)[surv$Sex])
smoother <- loess(Height~Wr.Hnd,data=surv)
handseq <- seq(min(surv$Wr.Hnd), max(surv$Wr.Hnd),length=100)
sm <- predict(smoother,newdata=data.frame(Wr.Hnd=handseq),se=TRUE)
lines(handseq,sm$fit)
polygon(x=c(handseq,rev(handseq)),y=c(sm$fit+2*sm$se,rev(sm$fit-2*sm$se)),col=adjustcolor("gray",alpha.f=0.5),border=NA)

ggplot(surv,aes(x=Wr.Hnd,y=Height,col=Sex, shape=Sex)) + 
geom_point() + geom_smooth(method="loess", span=0.25)

ggplot(data=airquality, aes(x=Temp)) + geom_density()
dev.new()
air <- airquality
air$Month <- factor(air$Month,labels=c("May","June","July","August","September"))
ggplot(data=air,aes(x=Temp,fill=Month)) + geom_density(alpha=0.4) + 
ggtitle("Monthly temperature probability densities") + 
labs(x="Temp",y="Kernel estimate")

library("gridExtra")
gg1 <- ggplot(air,aes(x=1:nrow(air),y=Temp)) +
geom_line(aes(col=Month)) +
geom_point(aes(col=Month,size=Wind)) +
geom_smooth(method="loess",col="black") + 
labs(x="Time (days)", y="Temperature (F)")

gg2 <- ggplot(air,aes(x=Solar.R,fill=Month)) +
geom_density(alpha=0.4) +
labs(x=expression(paste("Solar Radiation (",ring(A),")")), y="Kernel estimate")

gg3 <- ggplot(air,aes(x=Wind,y=Temp,color=Month)) +
geom_point(aes(size=Ozone)) +
geom_smooth(method="lm",level=0.9,fullrange=FALSE,alpha=0.2) + 
labs(x="Wind speed (MHP)",y="Temperature (F)")

grid.arrange(gg1,gg2,gg3)

gg4 <- ggplot(air,aes(x=Wind,y=Temp,color=Month)) +
geom_point(aes(size=Ozone)) + 
geom_smooth(method="loess",alpha=0.2, span=1)

ggp <- ggplot(data=air, aes(x=Temp,fill=Month)) + geom_density(alpha=0.4) +
ggtitle("Monthly temperature probability densities") + labs(x="Temp (F))", y="Kernel estimate")
dev.new()
ggp + facet_wrap(~Month)
ggp + facet_wrap(~Month,scales="free")
dev.new()
ggp + facet_wrap(~Month,nrow=1)
ggp+facet_wrap(~Month,ncol=2)
ggp+ facet_grid(.~Month)
library("faraway")
diab <- na.omit(diabetes[,c("chol","weight","gender","frame","age","height","location")])
ggplot(diab,aes(x=age,y=chol)) +
geom_point(aes(shape=location,size=weight,col=height)) +
facet_grid(gender~frame) + geom_smooth(method="lm") + labs(y="cholesterol")

###Exercise 24.1 ####
#a.
library("MASS")
cereal.me <- na.omit(UScereal[,c("mfr","calories","fat","protein","sodium","fibre","carbo","sugars","shelf","potassium","vitamins")])
levels(cereal.me$mfr) <- c("General Mills","Kellogs","other","other","other","other")
cereal.me$shelf <- as.factor(cereal.me$shelf)

#b.
ggc <- ggplot(data=cereal.me,aes(y=calories, x=protein,color=shelf)) +
geom_point(aes(shape=mfr)) + geom_smooth(method="lm",level=0.95,alpha=0.2,fullrange=FALSE) + 
labs(x="protein",y="calories")

ggc + facet_wrap(~shelf, scales="free",ncol=1)

gg.me <- ggplot(data=cereal.me,aes(x=calories,fill=shelf)) + geom_density(alpha=0.5)  + ggtitle("Calorie density per shelf location") + labs(x="Calories",y="Kernel Density")


#c.
grid.arrange(ggc,gg.me)

#d.
gg.flea <- ggplot(data=cereal.me, aes(x=calories, y=protein,fill=mfr)) + 
geom_point(aes(size=sodium,col=sugars,shape=shelf)) + geom_smooth(method="loess",span=0.9,col="black") + labs(x="calories",y="protein")

gg.flea + facet_wrap(~mfr, scales="free")

#e.
gg1 <- ggplot(data=Salaries,aes(x=yrs.service,y=salary,color=sex)) + 
geom_point(aes(col=sex)) + geom_smooth(method="loess") + labs(x="Years of Service", y="Salary") 

#f.
gg2 <- ggplot(data=Salaries, aes(x=rank, y=salary,fill=sex)) + geom_boxplot(inherit.aes=TRUE)
gg3 <- ggplot(data=Salaries, aes(x=discipline, y=salary,fill=sex)) + geom_boxplot() 
gg4 <- ggplot(data=Salaries, aes(x=salary, fill=rank)) + geom_density(alpha= 0.3) + ggtitle("Salary probability distribution organized according to rank") + labs(x="Rank",y="Kernel estimate")

#g.
grid.arrange(gg1,gg2,gg3,gg4)

#h. 
gg.pee <- ggplot(data=Salaries,aes(x=salary, fill=sex)) + geom_density(alpha=0.70) + facet_grid(~rank)
gg.pee2 <- ggplot(data=Salaries, aes(x=salary,fill=sex)) + geom_density(alpha=0.70) + 
facet_grid(sex~rank)

gg.bee <- ggplot(data=Salaries, aes(x=yrs.service,y=salary,fill=sex)) + 
facet_grid(~rank,scale="free") + geom_smooth(method="lm",level=0.90,col="black") + labs(y="Salary",x="Years of Service")

gg.bee <- ggplot(data=Salaries, aes(x=yrs.service,y=salary,fill=sex)) + 
facet_grid(sex~rank,scale="free") + geom_smooth(method="lm",level=0.90,col="black") + labs(y="Salary",x="Years of Service")


