library(igraph)
library(netrw)

findDistanceAggregates <- function(graph, nodes, flag, tlim, nround)  # pass tlim as an argument
{
  
  avg <- rep(NA, tlim)
  stdev <- rep(NA, tlim)
  variance <- rep(NA, tlim)
    
  for(t in (1:tlim)) {
    sdr <- array(NA,c(nround, nodes)) 
    for (r in (1:nround)) {
      rw <- netrw(graph, walker.num=nodes, start.node=1:vcount(graph), damping=1, T=t, output.walk.path=TRUE)
      for(j in (1:nodes)) {
        sp <- get.shortest.paths(graph, from=rw$walk.path[1,j], to=rw$walk.path[t,j])
        sdr[r,j] <- length(sp$vpath[[1]])-1
      }
    }
    avg[t] = mean(sdr)
    stdev[t] = sd(as.vector(sdr))
    variance[t] = var(as.vector(sdr))
  }
  # print(avg)
  # print(stdev)
  # print(variance)
  
  dev.new()
  plot(1:tlim, avg, type="l", xlab="Number of Steps", ylab="Average")
  dev.new()
  plot(1:tlim, stdev, type="l", xlab="Number of Steps", ylab="Standard Deviation")
  dev.new()
  plot(1:tlim, variance, type="l", xlab="Number of Steps", ylab="Variance")
  
  #1 e
  if(flag==1) {
    dev.new()
    hist(degree(graph), breaks=seq(0, by=1, length.out=25), freq=FALSE, xlab = "Degree", ylab = "Probability of Degree")
    rw <- netrw(graph, walker.num=nodes, start.node=1:vcount(graph), damping=1, T=tlim, output.walk.path=TRUE)
    degeesVector <- rep(NA,nodes)
    for(i in (1:nodes)) {
      # print(i)
      degeesVector[i] = degree(graph,rw$walk.path[tlim,i])
    }
    dev.new()
    hist(degeesVector, breaks=seq(0, by=1, length.out=25), xlab="Degree", freq= FALSE, ylab="Probability of Degrees")
  }
}