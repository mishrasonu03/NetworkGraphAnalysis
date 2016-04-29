library(netrw)
source(file="computeMaxGraph.R")

#load file
filePath="E:/sorted_directed_net.txt"
g=maxGraph(read.graph(file=filePath,format="ncol"))

#compute q3
g_undirected = as.undirected(g,mode="collapse",edge.attr.comb=list(weight=function(x) sprt(prod(x)),name="ignore"))
g_com = label.propagation.community(g_undirected)

#random walk
numNodes=vcount(g)
threshold=0.1
cnt=0
for(i in 1:numNodes)
{
  print(i)
  telprob=rep(0,numNodes)
  telprob[i]=1
  
  #default value of damping is 0.85
  rw<-netrw(g,walker.num=1,start.node=i,output.visit.prob=T,teleport.prob=telprob)
  prob = sort(rw$ave.visit.prob,decreasing=T,index.return=T)
  numCom=length(g_com)
  Mi=rep(0,numCom)
  
  for(j in 1:30)
  {
    mj=rep(0,numCom)
    maxj=prob$ix[j]
    mj[g_com$membership[maxj]]=1
    Mi=Mi+prob$x[j]*mj
  }
  
  #store nodes belonging to multiple communities
  if(length(which(Mi>threshold))>=2)
  {
    cnt=cnt+1;
    multiNode=c(i,Mi)
    if(cnt>1){
      listNode=rbind(listNode,multiNode)
    }
    else listNode=rbind(multiNode)
  }
}
print("Nodes with multiple communities:")
listNode