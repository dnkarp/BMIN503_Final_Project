for file in ../html/wget2/*
do
f=${file##*/}
sed -n "/Get directions/p" ${file} > ../extracted_locations/${f%.html}_location.txt
done
