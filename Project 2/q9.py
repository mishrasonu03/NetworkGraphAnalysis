import os
import sys
import re
# import igraph
import numpy as np
import statistics as stat
import matplotlib.pyplot as plt
import scipy.sparse.linalg
import random as rnd

actor_actress = [[]]
num_movie_act = []
edges = {}
actor2movie = {}
movie2actor = {}
vertex2movie = {}
movie2vertex = {}
vertex2actor = {}
actor2vertex = {}
movie2rating = {}
actor2rating = {}
actor2row = {}
actor2movies_num = {}

print("Reading actor_actress file ...")
fa = open('actor_actress.txt', 'r')
actor_actress_lines = fa.readlines()
num_read = 0
for line in actor_actress_lines:
    line = re.sub(r'^\s+|\s+$', '', line)
    tmp = re.split(r'\t+', line)
    # line = line.strip('\n')
    # # line = line.rstrip()
    # tmp = re.split(r'\t\t', line)
    actor_actress.append((tmp)) # remove duplicates # become slow
    num_read += 1
    if num_read % 20000 == 0:
        print(num_read)
actor_actress.remove([])
fa.close()# 205147 #244287

# print("Testing ...")
# fa1 = open('actor_actress_test.txt', 'r')
# a_lines = fa1.readlines()
# num_read = 0
# for line in a_lines:
#     num_read += 1
#     if num_read % 20000 == 0:
#         print(num_read)
# fa1.close()
# 268696

print("Hashing entities and generating movies to actor map ...")
len_all = len(actor_actress)
vertex_id = 0
row_id = 0
for i in range(len_all):
    tmpline = actor_actress[i]
    len_tmp = len(tmpline)
    num_movie_act.append(len_tmp - 1)
    tmp_act = tmpline[0]
    # row_id += 1
    # actor2row[tmp_act] = row_id
    vertex2actor[vertex_id] = tmp_act
    actor2vertex[tmp_act] = vertex_id
    actor2movies_num [vertex_id] = len_tmp - 1
    actor_id = vertex_id
    vertex_id += 1
    for j in range(1, len_tmp):
        if tmpline[j] not in movie2vertex:
            movie2vertex[tmpline[j]] = vertex_id
            vertex2movie[vertex_id] = tmpline[j]
            movie_id = vertex_id
            movie2actor[movie_id] = [actor_id]
            vertex_id += 1
        else:
            movie2actor[movie2vertex[tmpline[j]]].append(actor_id)  # 542307

# numgt5 = 0
# for key in movie2actor: # 185811
#     if len(movie2actor[key])>=5:
#         numgt5 += 1

print("Generating actor to movies map ...")
for movie, actors in movie2actor.items():  # 205147 # 244287
    for actor in actors:
        actor2movie.setdefault(actor, []).append(movie)

print("Reading movie ratings file ...")
fa = open('movie_rating.txt', 'r')
movie_rating_lines = fa.readlines()
num_loss = 0
for line in movie_rating_lines:
    line = line.strip('\n')
    line = re.sub(r'^\s+|\s+$', '', line)  # 215763 to 215770  # 224432
    tmp = re.split(r'\t\t', line)
    if tmp[0] in movie2vertex:
        movie2rating[movie2vertex[tmp[0]]] = float(tmp[1])  # MAY HAVE TO TRIM
    else:
        num_loss += 1   # 132775 # 124113
fa.close()

print("Assigning scores to actors ...")
for actor in vertex2actor:
    sum_score = 0
    non_zero = 0.00001
    num_acts = 0
    # for movie in actor2movie[actor]:
    #     if movie in vertex2rating:
    #         non_zero += 1
    #         sum_score += vertex2rating[movie]
    # avg_rating = sum_score / non_zero
    # sum_score = 0
    # non_zero = 0.00001
    # for movie in actor2movie[actor]:
    #     if movie in vertex2rating and vertex2rating[movie] > 0.8*avg_rating:
    #         non_zero += 1
    #         sum_score += vertex2rating[movie]
    # vertex2rating[actor] = sum_score / non_zero
    for movie in actor2movie[actor]:
        if movie in movie2rating: # and len(movie2actor[movie]) > 5:
            weight = min(len(movie2actor[movie]),150)
            sum_score += weight * movie2rating[movie]   # better authority
            num_acts += weight
    if num_acts > 0:
        actor2rating[actor] = sum_score / num_acts  # 234244

print("Listing new movies ...")
new_movies = {"Batman v Superman: Dawn of Justice (2016)",
              "Mission: Impossible - Rogue Nation (2015)",
              "Minions (2015)"}

