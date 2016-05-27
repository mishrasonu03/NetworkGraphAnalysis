import os
import sys
import re

os.chdir(os.path.abspath(os.path.dirname(sys.argv[0])))

#q1
f_actor = open('actor_movies.txt','r')
f_actress = open('actress_movies.txt','r')
out = open('actor_actress.txt','w+')
actor = f_actor.readlines()
actress = f_actress.readlines()

actor_actress = []

for line in actor:
    tmp = re.split(r'\t+',line)
    if len(tmp)>=6:
        actor_actress.append(tmp)
        tmp = '\t\t'.join(tmp)
        out.write(tmp)

for line in actress:
    tmp = re.split(r'\t+',line)
    if len(tmp)>=6:
        actor_actress.append(tmp)
        tmp = '\t\t'.join(tmp)
        out.write(tmp)

f_actor.close()
f_actress.close()
out.close()

#q2
len_all = len(actor_actress)
Movie2Actor_h = {}
Edge_h = {}
MNum2Name = {}
ANum2Name = {}
num_movie_act = []
Act_ID = 1
Movie_ID = 1

print "hashing process"
for i in range(len_all):
    tmpline = actor_actress[i]
    len_tmp = len(tmpline)
    num_movie_act.append(len_tmp-1)
    tmp_act = tmpline[0]
    ANum2Name[Act_ID] = tmp_act

    if i%100==0:
        print i

    for j in range(1,len_tmp):
        if tmpline[j] not in Movie2Actor_h.keys():
            Movie2Actor_h[tmpline[j]] = [Movie_ID,Act_ID]
            MNum2Name[Movie_ID] = tmpline[j]
            Movie_ID = Movie_ID + 1
        else:
            Movie2Actor_h[tmpline[j]].append(Act_ID)
    Act_ID = Act_ID + 1

print "creating edgelist"
i=0
for key in Movie2Actor_h.keys():
    if i%10000==0:
        print i
    if (len(Movie2Actor_h[key])<=2):
        continue
    for j in range(1,len(Movie2Actor_h[key])-1):
        for k in range(j+1,len(Movie2Actor_h[key])):
            tmp_edge = '\t'.join([Movie2Actor_h[key][j],Movie2Actor_h[key][k]])
            if tmp_edge not in Edge_h.keys():
                Edge_h[tmp_edge] = 1
            else:
                Edge_h[tmp_edge] = tmp_num + 1




