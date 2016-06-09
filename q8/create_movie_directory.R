library(hash)

Sys.setlocale(locale="C")

director = readLines("/home/rstudio/ee232/q8/director_movies_cleaned.txt")
topmovie = readLines("/home/rstudio/ee232/q8/top100.txt")
load("/home/rstudio/ee232/actor_filter_movie_filter.RData")
load("/home/rstudio/ee232/pagerank_data.rdata")
Movie2Director <- hash()
Director2Num <- hash()

director_list = strsplit(director,"[\t]+")
for (i in 1:length(director_list))
{
  tmpline = director_list[[i]]
  if (length(tmpline)>1)
  {
    for (j in 2:length(tmpline))
    {
      tmpline[j] = gsub(pattern = "(\\([0-9][0-9][0-9][0-9].*?\\)).*$",replacement = "\\1",tmpline[j])
      tmpline[j] = gsub(pattern = "(\\(\\?\\?\\?\\?.*?\\)).*$",replacement = "\\1",tmpline[j])
    }
    director_list[[i]] = tmpline
  }
}

for (i in 1:length(director_list))
{
  tmpline = director_list[[i]]
  if (length(tmpline)>1)
  {
    for (j in 2:length(tmpline))
    {
      tmp_d = Movie2Director[[tmpline[j]]]
      if (is.null(tmp_d))
      {
        Movie2Director[tmpline[j]] = c(tmpline[1])
      }
      else
      {
        tmp = Movie2Director[[tmpline[j]]]
        Movie2Director[tmpline[j]] = c(tmp,tmpline[1])
      }
    }
  }
}

# Generate top directors
topdirector = c()
for (i in 1:100)
{
  tmp = Movie2Director[[topmovie[i]]]
  if (is.null(tmp)==FALSE)
  {
    for (j in 1:length(tmp))
    {
      topdirector = c(topdirector,tmp[j])
    }
  }
}

top_director_h <- hash()
for (i in 1:length(topdirector))
{
  top_director_h[topdirector[i]] = TRUE
}

#) Generating Actor list
ActorID = readLines("/home/rstudio/ee232/Act_ID.txt")
ActorID_h <- hash()
ActorID_list = strsplit(ActorID,"[\t]+")

for (i in 1:length(ActorID))
{
  ActorID_h[ActorID_list[[i]][1]] = ActorID_list[[i]][2]
}

#) Generating hash for rank
Actor2Rank <- hash()
for (i in 1:length(rank))
{
  name = as.numeric(attributes(rank[i])$names) + 1
  Actor2Rank[name] = rank[[i]][1]
}

#) Calculating mean genre ratings
Movie_Rating = readLines("/home/rstudio/ee232/movie_rating.txt")
Movie_Rating_list = strsplit(Movie_Rating,"[\t]+")
Movie_Rating_h <- hash()

##) Generate intersection movies
Movie_Inter <- hash()
for (i in 1:length(MovieID))
{
    Movie_name = Movie_ID_list[[i]][2]
    tmp_1 = Movie_Rating_h[[Movie_name]]
    tmp_2 = Movie_genre_h[[Movie_name]]
    
    if ((is.null(tmp_1)==FALSE)&&(is.null(tmp_2)==FALSE))
    {
      Movie_Inter[Movie_ID_list[[i]][1]] = Movie_ID_list[[i]][2]
    }
}

##) Generating Movie Rating hash
for (i in 1:length(Movie_Rating))
{
  Movie_Rating_h[Movie_Rating_list[[i]][1]] = as.numeric(Movie_Rating_list[[i]][2])
}

genre_rating <- hash()
Movie_Inter_list = names(Movie_Inter)
for (i in 1:length(Movie_Inter))
{
  mnum = Movie_Inter_list[i]
  mname = Movie_ID[[mnum]]
  rating = Movie_Rating_h[[mname]]
  
  genre = genre_rating[[Movie_genre_h[[mname]]]]
  if (is.null(genre))
  {
    genre_rating[Movie_genre_h[[mname]]] = rating
  }
  else
  {
    tmp_rating = genre_rating[[Movie_genre_h[[mname]]]] + rating
    genre_rating[Movie_genre_h[[mname]]] = tmp_rating
  }
}

