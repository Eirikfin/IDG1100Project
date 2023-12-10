#!/bin/bash

# Function to print paragraph for the municipality page
generate_html_content() {
    municipality_data="$1"

    # Output the paragraph for the provided municipality
    printf "$municipality_data"
}

# Check if the query string is empty, indicating an invalid request
if [ -z "$QUERY_STRING" ]; then
    # Output a error page not found error
    echo "Content-type: text/html"
    echo ""
    echo "<html><body>"
    echo "<h1>Error 404 - Page not found</h1>"
    echo "</body></html>"
else
    # find the municipality from the query string 
    municipality=$(echo "$QUERY_STRING" | sed -n 's/^.*municipality=\([^&]*\).*$/\1/p')

    if [ -z "$municipality" ]; then
        # Output a error page for a not found error with missing parameter
        echo "Content-type: text/html"
        echo ""
        echo "<!DOCTYPE html> <html lang="en"> <head> <meta charset="UTF-8"> <meta name="viewport" content="width=device-width, initial-scale=1.0"><title>The Weather for: "$municipality"</title> <link rel="stylesheet" href="style.css"> </head><body><main>"
        echo "<h1>Error 404 - Page not found</h1>"
        echo "</main><footer><p>Developed for the course IDG1100 by candidate number: 10039</p></footer></body></html>"
    else
        # echo HTML head and body tags for the weather information page
        echo "Content-type: text/html"
        echo ""
        echo "<!DOCTYPE html> <html lang="en"> <head> <meta charset="UTF-8"> <meta name="viewport" content="width=device-width, initial-scale=1.0"><title>The Weather for: "$municipality"</title> <link rel="stylesheet" href="style.css"> </head><body><main>"

        # Read data from the text file and find the matching municipality, prints the paragraph from the matching line:
       municipality_data=$(awk -v municipality="$municipality" -F'</p>' 'BEGIN{RS="<p>"} $0 ~ municipality {print $0"</p>"}' webpage.txt)


        if [ -z "$municipality_data" ]; then
            # Output a error page for a Municipality not found
            echo "<h1>Error 404 - Municipality "$municipality" not found</h1>"
        else
            # Call the function to generate and output Paragraph with data for the specified municipality
            generate_html_content "$municipality_data"
        fi

        # echo the footer and ending tags of the HTML
        echo "</main><footer><p>Developed for the course IDG1100 by candidate number: 10039</p></footer></body></html>"
    fi
fi
