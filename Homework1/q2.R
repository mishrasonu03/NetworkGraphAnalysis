library("igraph")

## (a)
graph1 <- barabasi.game(1000, directed=FALSE)

# Degree distribution
hist(degree(graph1), breaks=50, main="Degree Distribution")

# Diameter
if(is.connected(graph1))
{
  print("Graph is connected")
  dia =diameter(graph1, directed = FALSE, unconnected = FALSE, weights = NULL)
  print(sprintf("Diameter of graph is: %d", dia))
} else{
  print("Graph is NOT connected")
  print("Diameter of graph is INFINITY")
}


## (b)
clust1 <- clusters(graph1)
gcc1 <- induced.subgraph(graph1, which(clust1$membership == which.max(clust1$csize)))
fg1 <- fastgreedy.community(gcc1)
print(max(fg1$modularity))


## (c)
graph2 <- barabasi.game(10000, directed=FALSE)
clust2 <- clusters(graph2)
gcc2 <- induced.subgraph(graph2, which(clust2$membership == which.max(clust2$csize)))
fg2 <- fastgreedy.community(gcc2)
print(max(fg2$modularity))


## (d)
i = floor(runif(1)*1000)
nbr_size <- ego_size(graph1, 1, i)
temp = ceiling(runif(1)*nbr_size)
nbr <- ego(graph1, 1, i)
j = as.integer(nbr[[1]][temp])
print(j)

nbrGraph <- graph.neighborhood(graph1, 1, j)
degrees <- degree(nbrGraph[[1]])
dev.new()
hist(degrees, breaks=seq(0, by=1, length.out=max(degrees)+5))