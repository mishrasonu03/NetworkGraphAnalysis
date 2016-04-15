library("igraph")

## (a)
cat("Creating a random graph of 1K nodes...\n")
graph1 <- barabasi.game(1000, directed=FALSE)

cat("Plotting the degree distribution...\n")
# deg_dist <- degree_distribution(graph1)
# plot(1:length(deg_dist), deg_dist, type="o", main="Degree Distribution", xlab = "Degree", ylab = "Probability of Degree")
dev.new()
deg_dist <- degree(graph1)
hist1 <- hist(deg_dist, freq=FALSE, breaks=seq(0, by=1, length.out=max(deg_dist)+10), xlab = "Degree", ylab = "Probability of Degree")


# Diameter
if(is.connected(graph1))
{
  print("Graph is connected")
  dia = diameter(graph1, directed = FALSE, unconnected = FALSE, weights = NULL)
  print(sprintf("Diameter of graph is: %d", dia))
} else{
  print("Graph is NOT connected")
  print("Diameter of graph is INFINITY")
}


## (b)
clust1 <- clusters(graph1)
# gcc1 <- induced.subgraph(graph1, which(clust1$membership == which.max(clust1$csize)))
gccIndex = which.max(clust1$csize)
nonGccNodes <- (1:vcount(graph1))[clust1$membership != gccIndex]
gcc1 <- delete.vertices(graph1, nonGccNodes)

fg1 <- fastgreedy.community(gcc1)
cmsize <- sizes(fg1)
cmsize <- as.vector(sizes(fg1))
gccNodes <- (1:vcount(graph1))[clust1$membership == gccIndex]
cm1Nodes <- gccNodes[fg1$membership == 1]

print(sprintf("Modularity of the graph is: %f", max(fg1$modularity)))


## (c)
cat("Creating a random graph of 10K nodes...\n")
graph2 <- barabasi.game(10000, directed=FALSE)
# clust2 <- clusters(graph2)
# gcc2 <- induced.subgraph(graph2, which(clust2$membership == which.max(clust2$csize)))
fg2 <- fastgreedy.community(graph2)
print(sprintf("Modularity of the graph is: %f", max(fg2$modularity)))


# (d)
cat("Picking a node i at random...\n")
LARGE_NUMBER = 1000;
degreej <- vector(mode="integer", length=LARGE_NUMBER)

for (x in 1:LARGE_NUMBER){
	i = floor(runif(1)*1000) + 1
	# nbr_size <- ego_size(graph1, 1, i)
	nbr_size <- ego_size(graph1, 1, i) - 1
	temp = ceiling(runif(1)*nbr_size)
	nbr <- ego(graph1, 1, i)
	# j = as.integer(nbr[[1]][temp])
	j = as.integer(nbr[[1]][temp + 1])
	degreej[x] <- degree(graph1, j)
}
# cat(degreej)
dev.new();
hist(degreej, ylim=c(0, 0.25), freq=FALSE, breaks=seq(0, by=1, length.out=50), main="Degree Distribution", xlab = "Degree", ylab = "Probability of Degree")