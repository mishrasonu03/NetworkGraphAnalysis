library("igraph")

inputPath = "facebook_combined.txt"
g = read.graph(file = inputPath, directed=FALSE)
V(g)$name = V(g)

print("Finding core nodes ...")
core_node_index = numeric(0)

for(i in 1: length(degree(g)))
{
    if(length(neighbors(g,i))>200)
    {   
        print(length(neighbors(g,i)))
        core_node_index = c(core_node_index, i)
    }
}

# Change this vector according to which core node personal networks you want to  analyze
total_embeddedness = numeric(0)
total_dispersion = numeric(0)
to_be_plotted = c(1, 4, 12)

for(i in 1:length(core_node_index))
{
    cat("\n\nAnalyzing the personal network of core node: ", i, "\n\n")

    embeddedness = numeric(0)
    core_friends = neighbors(g,core_node_index[i])
    personal_network = induced.subgraph(g,c(core_node_index[i],core_friends))
    dm = diameter(personal_network)

    print("Finding Embeddedness ...")
    for(j in 1:length(core_friends))
    {
        embeddedness = c(embeddedness, length(intersect( neighbors(g, core_node_index[i]),
                                                        neighbors(g, core_friends[j])
                                                      )
                                            )
                       )
    }
    
    print("Finding Dispersion ...")
    dispersion = numeric(0)
    num_inf = 0

    for(k in 1: length(core_friends))
    {
        print(k)
        mutual_friends = intersect(neighbors(g, core_node_index[i]), neighbors(g,core_friends[k]))

        print("Finding sub-graph for dispersion calculation ...")
        dispersion_calculation_graph = delete.vertices(personal_network,
                                      c(which( V(personal_network)$name==core_node_index[i] ),
                                        which( V(personal_network)$name==core_friends[k])
                                        )
                                      )
        
        shortest_path = numeric(0)
        distance = 0
        print("Finding shortest_path ...")
        for(m in 1:length(mutual_friends))
        {
            for(n in (m+1): length(mutual_friends))
            {
                # Approach 1: Using Distance metric in [1]
                s = which( V(dispersion_calculation_graph)$name==mutual_friends[m] )
                t = which( V(dispersion_calculation_graph)$name==mutual_friends[n] )
                mF = intersect(neighbors(dispersion_calculation_graph, s), neighbors(dispersion_calculation_graph, t))

                if( !are.connected(dispersion_calculation_graph, s, t) && length(mF) == 0)
                {
                    distance = distance + 1
                }

                # Approach 2: Using Shortest Path distance
                # sp = shortest.paths( dispersion_calculation_graph, 
                #                               which( V(dispersion_calculation_graph)$name==mutual_friends[m] ),
                #                               which( V(dispersion_calculation_graph)$name==mutual_friends[n] )          
                #                        )                
                # if(sum(sp) > 0)
                # {
                #     if(sp==Inf && !is.na(mutual_friends[n]) )
                #     {
                #         # print (1)
                #         num_inf = 1 + num_inf
                #         sp = dm + 1
                #     }
                # }                
                # shortest_path = c(shortest_path, sp)
            }
        }
        dispersion = c(dispersion, distance) # Approach 1
        # dispersion = c(dispersion, sum(shortest_path)) # Approach 2        
    }

    print("Doing final calculations ...")
    # dispersion[which(dispersion ==Inf)]=0 # Uncoment this when using Appraoch 2
    total_embeddedness = c(total_embeddedness, embeddedness)
    total_dispersion = c(total_dispersion, dispersion)
    maximum_dispersion = which.max(dispersion)
    maximum_dispersion_node = core_friends[maximum_dispersion]
    maximum_embeddedness = which.max(embeddedness)
    maximum_embeddedness_node = core_friends[maximum_embeddedness]
    maximum_ratio = which.max(dispersion*(1/embeddedness))
    maximum_ratio_node = core_friends[maximum_ratio]


    if (i %in% to_be_plotted)
    {
        print("Plotting the personal network ...")
        core_community = walktrap.community(personal_network)

        color_vec_ratio = core_community$membership+1
        color_vec_embed = core_community$membership+1
        color_vec_dispr = core_community$membership+1

        size_vec_ratio = rep(3, length(color_vec_ratio))
        size_vec_embed = rep(3, length(color_vec_embed))
        size_vec_dispr = rep(3, length(color_vec_dispr))

        # color_vec_ratio [which(V(personal_network)$name==maximum_ratio_node)] = 0
        # color_vec_embed [which(V(personal_network)$name==maximum_embeddedness_node)] = 0
        # color_vec_dispr [which(V(personal_network)$name==maximum_dispersion_node)] = 0

        size_vec_ratio [which(V(personal_network)$name==maximum_ratio_node)] = 8
        size_vec_embed [which(V(personal_network)$name==maximum_embeddedness_node)] = 8
        size_vec_dispr [which(V(personal_network)$name==maximum_dispersion_node)] = 8

        color_vec_ratio[which(V(personal_network)$name==core_node_index[i])] = 0
        color_vec_embed[which(V(personal_network)$name==core_node_index[i])] = 0
        color_vec_dispr[which(V(personal_network)$name==core_node_index[i])] = 0

        size_vec_ratio[which(V(personal_network)$name==core_node_index[i])] = 10
        size_vec_embed[which(V(personal_network)$name==core_node_index[i])] = 10
        size_vec_dispr[which(V(personal_network)$name==core_node_index[i])] = 10

        E(personal_network)$color = "grey"
        E(personal_network,P = c(which(V(personal_network)$name==maximum_embeddedness_node),  which(V(personal_network)$name==core_node_index[i])))$color = "green"
        E(personal_network,P = c(which(V(personal_network)$name==maximum_embeddedness_node),  which(V(personal_network)$name==core_node_index[i])))$width = 10
        set.seed(1)
        dev.new()
        plot(personal_network, vertex.color=color_vec_embed, vertex.label=NA, vertex.size=size_vec_embed)

        E(personal_network)$color = "grey"
        E(personal_network,P = c(which(V(personal_network)$name==maximum_dispersion_node),  which(V(personal_network)$name==core_node_index[i])))$color = "blue"
        E(personal_network,P = c(which(V(personal_network)$name==maximum_dispersion_node),  which(V(personal_network)$name==core_node_index[i])))$width = 10
        set.seed(1)
        dev.new()
        plot(personal_network, vertex.color=color_vec_dispr, vertex.label=NA, vertex.size=size_vec_dispr)

        E(personal_network)$color = "grey"
        E(personal_network,P = c(which(V(personal_network)$name==maximum_ratio_node),  which(V(personal_network)$name==core_node_index[i])))$color = "red"
        E(personal_network,P = c(which(V(personal_network)$name==maximum_ratio_node),  which(V(personal_network)$name==core_node_index[i])))$width = 10
        set.seed(1)
        dev.new()
        plot(personal_network, vertex.color=color_vec_ratio, vertex.label=NA, vertex.size=size_vec_ratio)

    }
    
}

print("Final Plots ...")
dev.new()
hist(total_embeddedness, breaks=50, main = "Distribution of Embeddedness",xlab = "Embeddedness", col="cyan")
dev.new()
hist(total_dispersion, breaks = 100, main = "Distribution of Dispersion ", xlab = "Dispersion", col="blue")