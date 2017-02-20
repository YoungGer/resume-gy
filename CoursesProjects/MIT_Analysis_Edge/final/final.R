#Final Exam

#Problem 1
getwd()
setwd("./Downloads/")
getwd()
dir()
#load data
Movies = read.csv("Movies.csv")
str(Movies)
head(Movies)
train = subset(Movies,Year<2010)
test  = subset(Movies,Year>=2010)
#linear model
model1 = lm(Worldwide~.,data=train[,3:ncol(train)])
summary(model1)
model2 = lm(Worldwide~Runtime+Crime+Horror+Animation+History+Nominations+Production.Budget,data=train)
summary(model2)
#test validation
p1 = predict(model2,newdata = test)
sse = sum((p1-test$Worldwide)^2)
sst = sum((mean(train$Worldwide)-test$Worldwide)^2)
r2 = 1-sse/sst
#add new "Performance" variable
Movies$Performance = factor(ifelse(Movies$Worldwide>quantile(Movies$Worldwide,.75),"Excellent",
                                   ifelse(Movies$Worldwide>quantile(Movies$Worldwide,.25),
                                          "Average","Poor")))
Movies$Worldwide = NULL
library(caTools)
set.seed(15071)
split = sample.split(Movies$Performance,SplitRatio = .7)
train = subset(Movies,split==TRUE)
test  = subset(Movies,split==FALSE)
#cart model
library(rpart)
library(rpart.plot)
model3 = rpart(Performance~.,data=train[,3:ncol(train)])
plot(model3)
text(model3)
#traing set accuracy
mean(train$Performance==predict(model3,newdata = train,type="class"))
mean(train$Performance=="Average")
#test set accuracy
mean(test$Performance==predict(model3,newdata = test,type="class"))
mean(test$Performance=="Average")



#Problem 2
rm(list=ls())
setwd("/Users/yangguangyao/Documents/GitHub_Project/MoocCourses/Analysis_Edge/final")
d = read.csv("federalFundsRate.csv")
table(d$Chairman)
#split data
set.seed(201)
spl = sample.split(d$RaisedFedFunds,0.7)
train = subset(d,spl==TRUE)
test  = subset(d,spl==FALSE)
#logistic model
model1 = glm(RaisedFedFunds~PreviousRate+Streak+Unemployment+
               HomeownershipRate+DemocraticPres+MonthsUntilElection ,data=train,
             family=binomial)
#predict 
fix(test1)
predict(model1,newdata = test1,type="response")
summary(model1)
#test set validation
p1 = predict(model1,newdata = test,type="response") > .5
table(train$RaisedFedFunds)
table(p1)
library(ROCR)
ROCRpred = prediction(predict(model1,newdata = test,type="response"), test$RaisedFedFunds)
as.numeric(performance(ROCRpred, "auc")@y.values)
#cross-validation for a cart model
set.seed(201)
library(caret)
library(e1071)
set.seed(201)
tr.control = trainControl(method = "cv", number = 10)
cp.grid = expand.grid( .cp = (1:50)*0.001)
tr = train(RaisedFedFunds~PreviousRate+Streak+Unemployment+
             HomeownershipRate+DemocraticPres+MonthsUntilElection, 
           data = train, 
           method = "rpart", trControl = tr.control, tuneGrid = cp.grid)
best.tree = tr$finalModel
##best.tree
best.tree = rpart(RaisedFedFunds~PreviousRate+Streak+Unemployment+
                    HomeownershipRate+DemocraticPres+MonthsUntilElection, 
                  data = train, cp=0.016)
prp(best.tree)
best.tree.pred = predict(best.tree, newdata=test)
best.tree.sse = sum((best.tree.pred - test$MEDV)^2)
p2 = predict(best.tree ,newdata = test1) 
#test validation
table(test$RaisedFedFunds,predict(best.tree ,newdata = test)>.5)
(79+36)/175



#Problem 3
rm(list=ls())
d = read.csv("Households.csv")
head(d)
d$MorningPct[order(d$MorningPct)]
length(which(d$AfternoonPct==100))
min(subset(d,AvgSalesValue>150)$AvgDiscount)
min(subset(d,AvgDiscount>25)$AvgSalesValue)
mean(d$NumVisits >= 300)
summary(d)
#normalizing
library(caret)
preproc = preProcess(d)
d_norm = predict(preproc,d)
d_norm2 = scale(d)
max(d_norm$NumVisits)
min(d_norm$AfternoonPct)
#dendrogram
set.seed(200)
distances = dist(d_norm,method="euclidean")
ClusterShoppers = hclust(distances,method="ward.D")
plot(ClusterShoppers,labels=FALSE)
#general cluster
rect.hclust(ClusterShoppers, k = 10, border = "red")
Clusters = cutree(ClusterShoppers, k = 10)
table(Clusters)[order(table(Clusters))]
#k-means cluster
k = 5
set.seed(5000)
KMC = kmeans(d_norm, centers = k)
str(KMC)
#w1
table(KMC$cluster)[order(table(KMC$cluster))]
mean(d[KMC$cluster==1,]$MorningPct)
mean(d[KMC$cluster==2,]$MorningPct)
mean(d[KMC$cluster==3,]$MorningPct)
mean(d[KMC$cluster==4,]$MorningPct)
mean(d[KMC$cluster==5,]$MorningPct)
mean(d[KMC$cluster==6,]$MorningPct)
mean(d[KMC$cluster==7,]$MorningPct)
mean(d[KMC$cluster==8,]$MorningPct)
mean(d[KMC$cluster==9,]$MorningPct)
mean(d[KMC$cluster==10,]$MorningPct)
#w2
KMC$centers
#w3
tapply(d$MorningPct,KMC$cluster,mean)
# Extract clusters
healthyClusters = KMC$cluster
KMC$centers[2]