print("Estimating ratings of new movies based on their cast")
for n_movie in new_movies:
    vid = movie2vertex[n_movie]
    cast = movie2actor[vid]
    sum_score = 0
    num_mov = 0.0001
    nums = 0
    for actor in cast:
        if actor in actor2rating:  # and 5 <= actor2movies_num[actor] <= 100:  # put a cap, not limit
            weight = min(actor2movies_num[actor], 50)
            sum_score += weight * actor2rating[actor]
            num_mov += weight
            nums += 1
    rating = sum_score/num_mov
    print(rating, nums, n_movie)

print("Printing average rating and number of films ...")
vid = movie2vertex["Minions (2015)"]
cast = movie2actor[vid]
for actor in cast:
    if actor in actor2rating:
        print(actor2movies_num[actor], actor2rating[actor])

# To try hubs and authorities
out = open('movie2rating.txt', 'w+')
for key in movie2rating:
    out.write(str(key))
    out.write('\t\t')
    out.write(str(movie2rating[key]))
    out.write('\n')
out.close()

print ("Generating sparse matrix for linear regression training ...")

X = scipy.sparse.lil_matrix((len(movie2rating), len(vertex2actor)))
Y = np.zeros(len(movie2rating))
idx_m = 0
idx_a = 0
movie_index = {}
actor_index = {}

for movie in movie2actor:
    if movie in movie2rating:
        movie_index[movie] = idx_m
        Y[idx_m] = movie2rating[movie]
        for actor in movie2actor[movie]:
            if actor not in actor_index:
                actor_index[actor] = idx_a
                idx_a += 1
            X[idx_m, actor_index[actor]] = 1
        idx_m += 1
X = X.tocsr()

from sklearn import linear_model
# regr = linear_model.LinearRegression() # hundreds
regr = linear_model.Lasso(alpha=.1)  #zeros
# regr = linear_model.SGDRegressor()
regr.fit(X, Y)
# actor2score = {}
# for i in range(len(vertex2actor)):
#     actor2score[actor_index[]]

for n_movie in new_movies:
    vid = movie2vertex[n_movie]
    cast = movie2actor[vid]
    sum_score = 0
    num = 0
    for actor in cast:
        if actor in actor_index:
            sum_score += regr.coef_[actor_index[actor]]
            num += 1
    print(num, regr.intercept_ + sum_score, n_movie)


'''
SGD:
Minnions: 6.90033547, 6.80150269
Batman v Superman: 7.7400546, 7.93860439
Mission: Impossible: 7.32557122, 7.36200868

LASSO:
All: 6.20461370904, 6.21024586512
'''

# n, bins, patches = plt.hist(num_movie_act, 50, normed=1, facecolor='green', alpha=0.75)
# l = plt.plot(list(hist.values()),'r--', linewidth=1)
# plt.show()

# from collections import Counter
# hist = Counter(num_movie_act)

print("creating edgelist")
b = 0
num_ignored = 0
num_dups = 0
for key in movie2actor:
    if len(movie2actor[key]) < 5 or key not in movie2rating:
        num_ignored += 1
        continue
    for j in range(len(movie2actor[key])):
        tmp_edge = (key, movie2actor[key][j])  # edge between movie and all actors
        if tmp_edge not in edges:
            edges[tmp_edge] = 1
        else:
            num_dups += 1
            # print("Duplicate")
            # b = 1
            # break
    # if b == 1:
    #     break

print("creating graph matrix")
out = open('bipartite_graph.txt', 'w+')
for ekey in edges:
    out.write(str(int(ekey[0])))
    out.write('\t')
    out.write(str(int(ekey[1])))
    out.write('\t')
    out.write(str(1))
    out.write('\n')
out.close()
#
#
# out = open('actor2vertex.txt', 'w+')
# for key in actor2vertex:
#     out.write(key)
#     out.write('\t\t')
#     out.write(str(actor2vertex[key]))
#     out.write('\n')
# out.close()
#
# out = open('vertex2actor.txt', 'w+')
# for key in vertex2actor:
#     out.write(str(key))
#     out.write('\t\t')
#     out.write(vertex2actor[key])
#     out.write('\n')
# out.close()
#
# out = open('movie2vertex.txt', 'w+')
# for key in movie2vertex:
#     out.write(key)
#     out.write('\t\t')
#     out.write(str(movie2vertex[key]))
#     out.write('\n')
# out.close()
#
# out = open('vertex2movie.txt', 'w+')
# for key in vertex2movie:
#     out.write(str(key))
#     out.write('\t\t')
#     out.write(vertex2movie[key])
#     out.write('\n')
# out.close()
#
# out = open('vertex2rating.txt', 'w+')
# for key in vertex2rating:
#     out.write(str(key))
#     out.write('\t\t')
#     out.write(str(vertex2rating[key]))
#     out.write('\n')
# out.close()
#
#
# # Making sparse matrix from movie to actor
