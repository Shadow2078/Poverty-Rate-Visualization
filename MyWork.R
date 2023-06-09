install.packages("cartography")
install.packages("sf")
install.packages("haven")
library(tidyverse)
library(cartography)
library(sf)
setwd("C:/DataDristi/Data Science Practice")

#We need to download the shape file for Nepal.

data <- st_read("shape_files_of_districts_in_nepal.shp")
library(haven)
poverty<-read_dta("poverty.dta")
view(poverty)
poverty$pov<-poverty$poverty*100
mapdata<-merge(data,poverty, by="dist_name")
view(mapdata)
names(mapdata)
plot(st_geometry(mapdata))
choroLayer(x=mapdata, var="pov", method="quantile",nclass=5)
layoutLayer(title="Poverty by Districts:Nepal",tabtitle =TRUE,frame=TRUE,scale =6 )

plot(st_geometry(mapdata))
choroLayer(x=mapdata,var="pov",method="quantile",nclass=8,legend.title.txt="Poverty")
layoutLayer(title = "Poverty in Nepal by Districts",tabtitle = TRUE,scale = TRUE)

ggplot(data=mapdata)+geom_sf(aes(fill=pov),color="white")+
    scale_fill_viridis_c(option="viridis",trans="sqrt")+
    xlab("Longitude")+ylab("Latitude")+
    ggtitle("Poverty Rate of Nepal by Districts")

points<-cbind(mapdata,st_coordinates(st_centroid(mapdata$geometry)))



install.packages("ggthemes")


library(ggthemes) # used for changes background theme, title theme and others
ggplot(data = points) +
  geom_sf(aes(fill=pov), color="black", size=0.2) +
  scale_fill_viridis_c(option = "viridis", trans = "sqrt")+
  geom_text(data= points,aes(x=X, y=Y, label=paste(dist_name)),
            color = "darkblue", size=2.5, fontface = "italic", angle=0, vjust=-1, check_overlap = FALSE) +
  geom_text(data= points,aes(x=X, y=Y, label=paste(pov)),
            color = "white", size=2.0, fontface = "bold", angle=0, vjust=+1, check_overlap = FALSE) +
  ggtitle("Poverty Rate of Nepal by Districts")+xlab("Longitude")+ylab("Latitude")+
  
  theme(
    panel.background = element_rect(fill='lightblue', size=0.5,
                                    linetype=0, colour='lightblue'),
    plot.title = element_text(color="red", size=16, hjust=0.5, face="bold.italic"),
    axis.title.x = element_text(color="blue", size=10, face="bold"),
    axis.title.y = element_text(color="red", size=10, face="bold")
  )
ggsave("map.png",width=6,height=6,dpi='screen')
ggsave("map.pdf",width=6,height=6,dpi='screen')

