#!/bin/bash
cd .
echo $PWD
for file in ../extracted_pages2/*
do
	f=${file##*/}
	state=${f%_programsurls.txt}
	i=1
	while read line
	do
		if [ "$line" != "" ]; then
			wget -O ../html/wget2/${state}-program-${i}.html $line
			((i++))
		fi
	done < $file
done
