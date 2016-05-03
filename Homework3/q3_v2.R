library("igraph")

source("computeMaxGraph.R")

g_directed_11=maxGraph(read.graph(file="sorted_directed_net.txt",format="ncol",directed=T))


# Option 1
# Using label.propagation.community
g_undirected_1 <- as.undirected(g_directed_11, mode = "each")

community_1 <- label.propagation.community(g_undirected_1)
print(table(community_1$membership))
print(community_1$modularity)
print(mean(community_1$modularity))
print(max(community_1$modularity))
print(community_1$vcount)
print(community_1$algorithm)
# dev.new()
# plot(community_1, g_undirected_1, vertex.label=NA, vertex.size = 5)


# Option 2
# Using fast.greedy.community
g_undirected_2 <- as.undirected(g_directed_11, mode = "collapse", edge.attr.comb = list(weight = function(w) sqrt(prod(w))))

community_2 <- fastgreedy.community(g_undirected_2)
print(table(community_2$membership))
print(mean(community_2$modularity))
print(max(community_2$modularity))
print(community_2$vcount)
print(community_2$algorithm )
# dev.new()
# plot(community_2,g_undirected_2, vertex.label=NA, vertex.size = 5)

# Using label.propagation.community
community_3 <- label.propagation.community(g_undirected_2)
print(table(community_3$membership))
print(community_3$modularity)
print(mean(community_3$modularity))
print(max(community_3$modularity))
print(community_3$vcount)
print(community_3$algorithm)
# dev.new()
# plot(community_3, g_undirected_2, vertex.label=NA, vertex.size=5)