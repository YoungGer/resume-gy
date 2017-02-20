Sys.setlocale("LC_TIME", "C")
setwd("Downloads/")
rm(list=ls())

eBayTrain = read.csv("eBayiPadTrain.csv", stringsAsFactors=FALSE)
eBayTest = read.csv("eBayiPadTest.csv", stringsAsFactors=FALSE)


#imputation
eBayTest$sold = NA
alldata = rbind(eBayTrain,eBayTest)
simpleAllData = alldata[-10]
library(mice)
summary()

#split
library(caTools)
library(ROCR)
split = sample.split(eBayTrain$sold, SplitRatio = 0.7)
train1 = subset(eBayTrain, split == TRUE)
test = subset(eBayTrain, split == FALSE)

#try1
#glm -- simple
m1 = glm(sold ~ startprice, data=train, family=binomial)
p1 = predict(m1, newdata=test, type="response")
table(test$sold,p1>.5)
#accuracy = (226+181)/(226+181+74+77)=0.7293907
#auc = 0.7857752


#try2
#glm -- multiple without description
m2 = glm(sold~biddable+startprice+condition+cellular+carrier+color+storage+productline,data=train1,family=binomial)
p2 = predict(m2, newdata=test, type="response")
table(test$sold,p2>.5)
#accuracy = (243+198)/(243+198+60+57)=0.79
#auc = 0.8586499
m21 = glm(sold~biddable+startprice+condition+cellular+carrier+color+storage+productline,data=eBayTrain,family=binomial)

#try3
#bag of words
library(tm)
library(SnowballC)

corpus_descrip = Corpus(VectorSource(alldata$description))
corpus_descrip = tm_map(corpus_descrip,tolower)
corpus_descrip = tm_map(corpus_descrip, PlainTextDocument,lazy=TRUE)
corpus_descrip = tm_map(corpus_descrip, removePunctuation,lazy=TRUE)
corpus_descrip = tm_map(corpus_descrip, removeWords, stopwords("english"),lazy=TRUE)
corpus_descrip = tm_map(corpus_descrip,stemDocument,lazy=TRUE)

freq_descrip = DocumentTermMatrix(corpus_descrip)
findFreqTerms(freq_descrip,lowfreq=20)
spar_descrip

#try4 without description & condition
library(caret)
m3 <- train(sold~biddable+startprice+condition+cellular+carrier+color+storage+productline, data=train, method = 'glm', family = binomial, 
                  trControl = trainControl(method = 'cv', number = 5))
library(boot)
m3 = cv.glm(train1,m2,K=2)



#Submission
PredTest = predict(m21, newdata=eBayTest, type="response")
MySubmission = data.frame(UniqueID = eBayTest$UniqueID, Probability1 = PredTest)
write.csv(MySubmission, "SubmissionSimpleLog2.csv", row.names=FALSE)

# Install and load ROCR package
library(ROCR)
# Prediction function
ROCRpred = prediction(p2, test$sold)
# Performance function
ROCRperf = performance(ROCRpred, "tpr", "fpr")
# Plot ROC curve
plot(ROCRperf)
# Add colors
plot(ROCRperf, colorize=TRUE)
# Add threshold labels 
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,by=0.1), text.adj=c(-0.2,1.7))
as.numeric(performance(ROCRpred, "auc")@y.values)