genre_rating_n <- hash()
for (i in 1:length(Movie_Inter))
{
  mnum = Movie_Inter_list[i]
  mname = Movie_ID[[mnum]]
  genre = genre_rating_n[[Movie_genre_h[[mname]]]]
  if (is.null(genre))
  {
    genre_rating_n[Movie_genre_h[[mname]]] = 1
  }
  else
  {
    tmp_n = genre_rating_n[[Movie_genre_h[[mname]]]] + 1
    genre_rating_n[Movie_genre_h[[mname]]] = tmp_n
  }
}

##) Generate mean rating for each genre
Genre_names = names(genre_rating)
genre_rating_m <- hash()
for (i in 1:length(genre_rating))
{
  rating = genre_rating[[Genre_names[i]]] / genre_rating_n[[Genre_names[i]]]
  genre_rating_m[[Genre_names[i]]] = rating
}

#) Generate top 5 pagerank
Movie2Actor = readLines("/home/rstudio/ee232/movie2actor.txt")
Movie2Actor_list = strsplit(Movie2Actor,"[\t]+")
Movie_pagerank_top5 <- hash()

#) Generate Movie to Actor hash
Movie2Actor_h <- hash()
for (i in 1:length(Movie2Actor_list))
{
  value = c()
  for (j in 2:length(Movie2Actor_list[[i]]))
  {
    value = c(value,Movie2Actor_list[[i]][j])
  }
  Movie2Actor_h[Movie2Actor_list[[i]][1]] = value
}

#) Generate top5 pagerank for each movie
Movie_pagerank_top5 <- hash()
for (i in 1:length(Movie_Inter_list))
{
  tmp_n = Movie_Inter_list[i]
  tmp_m = Movie_ID[[tmp_n]]
  value = c()
  name = Movie2Actor_h[[tmp_m]]
  
  for (j in 1:length(name))
  {
    value = c(value,Actor2Rank[[name[j]]])
  }
  value_sort = sort(value,decreasing = TRUE)
  Movie_pagerank_top5[tmp_m] = value_sort[1:5]
}

#) Generate features in the form of dataframe
v1 <- c()
v2 <- c()
v3 <- c()
v4 <- c()
v5 <- c()
d <- c()
g <- c()
r <- c()
d <- c()

for (i in 1:length(Movie_Inter_list))
{
  if (i%%1000==0)
    print(i)
  tmp_n = Movie_Inter_list[i]
  tmp_m = Movie_ID[[tmp_n]]
  
  tmp_d = Movie2Director[[tmp_m]]
  if (is.null(tmp_d)==FALSE)
  {
    value = Movie_pagerank_top5[[tmp_m]]*100000
    v1 = c(v1,value[1])
    v2 = c(v2,value[2])
    v3 = c(v3,value[3])
    v4 = c(v4,value[4])
    v5 = c(v5,value[5])
    r = c(r,Movie_Rating_h[[tmp_m]])
    tmp_g = Movie_genre_h[[tmp_m]]
    g = c(g,genre_rating_m[[tmp_g]])
    
    d_temp <- match(topdirector, tmp_d)
    d_temp <- d_temp/d_temp
    d_temp[is.na(d_temp)] <- 0
    if (sum(d_temp) == 0)
      d = c(d, d_temp, 1)
    else{
      d = c(d, d_temp, 0)
    }
    
    # flag = 0
    # for (j in 1:length(topdirector))
    # {
    #   index = match(topdirector[j],tmp_d)
    #   if (is.na(index))
    #   {
    #     d = c(d,0)
    #   }
    #   else
    #   {
    #     d = c(d,1)
    #     flag = 1
    #   }
    # }
    # if (flag==0)
    #   d = c(d,1)
    # else
    #   d = c(d,0)
  }
}

mat_d = matrix(d,nrow = (length(topdirector)+1),ncol = length(v1))
mat_d_t = t(mat_d)



regre_data = data.frame(v1,v2,v3,v4,v5,g,r)
regre_d = data.frame(mat_d_t)
write.csv(regre_data,"/home/rstudio/ee232/regre_data.csv")
write.csv(regre_d,"/home/rstudio/ee232/regre_d.csv")
