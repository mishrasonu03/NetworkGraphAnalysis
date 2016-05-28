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
    line = re.sub(r'\(+uncredited+\)','',line)
    line = re.sub(r'\(+uncredited voice+\)','',line)
    line = re.sub(r'\(+voice+\)','',line)
    line = re.sub(r'\(+VG+\)','',line)
    line = re.sub(r'\{\{+SUSPENDED+\}\}','',line)
    line = re.sub(r'^\s+|\s+$','',line)
    line = re.sub(r'\(+rumored+\)','',line)
    line = re.sub(r'\(+credit only+\)','',line)
    line = re.sub(r'\(+as .*','',line)
    
    tmp = re.split(r'\t+',line)
    if len(tmp)>=6:
        for j in range(len(tmp)):
            tmp[j] = re.sub(r'^\s+|\s+$','',tmp[j])
        actor_actress.append(tmp)
        tmp = '\t\t'.join(tmp)
        out.write(tmp)
        out.write('\n')

for line in actress:
    line = re.sub(r'\(+uncredited+\)','',line)
    line = re.sub(r'\(+uncredited voice+\)','',line)
    line = re.sub(r'\(+voice+\)','',line)
    line = re.sub(r'\(+VG+\)','',line)
    line = re.sub(r'\{\{+SUSPENDED+\}\}','',line)
    line = re.sub(r'^\s+|\s+$','',line)
    line = re.sub(r'\(+rumored+\)','',line)
    line = re.sub(r'\(+credit only+\)','',line)
    line = re.sub(r'\(+as .*','',line)
    
    tmp = re.split(r'\t+',line)
    if len(tmp)>=6:
        for j in range(len(tmp)):
            tmp[j] = re.sub(r'^\s+|\s+$','',tmp[j])
        actor_actress.append(tmp)
        tmp = '\t\t'.join(tmp)
        out.write(tmp)
        out.write('\n')

f_actor.close()
f_actress.close()
out.close()




