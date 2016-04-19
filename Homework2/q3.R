library(igraph)
library(netrw)

#a)
#generate a graph
g_3_a <- random.graph.game(1000,0.01,directed = FALSE)
#random walk
randw_a = netrw(g_3_a, damping = 1, walker.num = 1000, T = 100, output.visit.prob = TRUE, output.nodes = (1:1000))
#degree of graph
deg_g_a = degree(g_3_a)
#visiting probability
pb_g_n_a = randw_a$ave.visit.prob
#relation
relation_a = cor(deg_g_a, pb_g_n_a)
cat("The relation between degree and pagerank for 3-a: ",relation_a)
plot(pb_g_n_a, xlab = "node", ylab = "probability", main="a")

#b)
#generate a graph
g_3_b <- random.graph.game(1000,0.01,directed = TRUE)
#random walk
randw_b = netrw(g_3_b, damping = 1, walker.num = 1000, T = 100, output.visit.prob = TRUE, output.nodes = (1:1000))
#degree of graph
deg_g_b = degree(g_3_b)
#visiting probability
pb_g_n_b = randw_b$ave.visit.prob
#relation
relation_b = cor(deg_g_b, pb_g_n_b)
cat("The relation between degree and pagerank for 3-b: ",relation_b)
plot(pb_g_n_b, xlab = "node", ylab = "probability", main = "b")

#c)
library(igraph)
library(netrw)

#generate a graph
g_3_c <- random.graph.game(1000,0.01,directed = FALSE)
#random walk
randw_c = netrw(g_3_c, damping = 0.85, walker.num = 1000, T = 100, output.visit.prob = TRUE, output.nodes = (1:1000))
#degree of graph
deg_g_c = degree(g_3_c)
#visiting probability
pb_g_n_c = randw_c$ave.visit.prob
#relation
relation_c = cor(deg_g_c, pb_g_n_c)
cat("The relation between degree and pagerank for 3-c: ",relation_c)
plot(pb_g_n_c, xlab = "node", ylab = "probability", main = "c")