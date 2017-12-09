#!/bin/bash
cd .
echo $PWD
INPUT=../usstatelist.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read line
do
	wget -O ../html/wget/${line}.html https://nasen.org/directory/$line/

done < $INPUT
IFS=$OLDIFS
