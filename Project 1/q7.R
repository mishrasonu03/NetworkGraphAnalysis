library(igraph)
library(netrw)
library(ggplot2)

## read the graph
filePath = "E:/gplus/"
files_edge = list.files(path=filePath,pattern="edges")

user_graph_undirected={}
ego_users={}
user_graph={}
cnt=1


for(i in 1:length(files_edge)){
  nodeId=strsplit(files_edge[i],".edges")
  files_circle_path=paste(filePath,nodeId,".circles",sep="")
  files_circle=file(files_circle_path,open="r")
  lines=readLines(files_circle)
  if(length(lines)>0){
    #### pick two user to do the analysis since running all user is costly ###
    if(nodeId==100962871525684315897||nodeId==102615863344410467759){
      circles=list()
      for (j in 1:length(lines)) {
        tmp=strsplit(lines[j],"\t")
        circles[[j]]=tmp[[1]][-1]
      }
      if(length(lines)>2){
        
        edge_file_tmp=paste(filePath,files_edge[i],sep="")
        edge_graph=read.graph(edge_file_tmp,format="ncol",directed=TRUE)
        non_ego_users=V(edge_graph)
        ego_users[cnt]=nodeId
        user_graph[[cnt]]=add.vertices(edge_graph,1,name=nodeId)
        for(j in 1:length(V(edge_graph))){
          user_graph[[cnt]]=add.edges(user_graph[[cnt]],c(vcount(user_graph[[cnt]]),j))
        }
        #user_graph_undirected[[cnt]]=as.undirected(user_graph[[cnt]])
        comm1=walktrap.community(user_graph[[cnt]])
        comm2=infomap.community(user_graph[[cnt]])
        print("---------------------------------------------")
        print(nodeId[[1]])
        print(length(lines))
        print("using walktrap:")
        for(val in 1:max(comm1$membership)){
          nodes=vector()
          for(n in 1:length(comm1$membership)){
            if(comm1$membership[n]==val){
              nodes=c(nodes,comm1$name[n])
            }
          }
          overlap1=vector()
          for(n in 1:length(circles)){
            overlap1=c(overlap1,length(intersect(nodes,circles[[n]]))/length(circles[[n]]))
          }
          
          print(overlap1)
        }
        print("using infomap:")
        for(val in 1:max(comm2$membership)){
          nodes=vector()
          for(n in 1:length(comm2$membership)){
            if(comm2$membership[n]==val){
              nodes=c(nodes,comm2$name[n])
            }
          }
          overlap2=vector()
          for(n in 1:length(circles)){
            overlap2=c(overlap2,length(intersect(nodes,circles[[n]]))/length(circles[[n]]))
          }
          
          print(overlap2)
        }
    }
    
    }
  }
}