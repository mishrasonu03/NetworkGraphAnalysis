library(igraph)
library(netrw)

myfunction <- function(graph,nodes,damping_factor)
{
  avg<-rep(NA,nodes)
  stdev<-rep(NA,nodes)
  for(i in (1:nodes))
  {
    r1<- netrw(graph, walker.num=nodes, start.node=1:vcount(graph), damping=damping_factor, T=i, output.walk.path=TRUE)
    sp <- rep(NA,nodes)
    for(j in (1:nodes))
    {
      # cat(i," : ", j, "->")
      a <-get.shortest.paths(graph, from=r1$walk.path[1,j], to=r1$walk.path[i,j])
      sp[j]<-length(a$vpath[[1]])-1
    }
    avg[i] = mean(sp)
    stdev[i] = sd(sp) 
  }
  print(avg)
  print(stdev)
  
  #plots
  plot(1:nodes,avg,type="line",xlab="Number of Steps",ylab="Average")
  plot(1:nodes,stdev,type="line",xlab="Number of Steps",ylab="Standard Deviation")
  
  #degreedistribution
  #part e
  hist(degree(graph),xlab="Degree",ylab="Frequency",main="Degree Distribution of the graph")
  degdist <- rep(NA,nodes)
  for(i in (1:nodes))
    degdist[i] = degree(graph,r1$walk.path[nodes,i])
  hist(degdist,xlab="Degree",ylab="Frequency",main="Degree distribution of the nodes reached at the end of the random walk")
  
}
#part 1.a)
Sys.time()
g1_1000 <- random.graph.game(1000, 0.01, directed=FALSE)

#part 1.b)
myfunction(g1_1000,1000,1) #1000 nodes

#part 1.d)
g1_100 <- random.graph.game(100, 0.01, directed=FALSE)
myfunction(g1_100,100,1) #100 nodes

g1_10000<- random.graph.game(10000, 0.01, directed=FALSE)
myfunction(g1_10000,10000,1) #10000 nodes


#print Diameters for q1
print(diameter(g1_100))
print(diameter(g1_1000))

#part 1.e) is being calculated in the function

Sys.time()