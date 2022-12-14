setwd('C:\\Users\\irene1017a\\Documents\\data mining\\R')
bank <- getwd <- read.csv('#中12-bank-kmeans(2).csv')
str(bank)
bank$sex <- as.factor(bank$sex)
bank$region <- as.factor(bank$region)
bank$married <- as.factor(bank$married)
bank$car <- as.factor(bank$car)
bank$save_act <- as.factor(bank$save_act)
bank$current_act <- as.factor(bank$current_act)
bank$mortgage <- as.factor(bank$mortgage)
bank$pep <- as.factor(bank$pep)

#K_means KNN 名目尺度 > WEKA較好
bank$sex <- as.numeric(bank$sex)
bank$region <- as.numeric(bank$region)
bank$married <- as.numeric(bank$married)
bank$car <- as.numeric(bank$car)
bank$save_act <- as.numeric(bank$save_act)
bank$current_act <- as.numeric(bank$current_act)
bank$mortgage <- as.numeric(bank$mortgage)
bank$pep <- as.numeric(bank$pep)

#用比例分割
buy <- bank$pep
bank <- bank[,-11]
set.seed(123)
n <-nrow(bank)
sindex <- sample(n,round(n*0.7))
train <- bank[sindex,]
test <- bank[-sindex,]

buytrain <- buy[sindex]
buytest <- buy[-sindex]

library(class)
prediction <- knn(train = train , test = test, cl=buytrain , k=1)#cl=classification答案>buytrain
cm <- table(x=buytest,y=prediction,dnn=c('real','predict'))
cm

knnaccuracy <- sum(diag(cm))/sum(cm)
knnaccuracy <- NULL
for (i in 1:420) {# Find K
  set.seed(101)
  predicted <- knn(train = train , test = test, cl=buytrain , k=i)
  cm <- table(x=buytest,y=predicted,dnn=c('real','predict'))
  knnaccuracy[i] <- sum(diag(cm))/sum(cm)
}
print(knnaccuracy)
max(knnaccuracy)#我們不知道0.65是k=幾，故建dataframe
k.values <- 1:420
acc.df <- data.frame(knnaccuracy,k.values)
#K=48時最好
acc.df[which.max(knnaccuracy),]#找最大



