library(igraph)

#1)
g = read.graph(file = "F:/Graduate Study/Third Term/EE232E Graph and Network Flows/HW3/sorted_directed_net.txt", format = "ncol", directed = T)
is_connected = is.connected(g)

g_comp = clusters(g)
gcc_index = which.max(g_comp$csize)
T_delete <- (1:vcount(g))[g_comp$membership != gcc_index]
max_g_c <- delete.vertices(g,T_delete)

#2)
degree_in = degree(max_g_c,mode = "in")
degree_out = degree(max_g_c,mode = "out")
hist(degree_in,xlab = "In-Degree",ylab = "Probability",breaks = 200,freq = FALSE,main = "")
hist(degree_out,xlab = "Out-Degree",ylab = "Probability",breaks = 200,freq = FALSE,main = "")
