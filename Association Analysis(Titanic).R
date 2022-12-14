setwd('C:\\Users\\irene1017a\\Downloads')
data<- getwd <- read.csv('titanic-train.csv')
str(data)
data$Pclass <- as.factor(data$Pclass)
data$SibSp <- as.factor(data$SibSp)
data$Parch <- as.factor(data$Parch)

library(infotheo)
data$Age <- discretize(data$Age,'equalwidth',3)
data$Age <- as.factor(data$Age$X)

data$Ticket <- discretize(data$Ticket ,'equalfreq',3)
data$Ticket  <- as.factor(data$Ticket$X)

data$Fare <- discretize(data$Fare,'equalfreq',3)
data$Fare <- as.factor(data$Fare$X)

str(data)


require(arules)
rule <- apriori(data,parameter = list(supp=0.1,conf=0.7),
                appearance = list(rhs=c('Survived=Yes','Survived=No')))#appearance_最小規則長度
sort.rule <- sort(rule,by='support')
subset.matrix <- as.matrix(is.subset(x=sort.rule,y=sort.rule))#is.subset>在X的項目若是Y的子集>回傳TRUE
subset.matrix[lower.tri(subset.matrix,diag = T)] <-NA#將下三角形資訊刪除(自己對自己的矩陣只須看一半)
redundent <- colSums(subset.matrix,na.rm = T) >=1#計算有超過一個以上的子集合(多餘的)，用na.rm = T將下三角形刪除
sort.rule <- sort.rule[!redundent]
sort.rule <- as(sort.rule,'data.frame')
write.csv(sort.rule,'Titanic-rules.csv')

#resample
BankNO <- subset(data,Survived=='No')
BankYes <- subset(data,Survived=='Yes')
set.seed(2021)
n <- nrow(BankNO)
sindex <- sample(n,218)
BankNO <- BankNO[sindex,]
newbank <- rbind(BankNO,BankYes)

require(arules)
rule <- apriori(newbank,parameter = list(supp=0.1,conf=0.7),
                appearance = list(rhs=c('y=yes','y=no')))
sort.rule <- sort(rule,by='support')#排序後規則
subset.matrix <- as.matrix(is.subset(x=sort.rule,y=sort.rule))
subset.matrix[lower.tri(subset.matrix,diag = T)] <-NA
redundent <- colSums(subset.matrix,na.rm = T) >=1 
sort.rule <- sort.rule[!redundent]
sort.rule <- as(sort.rule,'data.frame')
write.csv(sort.rule,'Bank-rules2.csv')
