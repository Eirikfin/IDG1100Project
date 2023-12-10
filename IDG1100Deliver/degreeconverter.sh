#!/bin/bash

# Make directory for cleaner structure
mkdir -p coordinates

# 1 remove letters, both capital and undercase so we are only left with symbols and letters
# 2 grab the latitude and longtitude column and print in a new text file 
sed 's/[a-zA-Z\-]//g' coords-population.txt | awk '{print $1, $2}' > coordinates/coordsonly.txt

#separate latidude and longtitude into two different files
awk '{print $1}' coordinates/coordsonly.txt > coordinates/latitude.txt
awk '{print $2}' coordinates/coordsonly.txt > coordinates/longtitude.txt

#remove symbols and replace with space, we are only left with numbers that can be converted to decimal
sed 's/°/ /g' coordinates/latitude.txt | sed 's/\′/ /g' | sed 's/\″//g' > coordinates/latitude-no-symbol.txt 
sed 's/°/ /g' coordinates/longtitude.txt | sed 's/\′/ /g' | sed 's/\″//g' > coordinates/longtitude-no-symbol.txt

#converting the numbers into decimal: minutes/60 , seconds/3600. Add together into complete number
# the output is also cut down to no more than the 4th decimal to comply with met.no's terms of service
# Process latitude file
awk '{ result = $1 + $2/60 + $3/3600; printf "LAT= %.4f\n", result }' coordinates/latitude-no-symbol.txt > coordinates/latitude_result.txt

# Process longitude file
awk '{ result = $1 + $2/60 + $3/3600; printf "LON= %.4f\n", result }' coordinates/longtitude-no-symbol.txt > coordinates/longitude_result.txt


#merge the to files into 1
paste coordinates/latitude_result.txt coordinates/longitude_result.txt > decimalcoord.txt

#delete no longer needed files
rm -r coordinates