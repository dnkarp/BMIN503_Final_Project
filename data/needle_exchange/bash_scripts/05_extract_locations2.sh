for file in ../html/wget2/*
do
f=${file##*/}
if ! grep "Get directions" ${file}; then
  sed -n "/lead/p" ${file} > ../extracted_locations/${f%.html}_location-noaddress.txt
else
  sed -n "/Get directions/p" ${file} > ../extracted_locations/${f%.html}_location.txt
fi
done
