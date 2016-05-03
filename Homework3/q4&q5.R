library(igraph)

#4)
g = read.graph(file = "F:/Graduate Study/Third Term/EE232E Graph and Network Flows/HW3/sorted_directed_net.txt", format = "ncol", directed = T)
g_comp = clusters(g)
gcc_index = which.max(g_comp$csize)
T_delete <- (1:vcount(g))[g_comp$membership != gcc_index]
gcc <- delete.vertices(g,T_delete)

und_gcc <- as.undirected(gcc,mode = "collapse",edge.attr.comb = list(weight = function(w) sqrt(prod(w))))
comm_fast_gcc <- fastgreedy.community(und_gcc)
maxIndex <- which.max(sizes(comm_fast_gcc))
T_delete_sub <- (1:vcount(und_gcc))[comm_fast_gcc$membership != maxIndex]
max_sub <- delete.vertices(und_gcc,T_delete_sub)
max_sub_comm <- fastgreedy.community(max_sub)
max_sub_comm_size <- sizes(max_sub_comm)
modularity(max_sub_comm)
barplot(max_sub_comm_size,xlab = "Community Index",ylab = "Community Size")

#5)
sub_graph <- c()
sub_comm_fg <- c()
sub_comm_lab <- c()
sub_modularity_fg <- c()
sub_modularity_lab <- c()

comm_fast_gcc_index = which(sizes(comm_fast_gcc)>100)

for (i in 1:length(comm_fast_gcc_index))
{
  T_delete_tmp <- (1:vcount(und_gcc))[comm_fast_gcc$membership != comm_fast_gcc_index[i]]
  sub_graph[[i]] <- delete.vertices(und_gcc,T_delete_tmp)
  sub_comm_fg[[i]] <- fastgreedy.community(sub_graph[[i]])
  sub_comm_lab[[i]] <- label.propagation.community(sub_graph[[i]])
  barplot(sizes(sub_comm_fg[[i]]),xlab = "Community Index",ylab = "Community Size")
  print(sizes(sub_comm_fg[[i]]))
  barplot(sizes(sub_comm_lab[[i]]),xlab = "Community Index",ylab = "Community Size")
  print(sizes(sub_comm_lab[[i]]))
  sub_modularity_fg[[i]] <- modularity(sub_comm_fg[[i]])
  sub_modularity_lab[[i]] <- modularity(sub_comm_lab[[i]])
}

cat("The modularity of each community whose size is larger than 100 is: ")
print(sub_modularity_fg)
print(sub_modularity_lab)
