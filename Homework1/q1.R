
library("igraph")

###(a)

# create random networks
cat("Creating 3 random graphs of 1K nodes with p=0.01, 0.05 and 0.10...\n")
graph1 <- random.graph.game(1000, 0.01, directed=F);
graph2 <- random.graph.game(1000, 0.05, directed=F);
graph3 <- random.graph.game(1000, 0.10, directed=F);

# finding the degrees distribution
# deg_dist1 <- degree_distribution(graph1)
# deg_dist2 <- degree_distribution(graph2)
# deg_dist3 <- degree_distribution(graph3)

# cat("Plotting the degree distributions for each graph...\n")
# dev.new()
# plot(1:length(deg_dist1), deg_dist1, type="h", xlab = "Degree", ylab = "Probability of Degree")
# dev.new()
# plot(1:length(deg_dist2), deg_dist2, type="h", xlab = "Degree", ylab = "Probability of Degree")
# dev.new()
# plot(1:length(deg_dist3), deg_dist3, type="h", xlab = "Degree", ylab = "Probability of Degree")


degreesVector1 <- degree(graph1)
degreesVector2 <- degree(graph2)
degreesVector3 <- degree(graph3)

# plotting degree distributions
dev.new()
hist1 <- hist(degreesVector1, freq=FALSE, ylim=c(0, 0.15), breaks=seq(0, by=1, length.out=max(degreesVector1)+10), xlab = "Degree", ylab = "Probability of Degree")
dev.new()
hist2 <- hist(degreesVector2, freq=FALSE, ylim=c(0, 0.08), breaks=seq(0, by=1, length.out=max(degreesVector2)+10), xlab = "Degree", ylab = "Probability of Degree")
dev.new()
hist3 <- hist(degreesVector3, freq=FALSE, ylim=c(0, 0.05), breaks=seq(0, by=1, length.out=max(degreesVector3)+10), xlab = "Degree", ylab = "Probability of Degree")


###(b)
# cat('\n',"(b)",'\n')
cat("Checking connectivity of graph with p=0.01",'\n')
if(is.connected(graph1))
{
  print("Graph is connected")
  dia1 =diameter(graph1, directed = FALSE, unconnected = FALSE, weights = NULL)
  print(sprintf("Diameter of graph is: %d", dia1)) #5-6
} else{
  print("Graph is NOT connected")
  print("Diameter of graph is INFINITY")
}

cat("Checking connectivity of graph with p=0.05",'\n')
if(is.connected(graph2))
{
  print("Graph is connected.")
  dia2 =diameter(graph2, directed = FALSE, unconnected = FALSE, weights = NULL)
  print(sprintf("Diameter of graph is: %d", dia2)) #3
} else {
  print("Graph is NOT connected.")
  print("Diameter of graph is INFINITY")
}

cat("Checking connectivity of graph with p=0.10",'\n')
if(is.connected(graph3))
{
  print("Graph is connected.")
  dia3 =diameter(graph3, directed = FALSE, unconnected = FALSE, weights = NULL)
  print(sprintf("Diameter of graph is: %d", dia3)) #3
} else {
  print("Graph is NOT connected.")
  print("Diameter of graph is INFINITY")
}


###(c)
# cat('\n',"(c)",'\n')

LARGE_NUMBER = 1000
sum <- 0;
for (x in 1:LARGE_NUMBER){
  pc=0.000
  repeat
  {
    graph <- random.graph.game(1000, pc, directed=F);
    if(is.connected(graph))
    {
      # cat("The threshold probability, pc = ",pc,'\n')
      sum <- sum+pc
      break()
    } else
      pc <- pc+0.001
  }
}
cat("The threshold probability, pc = ",sum/LARGE_NUMBER,'\n')