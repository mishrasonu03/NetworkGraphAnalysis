library(igraph)

maxGraph<-function(g){
  is_connected = is.connected(g)
  if(!is_connected){
    g_comp = clusters(g)
    gcc_index = which.max(g_comp$csize)
    T_delete <- (1:vcount(g))[g_comp$membership != gcc_index]
    max_g_c <- delete.vertices(g,T_delete)
    return(max_g_c)
  }
  else return(g)
}

