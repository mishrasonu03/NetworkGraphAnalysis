library(igraph)
library(hash)

Sys.setlocale(locale="C")
currpath <- getwd()

g <- read.graph(paste(currpath,"/ee232/edgelist_matrix_movie.txt",sep=""),format="ncol",directed=FALSE)
fg <- fastgreedy.community(g,weights = E(g)$weight)

MovieID = readLines(paste(currpath,"/ee232/Movie_ID.txt",sep = ""))
Movie_genre = readLines(paste(currpath,"/ee232/movie_genre.txt",sep = ""))
Movie_genre_list = strsplit(Movie_genre,"[\t]+")
Movie_ID_list = strsplit(MovieID,"[\t]+")
Movie_genre_h <- hash()
Movie_ID <- hash()
Movie_Name2ID <- hash()


# Build the hash table for movie_genre
print("Build the hash table for movie_genre")
for (i in 1:length(Movie_genre))
{
  Movie_genre_h[Movie_genre_list[[i]][1]] = Movie_genre_list[[i]][2]
}

#Building the hash table for movie_id
print("Building the hash table for movie_genre")
for (i in 1:length(MovieID))
{
  Movie_ID[as.numeric(Movie_ID_list[[i]][1])] = Movie_ID_list[[i]][2]
}

for (i in 1:length(MovieID))
{
  Movie_Name2ID[Movie_ID_list[[i]][2]] = as.numeric(Movie_ID_list[[i]][1])
}

# Tag community with genre
print("Tag community with genre")
Cap_comm = length(fg)
Comm_tag = numeric(0)

for (i in 1:Cap_comm)
{
  print(i)
  sprintf("This is to tag ith Community %d with genres",i)
  Comm_vertices <- attributes(V(g)[fg$membership == i])$names
  genre_data <- vector(length = length(Comm_vertices))
  for (j in 1:length(Comm_vertices))
  {
    ix = Movie_ID[[toString(as.numeric(Comm_vertices[j]))]]
    tmp_genre = Movie_genre_h[[ix]]
    if (is.null(tmp_genre)==FALSE)
    {
      genre_data[j] = Movie_genre_h[[ix]]
    }
  }
  
  genre_data_frame <- as.data.frame(table(genre_data))
  genre_data_frame$Freq <- genre_data_frame$Freq/(sizes(fg)[i])
  print(genre_data_frame)
  
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

vertexes <- V(g)

for (i in 1:3)
{
  Name = Movie_Name2ID[[Movie_Add[i]]]
  Vertex_Index <- which(as.numeric(attributes(vertexes)$names)==Name)
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
  for (k in 1:5)
  {
    tmp_n = toString(as.numeric(attributes(top5n[k])$names))
    tmp_name = Movie_ID[[tmp_n]]
    print("Name")
    print(tmp_name)
    print("Community")
    index = which(as.numeric(attributes(vertexes)$names)==as.numeric(tmp_n))
    print(fg$membership[index])
  }
}

#q7)
Movie_rating_h <- hash()
Movie_Rating <- readLines(paste(currpath,"/ee232/movie_rating.txt",sep = ""))
Movie_Rating_list <- strsplit(Movie_Rating,"[\t]+")

for (i in 1:length(Movie_Rating))
{
  Movie_rating_h[Movie_Rating_list[[i]][1]] = Movie_Rating_list[[i]][2]
}

for (i in 1:3)
{
  Name = Movie_Name2ID[[Movie_Add[i]]]
  Vertex_Index <- which(as.numeric(attributes(vertexes)$names)==Name)
  Edge_ID <- incident(g,Vertex_Index)
  neig <- neighbors(g,Vertex_Index)
  
  num_neig = length(neig)
  if (num_neig>5)
  {
    edges_weight = E(g)[Edge_ID]$weight
    wsort_index = sort(edges_weight,index.return = TRUE,decreasing = TRUE)
    top5n_index = wsort_index$ix[1:5]
    
    top5n = as.numeric(attributes(neig[top5n_index])$names)
  }
  else
  {
    top5n = as.numeric(attributes(neig)$names)
  }
  
  sum = 0
  count = 0
  for (j in 1:4)
  {
    tmp_name = Movie_ID[[toString(top5n[j])]]
    tmp_rating_s = Movie_rating_h[[tmp_name]]
    if (is.null(tmp_rating_s)==FALSE)
    {
      sum = sum + as.numeric(tmp_rating_s)
      count = count + 1
    }
  }
  sprintf("The rating for movie %s is",Movie_Add[i])
  print(sum/count)
}



