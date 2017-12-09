#!/usr/bin/env python
import re

state=sys.argv

newfile = open('../testfile.txt','w')
file = open("../extracted_pages/az_pagelist.txt", "r")
for line in file:
  m = re.findall ( 'href="/(.*?)/">', line)
  if m:
    print m[0]
    newfile.write('https://nasen.org/'+m[0]+'/'+'\n')
  else:
    continue

newfile.close()



wfile = open('../'+state+'.txt','w')
rfile = open("../extracted_pages/'+state+'_pagelist.txt", "r")
for line in rfile:
  m = re.findall ( 'href="/(.*?)/">', line)
  if m:
    print m[0]
    wfile.write('https://nasen.org/'+m[0]+'/'+'\n')
  else:
    continue

wfile.close()
