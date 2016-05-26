library(igraph)
Sys.setlocale(locale="C")

actor_actress=list()
act_num=1
actors=readLines("E:/project2/project_2_data/actor_movies.txt")
actors_list=strsplit(actors,"[\t]+")

for(i in 1:length(actors)){
  if(length(actors_list[[i]])>=6){
    actor_actress[[act_num]]<-actors_list[[i]]
    act_num=act_num+1
  }
}

actresses=readLines("E:/project2/project_2_data/actress_movies.txt")
actresses_list=strsplit(actresses,"[\t]+")

for(i in 1:length(actresses)){
  if(length(actresses_list[[i]])>=6){
    actor_actress[[act_num]]<-actresses_list[[i]]
    act_num=act_num+1
  }
}