import os
import sys
import re
import numpy as np

os.chdir(os.path.abspath(os.path.dirname(sys.argv[0])))

# read data
fa = open('actor_actress.txt','r')
actor_actress_lines = fa.readlines()

actor_actress = [[]]

for line in actor_actress_lines:
    line = re.sub(r'^\s+|\s+$','',line)
    tmp = re.split(r'\t+',line)
    actor_actress.append(tmp)
    
actor_actress.remove([])
    

fa.close()

# process
len_all = len(actor_actress)
Movie2Actor_h = {}
Edge_h = {}
MNum2Name = {}
ANum2Name = {}
num_movie_act = []
Act_ID = 0
Movie_ID = 0

print "hashing process"
for i in range(len_all):
    tmpline = actor_actress[i]
    len_tmp = len(tmpline)
    num_movie_act.append(len_tmp-1)
    tmp_act = tmpline[0]
    ANum2Name[Act_ID] = tmp_act

    for j in range(1,len_tmp):
        if tmpline[j] not in Movie2Actor_h:
            Movie2Actor_h[tmpline[j]] = [Act_ID]
            MNum2Name[Movie_ID] = tmpline[j]
            Movie_ID = Movie_ID + 1
        else:
            Movie2Actor_h[tmpline[j]].append(Act_ID)
    Act_ID = Act_ID + 1

print "creating edgelist"
for key in Movie2Actor_h:
    if (len(Movie2Actor_h[key])<=1):
        continue
    for j in range(len(Movie2Actor_h[key])-1):
        for k in range(j+1,len(Movie2Actor_h[key])):
            tmp_edge = (Movie2Actor_h[key][j],Movie2Actor_h[key][k])
            if tmp_edge not in Edge_h:
                Edge_h[tmp_edge] = 1
            else:
                Edge_h[tmp_edge] = Edge_h[tmp_edge] + 1

print "creating graph matrix"
edgelist = np.zeros(shape=(len(Edge_h)*2,3))
index = 0
for ekey in Edge_h:
    ENum = Edge_h[ekey]
    vertex_1 = ekey[0]
    vertex_2 = ekey[1]

    weight_1 = float(ENum) / float(num_movie_act[vertex_1])
    weight_2 = float(ENum) / float(num_movie_act[vertex_2])
    edgelist[index][0] = vertex_1
    edgelist[index][1] = vertex_2
    edgelist[index][2] = weight_1
    index = index + 1
    edgelist[index][0] = vertex_2
    edgelist[index][1] = vertex_1
    edgelist[index][2] = weight_2
    index = index + 1

np.savetxt('edgelist_matrix.txt',edgelist,delimiter=' ')
out = open('Act_ID.txt','w+')
for key in ANum2Name:
    out.write(str(key))
    out.write('\t\t')
    out.write(ANum2Name[key])
    out.write('\n')

out.close()
