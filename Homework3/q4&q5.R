library(netrw)
source(file="computeMaxGraph.R")

#load file
filePath="E:/sorted_directed_net.txt"
gcc=maxGraph(read.graph(file=filePath,format="ncol"))

#4)

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
sub_comm <- c()
sub_modularity <- c()

comm_fast_gcc_index = which(sizes(comm_fast_gcc)>100)

for (i in 1:length(comm_fast_gcc_index))
{
  T_delete_tmp <- (1:vcount(und_gcc))[comm_fast_gcc$membership != comm_fast_gcc_index[i]]
  sub_graph[[i]] <- delete.vertices(und_gcc,T_delete_tmp)
  sub_comm[[i]] <- fastgreedy.community(sub_graph[[i]])
  barplot(sizes(sub_comm[[i]]),xlab = "Community Index",ylab = "Community Size")
  sub_modularity[[i]] <- modularity(sub_comm[[i]])  
}

cat("The modularity of each community whose size is larger than 100 is: ")
for (i in 1:length(comm_fast_gcc_index))
{
  print(sub_modularity[[i]])
}
