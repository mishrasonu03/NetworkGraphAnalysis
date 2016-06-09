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
Movie2Actor_c = {}
Edge_h = {}
MNum2Name = {}
MName2Num = {}
ANum2Name = {}
num_movie_act = []
num_act_movie = []
Act_ID = 1
Movie_ID = 1
Actor2Movie = {}

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
        else:
            Movie2Actor_h[tmpline[j]].append(Act_ID)
    Act_ID = Act_ID + 1

for key in Movie2Actor_h:
    if len(Movie2Actor_h[key])>=15:
        Movie2Actor_c[key] = Movie2Actor_h[key]

with open('movie2actor.txt','w+') as ma:
    for key in Movie2Actor_c: 
        tmp = Movie2Actor_c[key]
        ma.write(key)
        for i in range(len(tmp)):
            ma.write('\t\t')
            ma.write(str(tmp[i]))
        ma.write('\n')
ma.close()
    

i = 1
for key in Movie2Actor_c:
    MNum2Name[i] = key
    tmp = Movie2Actor_c[key]
    num_act_movie.append(len(tmp))
    
    for j in range(len(tmp)):
        if tmp[j] not in Actor2Movie:
            Actor2Movie[tmp[j]] = [i]
        else:
            Actor2Movie[tmp[j]].append(i)
    i = i + 1

count = 0 
print "creating edgelist"
Edge_h = {}
for key in Actor2Movie:
    print count
    count = count + 1
    tmp = Actor2Movie[key]
    len_tmp = len(tmp)
    for i in range(len_tmp-1):
        for j in range(i+1,len_tmp):
            if (tmp[i],tmp[j]) in Edge_h:
                tmp_num = Edge_h[(tmp[i],tmp[j])]
                Edge_h[(tmp[i],tmp[j])] = tmp_num + 1
            elif (tmp[j],tmp[i]) in Edge_h:
                tmp_num = Edge_h[(tmp[j],tmp[i])]
                Edge_h[(tmp[j],tmp[i])] = tmp_num + 1
            elif ((tmp[i],tmp[j]) not in Edge_h) and ((tmp[j],tmp[i]) not in Edge_h):
                Edge_h[(tmp[i],tmp[j])] = 1

print "creating graph matrix"
edgelist = np.zeros(shape=(len(Edge_h),3))
index = 0
for ekey in Edge_h:
    ENum = Edge_h[ekey]
    vertex_1 = ekey[0]
    vertex_2 = ekey[1]

    weight = float(ENum) / float((num_act_movie[vertex_1-1] + num_act_movie[vertex_2-1] - ENum))
    edgelist[index][0] = vertex_1
    edgelist[index][1] = vertex_2
    edgelist[index][2] = weight
    index = index + 1

np.savetxt('edgelist_matrix_movie.txt',edgelist,delimiter=' ')

with open('Movie_ID.txt','w+') as out:
    for key in MNum2Name:
        out.write(str(key))
        out.write('\t\t')
        out.write(MNum2Name[key])
        out.write('\n')

out.close()








    
