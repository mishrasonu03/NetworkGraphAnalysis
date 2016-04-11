library("igraph")

#a)
cat("Create a random graph by simulating its evolution...")
g_r <- aging.prefatt.game(1000,pa.exp = 1, aging.exp = -1, aging.bin = 1000, directed = FALSE)
g_r_d <- degree_distribution(g_r)
cat("Plot degree distribution...")
plot(1:length(g_r_d), g_r_d, "h", main="Random Graph Degree Distribution", xlab = "Degree", ylab = "Probability of Degree")

#b)
cat("Fast greedy method to find the community structure...")
fc <- fastgreedy.community(g_r)
cat("Modularity= ")
modularity(g_r, membership(fc))
