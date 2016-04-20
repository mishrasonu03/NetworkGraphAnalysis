library(igraph)
library(netrw)

func=function(g,num_nodes,flag)
{
  ## store average distances
  average<-rep(NA,num_nodes)
  ## store variance of distances
  variance<-rep(NA,num_nodes)
  for(i in (1:num_nodes))
  {
    net<-netrw(g, walker.num=num_nodes,start.node=1:vcount(g), T=i, damping=1, output.walk.path=TRUE)
    ## store distances
    dis<-rep(NA,num_nodes)
    for(j in (1:num_nodes))
    {
      node1<-net$walk.path[1,j]
      node2<-net$walk.path[i,j]
      min_dis<-get.shortest.paths(g, from=node1, to=node2)
      dis[j]<-length(min_dis$vpath[[1]])-1
    }
    average[i] = mean(dis)
    variance[i] = var(dis)
  }
  print(variance)
  plot(1:num_nodes,average,type="line",xlab="Number of Steps",ylab="Average")
  plot(1:num_nodes,variance,type="line",xlab="Number of Steps",ylab="Variance")
  
  if(flag==1){
    hist(degree(g),xlab="Degree",ylab="Frequency")
    d <- rep(NA,num_nodes)
    for(i in (1:num_nodes))
      d[i] = degree(g,net$walk.path[num_nodes,i])
    hist(d,xlab="Degree",ylab="Frequency")
  }
  
}

## a
g_a = barabasi.game(1000,directed=FALSE)

## b
func(g_a,1000,1)

## d
g_d_1 = barabasi.game(100,directed=FALSE)
func(g_d_1,100,0)

g_d_2 = barabasi.game(10000,directed=FALSE)
func(g_d_2,10000,0)


#print Diameters for q1
print(diameter(g_d_1))
print(diameter(g_d_2))

## e done in b