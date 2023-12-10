#!/bin/bash

# 1 remove first column(url-links)
# 2 replace spaces with "-"
# 3 remove first character from each line, save output to names.txt, replace spaces with "-", and last replace norwegian letters æ ø and å with more agreeable characthers for the query script
echo "" > names.txt
awk '{ $1=""; print $0 }'  url-place.txt | sed 's/ /-/g' | sed 's/^.//' | sed 's/ø/o/g' | sed 's/å/aa/g' | sed 's/æ/ae/g' | sed 's/Ø/O/g' | sed 's/Å/AA/g' | sed 's/Æ/AE/g'>> names.txt
#Create a .txt with just the urls:
echo "" > urls.txt
awk '{print $1}' url-place.txt >> urls.txt


#create a file with all data needed for the website, also deletes the first and last line to clean up the output.
paste urls.txt names.txt population.txt decimalcoord.txt | sed '1d;$d' > data.txt

#delete no longer needed files
rm coords-population.txt place.with.coords.txt url-place.txt