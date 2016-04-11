library ("igraph")

#part a
numNodes <- 1000

g <- forest.fire.game (numNodes, fw.prob=0.37, bw.factor=0.32/0.37, ambs=1, TRUE)

g_in <- degree_distribution(g,mode="in")
g_out <- degree_distribution(g,mode="out")

hist_in <- hist(degree(g,mode="in"), breaks=seq(-0.5, by=1 , length.out=max(degree(g,mode="in"))+2), main="In Degree Distribution")
hist_out <- hist(degree(g,mode="out"), breaks=seq(-0.5, by=1 , length.out=max(degree(g,mode="out"))+2), main="Out Degree Distribution")

#part b

dia <- diameter(g, directed = TRUE, unconnected = TRUE, weights = NULL)
print(sprintf("Diameter is: %d",dia))

#part c
g_com <- infomap.community(g)
print(sprintf("Modularity is: %f",max(g_com$modularity)))

