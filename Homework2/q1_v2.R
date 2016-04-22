source("findDistanceAggregates.R")

# 1.a)
g_1000 <- random.graph.game(1000, 0.01, directed=FALSE)

# 1.b)
findDistanceAggregates(g_1000, 1000, 1, 100, 10)

# 1.c) 
# Please check report

# 1.d)
g_100 <- random.graph.game(100, 0.01, directed=FALSE)
findDistanceAggregates(g_100, 100, 0, 500, 50)

g_10000<- random.graph.game(10000, 0.01, directed=FALSE)
findDistanceAggregates(g_10000, 10000, 0, 100, 1)

print(diameter(g_100))
print(diameter(g_1000))
print(diameter(g_10000))

# 1.e)
# it is getting done when 1.b calls the function findDistanceAggregates