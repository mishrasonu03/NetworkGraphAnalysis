library("igraph")

#a)
g_r <- aging.prefatt.game(1000,pa.exp = 1, aging.exp = -1, aging.bin = 1000, directed = FALSE)
g_r_d <- degree_distribution(g_r)
plot(1:length(g_r_d), g_r_d, "h", main="Random Graph Degree Distribution", xlab = "Degree", ylab = "Probability of Degree")

#b)
fc <- fastgreedy.community(g_r)
modularity(g_r, membership(fc))