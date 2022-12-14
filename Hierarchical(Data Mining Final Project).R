setwd('C:\\Users\\irene1017a\\Documents\\data mining\\Final')
data <- getwd <- read.csv('FinalForR.csv')
str(data)
data <- data[,-1]
data$VisbMean<- as.factor(data$VisbMean)
data$UVI.Max <- as.factor(data$UVI.Max)
data$Cloud.Amount <- as.factor(data$Cloud.Amount)
data$RAIN <- as.factor(data$RAIN)
#K_means KNN 名目尺度 > WEKA較好
data$VisbMean<- as.numeric(data$VisbMean)
data$UVI.Max <- as.numeric(data$UVI.Max)
data$Cloud.Amount <- as.numeric(data$Cloud.Amount)
data$RAIN <- as.numeric(data$RAIN)

E.dist <- dist(x=data , method = 'euclidean')
M.dist <- dist(x=data , method = 'manhattan')#只能用名目
par(mfrow=c(1,2))#一頁兩圖
h.E.cluster <- hclust(E.dist)
plot(h.E.cluster,xlab = '歐式距離')
h.M.cluster <- hclust(M.dist)
plot(h.M.cluster,xlab = '歐式距離')

dev.off()
par(mfrow=c(3,2))
plot(hclust(E.dist,method = 'single'),xlab = '最近聚合法:single-linkage')
plot(hclust(E.dist,method = 'complete'),xlab = '最遠聚合法:complete-linkage')
plot(hclust(E.dist,method = 'average'),xlab = '平均聚合法:average-linkage')
plot(hclust(E.dist,method = 'centroid'),xlab = '中心法:centroid-linkage')
plot(hclust(E.dist,method = 'ward.D2'),xlab = '華德法:ward.D2-linkage')
h.E.cluster <- hclust(E.dist,method = 'ward.D2')
#compute with agnes
library(cluster)
#Hierarchical Clustering有分Agglomerative Nesting(聚合法),Divisive(分割法)
#Agglomerative Nesting(聚合法)
#聚合係數是衡量群聚結構被辨識的程度
#聚合係數越接近1代表有堅固的群聚結構(strong clustering structure
hc2 <- agnes(E.dist,method = 'ward')
hc2$ac
#agglomerative coefficient聚合係數
#以上可以整合成agnes(E.dist,method = 'ward')$ac

#若遇將agnes()產生的樹狀圖繪出可使用函數pltree()
pltree(hc2, cex = 0.6, hang = -1, main = "Dendrogram of agnes")
rect.hclust(tree =h.E.cluster, k = 3, border = "red")
cut.h.cluster <- cutree(tree = h.E.cluster, k = 3)
rect.hclust(tree =h.E.cluster, k = 4, border = "brown")
cut.h.cluster <- cutree(tree = h.E.cluster, k = 4)
rect.hclust(tree =h.E.cluster, k = 5, border = "blue")
cut.h.cluster <- cutree(tree = h.E.cluster, k = 5)

#method to access
m <- c('average','single','complete','ward')
names(m) <- c('average','single','complete','ward')
library(MAP)
#function to compute coefficient
ac <- function(x){
  agnes(E.dist,method = x)$ac
}
sapply(m,ac)
