x <- read.csv("all2_sjis.csv", header=F, row.names=1, fileEncoding='cp932')
d <- dist(x)
clst <- hclust(d, method="ward.D")
png(file="cluster.png",width=1200,height=600)
names(windowsFonts()) 
windowsFonts(mincho=windowsFont("Japan1"))
par(family="mincho")
par(pin=c(14, 6))
plot (clst)
dev.off()
