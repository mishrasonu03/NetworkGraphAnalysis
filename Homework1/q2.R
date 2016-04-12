library("igraph")

## (a)
cat("Creating a random graph of 1K nodes...\n")
graph1 <- barabasi.game(1000, directed=FALSE)

# Degree distribution
# hist(degree(graph1), breaks=50, main="Degree Distribution")

cat("Plotting the degree distribution...\n")
deg_dist <- degree_distribution(graph1)
plot(1:length(deg_dist), deg_dist, "h", main="Degree Distribution", xlab = "Degree", ylab = "Probability of Degree")


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
gcc1 <- induced.subgraph(graph1, which(clust1$membership == which.max(clust1$csize)))
fg1 <- fastgreedy.community(gcc1)
print(sprintf("Modularity of the graph is: %f", max(fg1$modularity)))


## (c)
cat("Creating a random graph of 10K nodes...\n")
graph2 <- barabasi.game(10000, directed=FALSE)
# clust2 <- clusters(graph2)
# gcc2 <- induced.subgraph(graph2, which(clust2$membership == which.max(clust2$csize)))
fg2 <- fastgreedy.community(graph2)
print(sprintf("Modularity of the graph is: %f", max(fg2$modularity)))


## (d)
cat("Picking a node i at random...\n")
i = floor(runif(1)*1000)
nbr_size <- ego_size(graph1, 1, i)
temp = ceiling(runif(1)*nbr_size)
nbr <- ego(graph1, 1, i)
j = as.integer(nbr[[1]][temp])
print(sprintf("i = %d and j=%d", i, j))

nbrGraph <- graph.neighborhood(graph2, 1, j)
cat("Plotting the degree distribution of node j...\n")
deg_dist2 <- degree_distribution(nbrGraph[[1]])
dev.new()
# hist(degrees, breaks=seq(0, by=1, length.out=max(degrees)+5))
plot(1:length(deg_dist2), deg_dist2, "h", main="Degree Distribution of Node j", xlab = "Degree", ylab = "Probability of Degree")