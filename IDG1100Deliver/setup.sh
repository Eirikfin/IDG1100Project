#!/bin/bash
#Change this to your folder and change it in the "uodatewebsite.sh" script too
PROJECT_DIR=/home/eirikfin/Documents/GitHub/IDG1100EXAM
# Making directory for the webpage
sudo mkdir -p /var/www/ubervaer/public_html
#copy the css file and the webpage script to the webpage folder
sudo cp style.css /var/www/ubervaer/public_html/style.css
sudo cp generatepage.sh /var/www/ubervaer/public_html/generatepage.sh
# Add hostname to /etc/hosts
echo "127.0.0.25 uber.vaer" | sudo tee -a /etc/hosts


echo "" > frontpage.txt
# Loop through each line in the fulldata.txt file and creating the front page links
while IFS=$'\t' read -r url place population lat latvalue lon lonvalue temp prec humidity weekday date month time; do
    printf "<p><a href=\"generatepage.sh?municipality=%s\">%s</p>\n" "$place" "$place" >> "$PROJECT_DIR/frontpage.txt"
done < "$PROJECT_DIR/fulldata.txt"

webdata=$(cat "$PROJECT_DIR/frontpage.txt")
awk -v replace="$webdata" '{gsub(/<!--REPLACE-->/, replace)}1' "$PROJECT_DIR/html-template.html" > "$PROJECT_DIR/index.html"
sudo cp index.html /var/www/ubervaer/public_html/index.html


# Copy conf file to appropriate folder
sudo cp ubervaer.conf /etc/apache2/sites-available/

# Enable the site
sudo a2enmod cgi
sudo a2ensite ubervaer.conf

# Restart Apache
sudo systemctl restart apache2
#putting the weatherupdate and webpage update into the crontab where the page updates every hour and minute 15
echo "15 */1 * * * $PROJECT_DIR/updatewebsite.sh" | crontab -

