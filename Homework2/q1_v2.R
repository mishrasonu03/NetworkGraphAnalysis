library(igraph)
library(netrw)

myfunction <- function(graph,nodes,flag)
{
  tlim = min(nodes, 100);
  avg<-rep(NA, tlim)
  stdev<-rep(NA, tlim)
  variance<-rep(NA, tlim)
  
  r1<- netrw(graph, walker.num=nodes, start.node=1:vcount(graph), damping=1, T=tlim, output.walk.path=TRUE)
    
  for(t in (1:tlim))
  {
    sp <- rep(NA,nodes)
    for(j in (1:nodes))
    {
      a <-get.shortest.paths(graph, from=r1$walk.path[1,j], to=r1$walk.path[t,j])
      sp[j]<-length(a$vpath[[1]])-1
    }
    avg[t] = mean(sp)
    stdev[t] = sd(sp)
    variance[t] = var(sp)
  }

  # print(avg)
  # print(stdev)
  
  #plots
  dev.new()
  plot(1:tlim, avg, type="line", xlab="Number of Steps", ylab="Average")
  dev.new()
  plot(1:tlim, stdev, type="line", xlab="Number of Steps", ylab="Standard Deviation")
  dev.new()
  plot(1:tlim, variance, type="line", xlab="Number of Steps", ylab="Variance")

  #degreedistribution
  #part e
  if(flag==1){
    dev.new()
    hist(degree(graph),xlab="Degree",ylab="Frequency",main="Degree Distribution of the graph")
    degdist <- rep(NA,nodes)
    for(i in (1:nodes))
      degdist[i] = degree(graph,r1$walk.path[nodes,i])
    dev.new()
    hist(degdist,xlab="Degree",ylab="Frequency",main="Degree distribution of the nodes reached at the end of the random walk")  
  }
}

# #part 1.a)
# g1_1000 <- random.graph.game(1000, 0.01, directed=FALSE)

# #part 1.b)
# print(Sys.time())
# myfunction(g1_1000,1000,1) #1000 nodes
# print(Sys.time())

#part 1.d)
# print(Sys.time())

# g1_100 <- random.graph.game(100, 0.01, directed=FALSE)
# myfunction(g1_100,100,0) #100 nodes

print(Sys.time())

g1_10000<- random.graph.game(10000, 0.01, directed=FALSE)
myfunction(g1_10000,10000,0) #10000 nodes

print(Sys.time())
