for n in ../extracted_locations/*; do program=${n##*/}; grep '' $n; done > ../output/bulk_output.txt
