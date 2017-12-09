for file in ../extracted_pages/*
do
f=${file##*/}
python ../python/parse_urls-run.py "${f%_pagelist.txt}"
done
