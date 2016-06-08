import os
import sys
import re

os.chdir(os.path.abspath(os.path.dirname(sys.argv[0])))

f_director = open('director_movies.txt','r')

director = f_director.readlines()

with open('director_movies_cleaned.txt','w+') as fd:
    for line in director:
        line = re.sub(r'\(+uncredited+\)', '', line)
        line = re.sub(r'\(+uncredited voice+\)', '', line)
        line = re.sub(r'\(+voice+\)', '', line)
        line = re.sub(r'\(+VG+\)', '', line)
        line = re.sub(r'\{\{+SUSPENDED+\}\}', '', line)
        line = re.sub(r'^\s+|\s+$', '', line)
        line = re.sub(r'\(+rumored+\)', '', line)
        line = re.sub(r'\(+credit only+\)', '', line)
        line = re.sub(r' \(+as .*?\)', '', line)

        fd.write(line)
	fd.write('\n')
fd.close()
