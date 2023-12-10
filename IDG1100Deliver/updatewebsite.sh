#!/bin/bash
#variable for the project directory please change the path for the project to work on different computers
PROJECT_DIR=/home/eirikfin/Documents/GitHub/IDG1100EXAM
#update the weather before refreshing the webpage
bash $PROJECT_DIR/getwheater.sh
# Loop to place the data into rightful place, and creates the paragrapghs for the webpage
echo "" > $PROJECT_DIR/webpage.txt

while read url place population lat latvalue lon lonvalue temp prec humidity weekday date month time; do
    printf "<p>%s has a population of:%s Coordinates: lat: %s lon: %s The weather for tomorrow is Temperature: %s°C Precipation: %s mm Moisture: %s%% Weather last updated: %s %s %s %s</p>\n" "$place" "$population" "$latvalue" "$lonvalue" "$temp" "$prec" "$humidity" "$weekday" "$date"  "$month" "$time">> $PROJECT_DIR/webpage.txt
done < $PROJECT_DIR/fulldata.txt


#todo move the index file to desired directory and update apache
sudo cp $PROJECT_DIR/webpage.txt /var/www/ubervaer/public_html/webpage.txt