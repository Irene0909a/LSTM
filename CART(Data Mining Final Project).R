setwd('C:\\Users\\irene1017a\\Documents\\data mining\\Final')
data <- getwd <- read.csv('FinalForR.csv')

str(data)
data <- data[,-1]
data$VisbMean<- as.factor(data$VisbMean)
data$UVI.Max <- as.factor(data$UVI.Max)
data$Cloud.Amount <- as.factor(data$Cloud.Amount)
data$Rain <- as.factor(data$Rain)
set.seed(2021)
n <- nrow(data) 
s <- sample(nrow(data),n*0.7)
trainD <- data[s,]
testD <- data[-s,]


str(TestD)
TestD$Pclass <- as.factor(TestD$Pclass)
TestD$Sex <- as.factor(TestD$Sex)
TestD$SibSp <- as.factor(TestD$SibSp)
TestD$Parch <- as.factor(TestD$Parch)
TestD$Cabin <- as.factor(TestD$Cabin)
TestD$Embarked <- as.factor(TestD$Embarked)
TestD$Survived <- as.factor(TestD$Survived)

library(rpart)
Ctree <- rpart(Rain~. , TrainD , method = 'class')

library(rattle)
fancyRpartPlot(Ctree)

library(rpart.plot)
prp(Ctree , faclen = 0,fallen.leaves = 0,shadow.col = 'cyan')

library(partykit)
Rparty.tree <- as.party(Ctree)
plot(Rparty.tree)

TestD_predicted <- predict(Ctree,TestD,type = 'class')
TestD$Predicted <- TestD_predicted 

cm <- table(TestD$Survived,TestD$Predicted,dnn = c('實際','預測'))
cm
accuracy <- sum(diag(cm)) / sum(cm)
accuracy

printcp(Ctree)
plotcp(Ctree)
prunetree <- prune(Ctree,
                   cp=Ctree$cptable[which.min(Ctree$cptable[,'xerror']),'CP'])
prunetree_Pre <- predict(prunetree,TestD,type = 'class')
prunetree_cm <- table(real=TestD$Rain,predict=prunetree_Pre)
accuracy1 <- sum(diag(prunetree_cm)) / sum(prunetree_cm)


library(caret)
library(e1071)
m1 <- train(Rain~.,data = TrainD,method = 'rpart',trControl = trainControl(method = 'cv',number = 10))
