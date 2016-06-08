library(igraph)
library(hash)

Sys.setlocale(locale="C")

ActID = readLines("/home/rstudio/ee232/q8/Act_ID.txt")
g <- read.graph("/home/rstudio/ee232/q8/edgelist_matrix.txt",format="ncol",directed=TRUE)
ANum2Name <- hash()
Actor_rank <- hash()

actorid_list=strsplit(ActID,"[\t]+")
for (i in 1:length(actorid_list))
{
  ANum2Name[actorid_list[[i]][1]] = actorid_list[[i]][2]
}

# PageRank
print("page rank...")
rank <- page.rank(g)$vector
for (i in 1:length(rank))
{
  tmp_num = as.numeric(attributes(rank[i])$names)
  Actor_rank[tmp_num] = rank[[i]][1]
}