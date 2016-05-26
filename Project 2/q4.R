library(igraph)
library(hash)

Sys.setlocale(locale="C")

actor_actress=list()
act_num=1
actors=readLines("/home/stone/Desktop/project2/project_2_data/actor_movies.txt")
actors_list=strsplit(actors,"[\t]+")

# merge data
for(i in 1:length(actors)){
    actor_actress[[act_num]]<-actors_list[[i]]
    act_num=act_num+1
}

actresses=readLines("/home/stone/Desktop/project2/project_2_data/actress_movies.txt")
actresses_list=strsplit(actresses,"[\t]+")

for(i in 1:length(actresses)){
    actor_actress[[act_num]]<-actresses_list[[i]]
    act_num=act_num+1
}

movie_act_list <- hash()
movie_id <- 1

for (i in 1:length(actor_actress))
{
  tmp_act <- actor_actress[[i]]
  len_tmp <- length(tmp_act)
  
  for (j in 2:len_tmp)
  {
    tmp_movie <- movie_act_list[[tmp_act[j]]]
    if (is.null(tmp_movie))
    {
      movie_act_list[tmp_act[j]] = c(movie_id,i)
      movie_id = movie_id + 1
    }
    else
    {
      movie_act_list[tmp_act[j]] = c(tmp_movie,i)
    }
  }
}

for (key in keys(movie_act_list))
{
  len_key <- length(movie_act_list[key])
  if (len_key<=6)
    del(key,movie_act_list)
}








