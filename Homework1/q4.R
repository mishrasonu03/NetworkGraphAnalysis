library ("igraph")

mod <- vector(mode="integer", length=10)

for(i in 1 : 10){
  #part a
  numNodes <- 1000
  
  g <- forest.fire.game (numNodes, fw.prob=0.37, bw.factor=0.32/0.37, ambs=1, TRUE)
  
  g_in <- degree_distribution(g,mode="in")
  g_out <- degree_distribution(g,mode="out")
  
  hist_in <- hist(degree(g,mode="in"), breaks=seq(-0.5, by=1 , length.out=max(degree(g,mode="in"))+2), main="In Degree Distribution",freq=FALSE,xlab = "Degree", ylab = "Probability of Degree")
  hist_out <- hist(degree(g,mode="out"), breaks=seq(-0.5, by=1 , length.out=max(degree(g,mode="out"))+2), main="Out Degree Distribution", freq=FALSE,xlab = "Degree", ylab = "Probability of Degree")
  
  #part b
  
  dia <- diameter(g, directed = TRUE, unconnected = TRUE, weights = NULL)
  print(sprintf("Diameter is: %d",dia))
  
  #part c
  wc <- cluster_walktrap(g)
  modularity(wc)
  print(sprintf("Modularity is: %f",modularity(wc)))
  #plot(wc, g)
  #g_com <- infomap.community(g)
  mod[i]=modularity(wc)
}
gg <- forest.fire.game (200, fw.prob=0.37, bw.factor=0.32/0.37, ambs=1, TRUE)
wc <- cluster_walktrap(gg)
plot(wc, gg,vertex.size=5,vertex.label=NA, layout=layout.fruchterman.reingold(gg),edge.arrow.size=0.2)

