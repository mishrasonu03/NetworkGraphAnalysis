library(igraph)
library(hash)

Sys.setlocale(locale="C")

ActID = readLines("E:/project2/project_2_data/Act_ID.txt")
g <- read.graph("E:/project2/project_2_data/edgelist_matrix.txt",format="ncol",directed=TRUE)
ANum2Name <- hash()

actorid_list=strsplit(ActID,"[\t]+")
for (i in 1:length(actorid_list))
{
  ANum2Name[actorid_list[[i]][1]] = actorid_list[[i]][2]
}

# PageRank
print("page rank...")
rank <- page.rank(g)$vector
rankIndex <- sort(rank,index.return=TRUE,decreasing=TRUE)
top10 <- rankIndex$ix[1:10]
print(actorid_list[top10+1])
