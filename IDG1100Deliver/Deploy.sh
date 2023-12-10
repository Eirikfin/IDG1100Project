#!/bin/bash
#getting the data needed form wikipedia
echo "Fething data from Wikipedia..."
bash fetchurl.sh
echo "done"

#script that covert coordinates to decimal values
echo "Coverting coordinates to decimal"
bash degreeconverter.sh
echo "done"

#combine the text files into a "data.txt" file
echo "creating data.txt"
bash createdata.sh
echo "done"

#setup apache, host and cronjob
echo "setting up webpage"
bash setup.sh
echo "done"

#get weather and update page
echo "getting wheather data and updating page"
bash updatewebsite.sh
echo "finished"

