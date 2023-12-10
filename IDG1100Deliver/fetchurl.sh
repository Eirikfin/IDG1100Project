#!/bin/bash

#fetch html from website https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway and save in a local file
curl https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway > wikisite.txt

#remove empty lines and tabs
cat "wikisite.txt" | tr -d '\n\t' > wikisite.no.newlines.txt

#fetch only the table with provinces
sed -E 's/.*<table class="sortable wikitable">(.*)<\/table>.*/\1/g' wikisite.no.newlines.txt | sed 's/<\/table>/\n/g' | sed -n '1p' | grep -o '<tbody[ >].*<\/tbody>' | sed -E 's/<tbody[^>]*>(.*)<\/tbody>/\1/g' | sed -E 's/<tr[^>]*>//g' | sed 's/<\/tr>/\n/g' | sed -E 's/<td[^>]*>//g' | sed 's/<\/td>/\t/g' | sed '1d' > wikitable.txt

#grab 2nd and 5th column from table. link with name of municipality and population
cut -f 2 wikitable.txt > column2.txt

#1st line blank so population matches up with the loop later on
echo "" >population.txt

#grab the column with the population and put it in a serperate file
cut -f 5 wikitable.txt >> population.txt

#sort down do just url and place name
awk 'match($0, /href="[^"]*"/){url=substr($0, RSTART+6, RLENGTH-7)} match($0, />[^<]*<\/a>/){printf("%s%s\t%s\n", "https://en.wikipedia.org", url, substr($0, RSTART+1, RLENGTH-5))} ' column2.txt  > url-place.txt

# Loop to grab latitude and longitude from each URL and put them into a new file

# empty the file if there is already data in it
echo "" > place.with.coords.txt

#read lines from url-place.txt and gets the url for each place
while read -r url place; do
    pageHtml=$(curl -s "$url")

    # Check if the pageHtml is empty
    if [ -z "$pageHtml" ]; then
        echo "Error downloading page for $place ($url)"
        continue
    fi
    
    # Grab the <span class> and text whitin, print first line then delete the tags leaving only the coordinates
    lat=$(echo "$pageHtml" | grep -o '<span class="latitude">[^<]*' | head -n 1 | sed 's/<span class="latitude">//' )
    lon=$(echo "$pageHtml" | grep -o '<span class="longitude">[^<]*' | head -n 1 | sed 's/<span class="longitude">//' )

    # Check if latitude and longitude were found
    if [ -z "$lat" ] || [ -z "$lon" ]; then
        echo "Error: Latitude or longitude not found for $place ($url)"
        continue
    fi

    # Format and append to the name of place, latitude and longtitude into file
    printf "%s\t%s\t%s\n" "$place" "$lat" "$lon" >> place.with.coords.txt
done < url-place.txt

#merge name coordinates and population into a single file
paste -d ' ' place.with.coords.txt population.txt > coords-population.txt

#delete no longer needed files
rm wikisite.txt wikitable.txt wikisite.no.newlines.txt column2.txt 
