library(igraph)
library(hash)

load("/home/stone/Desktop/project2/project_2_data/data_cleaned.RData")

len_all = length(actor_actress)
Movie2Actor_h <- hash()
Edge_h <- hash()
MNum2Name <- hash()
ANum2Name <- hash()
num_movie_act <- numeric(0)
Act_ID = 1
Movie_ID = 1

print("hashing process...")
for (i in 1:len_all)
{
  tmpline <- actor_actress[[i]]
  len_tmp <- length(tmpline)
  num_movie_act = c(num_movie_act,length(tmpline)-1)
  tmp_act <- tmpline[1]
  ANum2Name[Act_ID] = tmp_act
  
  if (i%%10000==0)
    print(i)
  
  for (j in 2:len_tmp)
  {
    tmp_hash = Movie2Actor_h[[tmpline[j]]]
    
    if (is.null(tmp_hash))
    {
      Movie2Actor_h[tmpline[j]] = c(Movie_ID,Act_ID)
      MNum2Name[Movie_ID] = tmpline[j] 
      Movie_ID = Movie_ID + 1
    }
    else
    {
      Movie2Actor_h[tmpline[j]] = c(tmp_hash,Act_ID)
    }
  } 
  Act_ID <- Act_ID + 1
}

print("creating edgelist")
value_m <- values(Movie2Actor_h)
for (i in 1:length(value_m))
{
  if (i%%10000==0)
    print(i)
  if (length(value_m[[i]])<=2)
    next
  for (j in 2:(length(value_m[[i]])-1))
  {
    for (k in (j+1):length(value_m[[i]]))
    {
      tmp_edge = paste(value_m[[i]][j],value_m[[i]][k],sep = "\t")
      tmp_num <- Edge_h[[tmp_edge]]
      if (is.null(tmp_num))
      {
        Edge_h[tmp_edge] = 1
      }
      else
      {
        Edge_h[tmp_edge] = tmp_num + 1
      }
    }
  }
}

edgelist <- matrix(nrow = length(Edge_h)*2, ncol = 3)
index <- 1

for (ekey in keys(Edge_h))
{
  ENum <- Edge_h[ekey]
  sep <- strsplit(ekey,"\t")
  vertex_1 <- strtoi(sep[[1]][1])
  vertex_2 <- strtoi(sep[[1]][2])
  
  weight_1 <- ENum / num_movie_act[vertex_1]
  weight_2 <- ENum / num_movie_act[vertex_2]
  edgelist[index,1] = vertex_1
  edgelist[index,2] = vertex_2
  edgelist[index,3] = weight_1
  index <- index + 1
  edgelist[index,1] = vertex_2
  edgelist[index,2] = vertex_1
  edgelist[index,3] = weight_2
  index <- index +1
}

# construct the graph
print("construct the graph...")
g <- graph_from_edgelist(edgelist[,1:2],directed = TRUE)
E(g)$weight <- edgelist[,3]

# PageRank
print("page rank...")
rank <- page.rank(g)$vector
rankIndex <- sort(rank,index.return=TRUE,decreasing=TRUE)
top10 <- rankIndex$ix[1:10]
print(ANum2Name[top10])







