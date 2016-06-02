library(igraph)
library(hash)

Sys.setlocale(locale="C")

g <- read.graph("E:/project2/project_2_data/edgelist_matrix_movie.txt",format="ncol",directed=FALSE)
fg <- fastgreedy.community(g,weights = E(g)$weight)

MovieID = readLines("E:/project2/project_2_data/Movie_ID.txt")
Movie_genre = reaLines("E:/project2/project_2_data/movie_genre.txt")
Movie_genre_list = strsplit(Movie_genre,"[\t]+")
Movie_ID_list = strsplit(Movie_ID,"[\t]+")
Movie_genre_h <- hash()
Movie_ID <- hash()


# Build the hash table for movie_genre
print("Build the hash table for movie_genre")
for (i in 1:length(Movie_genre))
{
  Movie_genre_h[Movie_genre_list[[i]][1]] = Movie_genre_list[[i]][2]
}

#Building the hash table for movie_id
print("Building the hash table for movie_genre")
for (i in 1:length(Movie_ID))
{
  Movie_ID[Movie_ID_list[[i]][1]] = Movie_ID_list[[i]][2]
}

# Tag community with genre
print("Tag community with genre")
Cap_comm = length(fg)
Comm_tag = numeric(0)

for (i in 1:Cap_comm)
{
  print("This is to tag ith Community with genres")
  Comm_vertices <- (1:vcount(g))[fg$membership == i]
  genre_data <- vector(length = length(Comm_vertices))
  for (j in 1:length(Comm_vertices))
  {
    genre_data[j] = Movie_genre_h[Movie_ID[Comm_vertices[j]]]
  }
  
  genre_data_frame <- as.data.frame(table(genre_data))
  genre_data_frame$Freq <- genre_data_frame$Freq/(sizes(fg)[j])
  
  genre_out <- genre_data_frame[which(genre_data_frame$Freq>=0.2),]
  genre_out_matrix <- as.matrix(genre_out)
  genre = genre_out_matrix[,1]
  print(genre)
}

#) q6
Movie_Add = vector(length = 3)
Movie_Add[1] = "Batman v Superman: Dawn of Justice (2016)"
Movie_Add[2] = "Mission: Impossible - Rogue Nation (2015)"
Movie_Add[3] = "Minions (2015)"

for (i in 1:3)
{
  vertexes <- V(g)
  Vertex_Index <- which(vertexes$name==Movie_Add[i])
  Edge_ID <- incident(g,Vertex_Index)
  neig <- neighbors(g,Vertex_Index)
  
  num_neig = length(neig)
  if (num_neig>5)
  {
    edges_weight = E(g)[Edge_ID]$weight
    wsort_index = sort(edges_weight,index.return = TRUE,decreasing = TRUE)
    top5n_index = wsort_index$ix[1:5]
    
    top5n = neig[top5n_index]
  }
  else
  {
    top5n = neig
  }
  
  sprintf("*** This is for adding node %s ***", Movie_Add[i])
  print("*** Top Nearest neighbours ***")
  print(Movie_ID[top5n])
  print("*** Top Nearest neighbour community ***")
  print(fg$membership[top5n])
}