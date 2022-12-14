setwd('C:\\Users\\irene1017a\\Documents\\data mining\\R\\data')
Iris <- read.csv('Iris.csv')
#Iris <- Iris[,-5]
Iris.feature <- Iris #Let target variable be covered
Iris.feature$class <- NULL
str(Iris.feature)

set.seed(111)
result <- kmeans(Iris.feature,centers = 3,nstart = 3)
result$cluster#分群
result$centers#質心
result$totss#SST
result$withinss
result$tot.withinss#SSE
result$betweenss#SSB

R_S <- result$betweenss / result$totss
table(Iris$class,result$cluster)
accuracy <- (50+48+36) / 150

Iris[Iris$class=='Iris-setosa',]$class <- 1
Iris[Iris$class=='Iris-versicolor',]$class <- 3
Iris[Iris$class=='Iris-virginica',]$class <- 2
plot(Iris.feature[c('petal.length','petal.width')],col=result$cluster)
plot(Iris.feature[c('petal.length','petal.width')],col=Iris$class)
plot(Iris.feature[c('sepal.length','sepal.width')],col=result$cluster)
plot(Iris.feature[c('sepal.length','sepal.width')],col=Iris$class)

