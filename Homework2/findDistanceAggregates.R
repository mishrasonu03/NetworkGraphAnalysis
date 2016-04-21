library(igraph)
library(netrw)

findDistanceAggregates <- function(graph, nodes, flag)
{
  if (nodes >= 1000){
    tlim = min(nodes, 100);
  } else tlim = 1000;

  avg <- rep(NA, tlim)
  stdev <- rep(NA, tlim)
  variance <- rep(NA, tlim)
  
  rw <- netrw(graph, walker.num=nodes, start.node=1:vcount(graph), damping=1, T=tlim, output.walk.path=TRUE)
  
  for(t in (1:tlim)) {
    sd <- rep(NA,nodes)
    for(j in (1:nodes)) {
      sp <- get.shortest.paths(graph, from=rw$walk.path[1,j], to=rw$walk.path[t,j])
      sd[j] <- length(sp$vpath[[1]])-1
    }
    avg[t] = mean(sd)
    stdev[t] = sd(sd)
    variance[t] = var(sd)
  }
  
  print(avg)
  
  dev.new()
  plot(1:tlim, avg, type="line", xlab="Number of Steps", ylab="Average")
  dev.new()
  plot(1:tlim, stdev, type="line", xlab="Number of Steps", ylab="Standard Deviation")
  dev.new()
  plot(1:tlim, variance, type="line", xlab="Number of Steps", ylab="Variance")

  #1 e
  if(flag==1) {
    dev.new()
    hist(degree(graph), freq= FALSE, xlab="Degree", ylab="Frequency", main="Degree Distribution of graph")
    degeesVector <- rep(NA,nodes)
    for(i in (1:nodes)) {
      # print(i)
      degeesVector[i] = degree(graph,rw$walk.path[tlim,i])
    }
    dev.new()
    hist(degeesVector, xlab="Degree", freq= FALSE, ylab="Frequency", main="Degree distribution of nodes at the end of random walk")
  }
}