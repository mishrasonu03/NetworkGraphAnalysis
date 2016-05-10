#This is the source code for project1 question1-4
library(igraph)
library(ggplot2)

#1)
g <- read.graph("~/Desktop/EE232/project1/facebook_combined.txt","ncol",directed = FALSE)
isconn = is.connected(g)
d = diameter(g)
deg_dis = degree.distribution(g)
plot(deg_dis,type = "h",xlab = "Degree",ylab = "Proportion")

dat = data.frame(x = 1:length(deg_dis), y = deg_dis)
#reference to http://stackoverflow.com/questions/14190883/fitting-a-curve-to-specific-data
models <- list(lm(deg_dis ~ x, data = dat), 
               lm(deg_dis ~ I(1/x), data = dat),
               lm(deg_dis ~ log(x), data = dat),
               nls(deg_dis ~ I(1/x*a) + b*x, data = dat, start = list(a = 1, b = 1)), 
               nls(deg_dis ~ (a + b*log(x)), data=dat, start = setNames(coef(lm(y ~ log(x), data=dat)), c("a", "b"))),
               nls(deg_dis ~ I(exp(1)^(a + b * x)), data=dat, start = list(a=0,b=0)),
               nls(deg_dis ~ I(1/x*a)+b, data=dat, start = list(a=1,b=1))
)

ggplot(dat, aes(x, y)) + geom_point(size = 2) +
  stat_smooth(method = "lm", formula = as.formula(models[[1]]), size = 1, se = FALSE, colour = "black") + 
  stat_smooth(method = "lm", formula = as.formula(models[[2]]), size = 1, se = FALSE, colour = "blue") + 
  stat_smooth(method = "lm", formula = as.formula(models[[3]]), size = 1, se = FALSE, colour = "yellow") + 
  stat_smooth(method = "nls", formula = as.formula(models[[4]]), data=dat, method.args = list(start = list(a=0,b=0)), size = 1, se = FALSE, colour = "red") + 
  stat_smooth(method = "nls", formula = as.formula(models[[5]]), data=dat, method.args = list(start = setNames(coef(lm(deg_dis ~ log(x), data=dat)), c("a", "b"))), size = 1, se = FALSE, colour = "green") +
  stat_smooth(method = "nls", formula = as.formula(models[[6]]), data=dat, method.args = list(start = list(a=0,b=0)), size = 1, se = FALSE, colour = "violet") +
  stat_smooth(method = "nls", formula = as.formula(models[[7]]), data=dat, method.args = list(start = list(a=0,b=0)), size = 1, se = FALSE, colour = "orange")

dat2 = data.frame(x = 1:length(deg_dis),y = exp(1)^(-3.66+-0.026*(1:length(deg_dis))))
mse = sum((dat2$y-dat$y)^2)/length(deg_dis)
mean_degree = mean(degree(g))

#2)
#Reference http://www.inside-r.org/packages/cran/igraph/docs/subgraph
sub_g = induced.subgraph(g,c(1,neighbors(g,1)))
plot(sub_g,vertex.label = NA,vertex.size = 4)
num_v = vcount(sub_g)
num_e = ecount(sub_g)

#3)
vertex_200 = c()
degree_200 = 0
for (i in 1:length(V(g)))
{
  if (length(neighbors(g,i))>200)
  {
    vertex_200 = c(vertex_200, i)
    degree_200 = degree_200 + length(neighbors(g,i))
  }
}

avg = degree_200 / length(vertex_200)

sub_g_3 = induced.subgraph(g,c(vertex_200[3],neighbors(g,vertex_200[3])))
#fast greedy
fg = fastgreedy.community(sub_g_3)
plot(sub_g_3,vertex.label=NA,vertex.color=fg$membership+1,vertex.size=3)
plot(fg,sub_g_3,vertex.label=NA,vertex.color=fg$membership+1,vertex.size=3)

#Edge betweenness
eb = edge.betweenness.community(sub_g_3)
plot(sub_g_3,vertex.label=NA,vertex.color=eb$membership+1,vertex.size=3)
plot(eb,sub_g_3,vertex.label=NA,vertex.color=eb$membership+1,vertex.size=3)

#infomap
im = infomap.community(sub_g_3)
plot(sub_g_3,vertex.label=NA,vertex.color=im$membership+1,vertex.size=3)
plot(im,sub_g_3,vertex.label=NA,vertex.color=im$membership+1,vertex.size=3)

#4
sub_g_3_r = induced.subgraph(g,neighbors(g,vertex_200[3]))
#fast greedy
fg_r = fastgreedy.community(sub_g_3_r)
plot(sub_g_3_r,vertex.label=NA,vertex.color=fg_r$membership+1,vertex.size=3)
plot(fg_r,sub_g_3_r,vertex.label=NA,vertex.color=fg_r$membership+1,vertex.size=3)

#Edge betweenness
eb_r = edge.betweenness.community(sub_g_3_r)
plot(sub_g_3_r,vertex.label=NA,vertex.color=eb_r$membership+1,vertex.size=3)
plot(eb_r,sub_g_3_r,vertex.label=NA,vertex.color=eb_r$membership+1,vertex.size=3)

#infomap
im_r = infomap.community(sub_g_3_r)
plot(sub_g_3_r,vertex.label=NA,vertex.color=im_r$membership+1,vertex.size=3)
plot(im_r,sub_g_3_r,vertex.label=NA,vertex.color=im_r$membership+1,vertex.size=3)