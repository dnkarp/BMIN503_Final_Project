#!/usr/bin/env python
import re
import sys
import os
state=sys.argv[1]
project='/Users/dkarp/Dropbox/courses/fall-2017/EPID-600/final_project/data/needle_exchange'

writefile="/Users/dkarp/Dropbox/courses/fall-2017/EPID-600/final_project/data/needle_exchange/extracted_pages2/%s_programsurls.txt" % state
readfile="/Users/dkarp/Dropbox/courses/fall-2017/EPID-600/final_project/data/needle_exchange/extracted_pages/%s_pagelist.txt" % state

wfile = open(writefile, 'w+')
rfile = open(readfile, 'r')

for line in rfile:
  m = re.findall ( 'href="/(.*?)/">', line)
  if m:
    print m[0]
    wfile.write('https://nasen.org/'+m[0]+'/'+'\n')
  else:
    continue

wfile.close()
