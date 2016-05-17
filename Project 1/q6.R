#This is the R script for EE232E project 1 question 6.
library(igraph)
library(ggplot2)

g <- read.graph("~/Desktop/EE232/project1/facebook_combined.txt","ncol",directed = FALSE)
core_node = numeric(0)
deg_g = degree(g)

# Extract core node index
for (i in 1:length(deg_g))
{
  if (deg_g[i] > 200)
    core_node = c(core_node, i);
}

# Use modularity, density and cluster coefficient as the structural features in this project
mat_index <- matrix(list(), nrow = 1, ncol = length(core_node))
mat_modularity <- matrix(list(), nrow = 1, ncol = length(core_node))
mat_density <- matrix(list(), nrow = 1, ncol = length(core_node))
mat_cluster_coeff <- matrix(list(), nrow = 1, ncol = length(core_node))
mat_comm_size <- matrix(list(), nrow = 1, ncol = length(core_node))

# Calculate the required structral features
for (i in 1:length(core_node))
{
  neighbour_core = neighbors(g, core_node[i])
  subgraph_core = induced.subgraph(g, c(core_node[i], neighbour_core))
  community_core = fastgreedy.community(subgraph_core)
  
  index = numeric(0)
  modulc = numeric(0)
  dens = numeric(0)
  clus = numeric(0)
  csize = numeric(0)
  
  for (j in 1:length(community_core))
  {
    community_vertex = V(subgraph_core)[which(community_core$membership==j)]
    if (length(community_vertex > 10))
    {
      index = c(index, j)
      tmp_g = induced.subgraph(subgraph_core, V(subgraph_core)[which(community_core$membership==j)])
      tmp_com = fastgreedy.community(tmp_g)
      modulc = c(modulc, modularity(tmp_com))
      dens = c(dens, graph.density(tmp_g))
      clus = c(clus, transitivity(tmp_g,type = "global"))
      csize = c(csize, length(community_vertex) / length(V(subgraph_core)))
    }
  }
  mat_cluster_coeff[[1,i]] <- clus
  mat_density[[1,i]] <- dens
  mat_modularity[[1,i]] <- modulc
  mat_index[[1,i]] <- index
  mat_comm_size[[1,i]] <- csize
}

mat_dens_clus <- matrix(list(), nrow = 1, ncol = length(core_node))

for (i in 1:length(core_node))
{
  dens_clus = numeric(0)
  for (j in 1:length(mat_density[[1,i]]))
  {
    dens_clus = c(dens_clus, mat_density[[1,i]][j]*mat_cluster_coeff[[1,i]][j])
  }
  mat_dens_clus[[1,i]] <- dens_clus
}

mat_cluster_coeff[[2]][8] = 0;
mat_dens_clus[[2]][8] = 0;

max_den = numeric(0)
min_den = numeric(0)
max_den_index = numeric(0)
min_den_index = numeric(0)
max_clus = numeric(0)
min_clus = numeric(0)
max_clus_index = numeric(0)
min_clus_index = numeric(0)
max_den_clus = numeric(0)
min_den_clus = numeric(0)
max_den_clus_index = numeric(0)
min_den_clus_index = numeric(0)
max_modu = numeric(0)
max_modu_index = numeric(0)
max_csize = numeric(0)
max_csize_index = numeric(0)
min_csize = numeric(0)
min_csize_index = numeric(0)

# Calculate and store the min and max for the structral features.
for (i in 1:length(core_node))
{
  max_den = c(max_den, max(mat_density[[i]]))
  min_den = c(min_den, min(mat_density[[i]]))
  max_den_index = c(max_den_index, mat_index[[i]][which.max(mat_density[[i]])])
  min_den_index = c(min_den_index, mat_index[[i]][which.min(mat_density[[i]])])
  max_clus = c(max_clus, max(mat_cluster_coeff[[i]]))
  min_clus = c(min_clus, min(mat_cluster_coeff[[i]]))
  max_clus_index = c(max_clus_index, mat_index[[i]][which.max(mat_cluster_coeff[[i]])])
  min_clus_index = c(min_clus_index, mat_index[[i]][which.min(mat_cluster_coeff[[i]])])
  max_den_clus = c(max_den_clus, max(mat_dens_clus[[i]]))
  min_den_clus = c(min_den_clus, min(mat_dens_clus[[i]]))
  max_den_clus_index = c(max_den_clus_index, mat_index[[i]][which.max(mat_dens_clus[[i]])])
  min_den_clus_index = c(min_den_clus_index, mat_index[[i]][which.min(mat_dens_clus[[i]])])
  max_modu = c(max_modu, max(mat_modularity[[i]]))
  max_modu_index = c(max_modu_index, mat_index[[i]][which.max(mat_modularity[[i]])])
  max_csize = c(max_csize, max(mat_comm_size[[i]]))
  max_csize_index = c(max_csize_index, mat_index[[i]][which.max(mat_comm_size[[i]])])
  min_csize = c(min_csize, min(mat_comm_size[[i]]))
  min_csize_index = c(min_csize_index, mat_index[[i]][which.min(mat_comm_size[[i]])])
}

# Calculate the variance of the max and min for each feature
sqrt(var(max_den))
sqrt(var(max_clus))
sqrt(var(max_den_clus))
sqrt(var(max_csize))
sqrt(var(min_den))
sqrt(var(min_clus))
sqrt(var(min_den_clus))
sqrt(var(min_csize))
sqrt((var(max_modu)))

# Plot
plot(core_node, max_den, xlab = "Node Index", ylab = "Max Density")
plot(core_node, max_clus, xlab = "Node Index", ylab = "Max Cluster Coefficient")
plot(core_node, max_den_clus, xlab = "Node Index", ylab = "Max Density * Cluster Coefficient")
plot(core_node, max_csize, xlab = "Node Index", ylab = "Max Relative Community Size")
plot(core_node, min_den, xlab = "Node Index", ylab = "Min Density")
plot(core_node, min_clus, xlab = "Node Index", ylab = "Min Cluster Coefficient")
plot(core_node, min_den_clus, xlab = "Node Index", ylab = "Min Density * Cluster Coefficient")
plot(core_node, min_csize, xlab = "Node Index", ylab = "Min Relative Community Size")