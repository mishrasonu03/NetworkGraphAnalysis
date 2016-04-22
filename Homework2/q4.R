library(igraph)
library(netrw)

#a)
#generate a graph
g_4_a <- random.graph.game(1000,0.01,directed = TRUE)
#random walka
randw_a = netrw(g_4_a, damping = 0.85, walker.num = 1000, T = 100, output.visit.prob = TRUE, output.nodes = (1:1000))
#degree of graph
deg_g_a = degree(g_4_a, mode = "in")
#visiting probability
pb_g_n_a = randw_a$ave.visit.prob
#relation
relation_a = cor(deg_g_a, pb_g_n_a)
cat("The relation between degree and pagerank for a: ",relation_a)
plot(pb_g_n_a, xlab = "node", ylab = "Rank scores")
plot(deg_g_a,pb_g_n_a, xlab = "degree", ylab = "Rank scores")
variance_a <- var(pb_g_n_a)

#b)
#generate a graph
g_4_b <- random.graph.game(1000,0.01,directed = TRUE)
#random walk
randw_b <- netrw(g_4_b, damping = 0.85, walker.num = 1000, T = 100, output.visit.prob = TRUE, output.nodes = (1:1000))
#degree of graph
deg_g_b <- degree(g_4_b, mode = "in")
#generate teleport probability
pagerank <- randw_b$ave.visit.prob
randw_per <- netrw(g_4_b, damping = 0.85, walker.num = 1000, T = 100, output.visit.prob = TRUE, output.nodes = (1:1000), teleport.prob = pagerank)
#relation
pb_gn_per = randw_per$ave.visit.prob

relation_b <- cor(deg_g_b, pb_gn_per)
cat("The relation between degree and pagerank for b: ",relation_b)
plot(pb_gn_per, xlab = "node", ylab = "Rank scores")
plot(deg_g_b,pb_gn_per, xlab = "degree", ylab = "Rank scores")
variance_b <- var(pb_gn_per)