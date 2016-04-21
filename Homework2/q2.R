source(file="findDistanceAggregates.R")

## a
g_a = barabasi.game(1000,directed=FALSE,power=-3)
diameter(g_a, directed = FALSE, unconnected = FALSE, weights = NULL)
g_degree=degree(g_a)
hist(g_degree, freq=FALSE, breaks=seq(0, by=1, length.out=max(g_degree)+10), xlab = "Degree", ylab = "Probability of Degree")

## b
findDistanceAggregates(g_a,1000,1,1000)

## d
g_d_1 = barabasi.game(100,directed=FALSE)
findDistanceAggregates(g_d_1,100,0,1000)

g_d_2 = barabasi.game(10000,directed=FALSE)
findDistanceAggregates(g_d_2,10000,0,1000)


#print Diameters for q1
print(diameter(g_d_1))
print(diameter(g_a))
print(diameter(g_d_2))

## e done in b
