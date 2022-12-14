require("dplyr")
require("stringr")
require("data.table")
require("ggplot2")
require("maptools")
require("knitr")
require("kableExtra")
setwd("C:\\Users\\irene1017a\\Downloads")
df <- getwd <- read.csv("人口分布110.csv", h = T)
df <- data.frame(df)

kable(df)
summary(df)
colnames(df) <- c("COUNTY","Category","Population")
df$Population <- as.numeric(df$Population)

colnames(df) <- c("city","category","population")
ggplot(df, aes(x = reorder(city, population), y = population/10000, fill = category)) + 
  geom_bar(stat="identity") +
  coord_flip() + 
  labs(title = "台灣縣市人口分布圖", x = "縣市", y = "人口數(萬)")

taiwan_shp <- readShapeSpatial("C:\\Users\\irene1017a\\Downloads\\gadm36_TWN_shp\\gadm36_TWN_2.shp")
taiwan_map <- fortify(taiwan_shp)
taiwan_map$group

ggplot(taiwan_map, aes(x = long, y = lat, group=group)) +
  geom_path() + 
  coord_map()
print(as.character(taiwan_shp$NAME_2))
chinese_name <- c("金門縣", "連江縣", "新竹市", "高雄市",
                  "新北市", "臺中市", "臺南市", "臺北市",
                  "桃園市", "彰化縣", "嘉義市", "嘉義縣",
                  "新竹縣", "花蓮縣", "基隆市", "苗栗縣",
                  "南投縣", "澎湖縣", "屏東縣", "臺東縣",
                  "宜蘭縣", "雲林縣")
print(chinese_name)
mydata <- data.frame(NAME_1=taiwan_shp$NAME_2,
                     NAME_2=chinese_name,
                     id=taiwan_shp$GID_2)
mydata$population <- 0
for(i in 1:nrow(mydata)){
  mydata$population[i] <- df$population[which(df$city == mydata$NAME_2[i])]
}
taiwan_map$id <- as.character(as.integer(taiwan_map$id)+1)
mydata$id <- 1
final.plot<-merge(taiwan_map,mydata,by="id",all.x=T)
head(final.plot)

library(RColorBrewer)
library(mapproj)
twcmap <- ggplot() +
  geom_polygon(data = final.plot, 
               aes(x = long, y = lat, group = final.plot$group, 
                   fill = population/10000), 
               color = "black", size = 0.25) + 
  
  coord_map()+#維持地圖比例
  scale_fill_gradientn(colours = brewer.pal(9,"Reds"), name = "人口(萬)")+
  #theme_void()+
  labs(title="台灣縣市人口分佈圖", x ="經度", y = "緯度")

twcmap

