for file in ../html/wget/*
do
f=${file##*/}
sed -n "/<div class=\"program-entry\">/,/<\/div>/p" ${file} > ../extracted_pages/${f%.html}_pagelist.txt
done
