#!/bin/bash

# Student Name: Md Amir Habib
# Student Id: 10650961

# The following script checks the number of inputs provided by the user as arguments 
# If it is not exactly two (2) or any of the file is not a csv file the program will stop and 
# print the error message with the colour combination
# If the second file exists then it removes it
# The input files are assigned to original_file and processed_file respectively
# A counter variable is set to 0
# Headers for the new file is inserted
# A while loop is is used to traverse through the csv file
# ',' is used as a deliemter to seperate each columns and assign to IP TIME URL STATUS
# When the counter is 0 then the first line is skipped with continue to ignore the header of the original file
# In the next itteration IP and STATUS has the value which doesnot need to be altered
# The opening parenthesis '[' needs to be removed along with the time, with only the date remaining and assigned to the date variable
# The URL needs to be divided in 3 columns Method, Path, Protocol
# Since the URL is divided with space the using awk as space as a delimeter $1 $2 $3 is assigned to method, path, protocol respectively
# Using cut and sed path is filtered by removing the '/' and the parameters after ? using regex
# Finally the counter is incremented by 1 and the data is inserted to the file
# The loop traverse through the entire file 
# The counter value is deducted by 1 to remove the header line's count
# At last the completion is message is printed with the number of records processed

blue='\e[34m'
clear='\e[0m'
if [[ $# -ne 2 || ! $1 =~ .csv$ || ! $2 =~ .csv$ ]]; then
    echo "You need to provide the names of two (2) .csv files"
    echo " - the name of the log file to be processed and,"
    echo " - the name you want for the .csv file for the processed results to be placed in e.g."
    echo -e " $blue./logparser.sh weblogname.csv outputfilename.csv$clear"
    echo "Please try again."
    exit 0
fi

if [[ -f $2 ]]; then
    rm "$2"
fi

original_file=$1
processed_file=$2

counter=0
echo "IP,DATE,METHOD,PATH,PROTOCOL,STATUS" >> "$processed_file" # Inserting the Six (6) column headers in the new file
while IFS="," read -r IP TIME URL STATUS # Using ',' as a delimeter and reading through the csv file 
do
    if [[ $counter -eq 0 ]]; then # If counter is 0 this is the first itteration to skip the file headers
        counter=$((counter + 1)) # Counter is updated so that the if condition is not true in the next itteration
        echo "Processing...."
        continue # Skip the header line
    fi

    date=$(echo "$TIME" | cut -c 2- | sed 's/\:.*//') # '[' is removed using cut command and time is removed by sed with regex after ':'

    method=$(echo "$URL" | awk '{print $1}') # Using awk first data of the URL data is assigned to mehtod 
    path=$(echo "$URL" | awk '{print $2}' | cut -c 2- | sed 's/\?.*//' ) # Using awk second data of the URL data is assigned to path and sed is used to remove the path parameters
    protocol=$(echo "$URL" | awk '{print $3}') # Using awk third data of the URL data is assigned to protocol

    counter=$((counter + 1)) # Counter incremented
    echo "$IP,$date,$method,$path,$protocol,$STATUS" >> "$processed_file" # Parsed data inserted to second data
done < "$original_file"
result=$((counter-1)) # Counter deducted by 1 to ignore the header's count
echo "$result Records Processed." # Completion message
exit 0