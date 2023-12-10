#!/bin/bash

#variable for the project directory please change the path for the project to work on different computers
PROJECT_DIR=/home/eirikfin/Documents/GitHub/IDG1100EXAM

# Get the date for tomorrow in the format of year/month/day as a variable.
tomorrow=$(date -d "tomorrow" +"%Y-%m-%d")



#clear out weather_data for fresh input
echo "" > $PROJECT_DIR/weather_data.txt
echo "" > $PROJECT_DIR/lastcheck.txt
# Loop through each line in the data.txt file
while IFS=$'\t' read -r url place population lat lon; do
    # Extract latitude and longitude values
    lat_value=$(echo "$lat" | cut -d' ' -f2)
    lon_value=$(echo "$lon" | cut -d' ' -f2)

    # Fetch weather data for the current location
    weather_data=$(curl -A "NTNU student project eirihf@stud.ntnu.no" -s "https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=$lat_value&lon=$lon_value")
#error if curl fails to get data
if [ $? -ne 0 ]; then
    echo "Error fetching data for $place" >> $PROJECT_DIR/weather_data.txt
fi

    # Extract relevant information for tomorrow at 12:00 jq needs to be installed. Chooses the next day and the time 12:00. Extracts temperature (.data.instant.details.air_temperature), precipitaion for next 6 hours and humidity
    selected_data=$(echo "$weather_data" | jq -c --arg tomorrow "$tomorrow" '.properties.timeseries[] | select(.time | startswith($tomorrow) and contains("T12:00:00")) | { temp: .data.instant.details.air_temperature, precip: .data.next_6_hours.details.precipitation_amount, humidity: .data.instant.details.relative_humidity}')


    # put the result in a file "weather_data.txt" and removing unneeded characthers, replace : with tab
    echo "$selected_data"| sed 's/[a-z{}\"\,]//g' | sed 's/:/   /g'>> $PROJECT_DIR/weather_data.txt
    #put the date in the format of the API in a file for when the weather was updated
    date -u +"%a, %d %b %Y %T GMT" >> $PROJECT_DIR/lastcheck.txt

done < $PROJECT_DIR/data.txt
#combine the wheater with the rest of the data
sed -i '1d' $PROJECT_DIR/weather_data.txt
sed -i '1d' $PROJECT_DIR/lastcheck.txt
paste $PROJECT_DIR/weather_data.txt $PROJECT_DIR/lastcheck.txt > $PROJECT_DIR/weather_data2.txt

paste $PROJECT_DIR/data.txt $PROJECT_DIR/weather_data2.txt > $PROJECT_DIR/fulldata.txt



