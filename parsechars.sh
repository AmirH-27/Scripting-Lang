#!/bin/bash
#Name: Md Amir Habib
#Student ID: 10650961

#The assignment was to write a shell script that will prompt the user to to enter the file name
#consisting of several lines of texts each containing different set of characters. The task is to 
#traverse through the lines and extract the number of allowed characters disallowed characters with 
#the respective counts. The following code is not hard coded to this machine only to acheive that I
#used the command 'pwd' to find the current working directory and the user input is used to find the
#path of the file. Using the while loop the the contents in the file is stored in an array then each
#password is passed through a decrementing for for loop to cut the last digit in each iteration. Each 
#character is passed through the if condition to match with the regex. Then the allowedCounter or 
#disallowedCounter is incremented accordingly and the characters are stored in the assigned variables.
#After each iteration the when the next password is selected the variables allowedCounter, 
#disallowedCounter, allowedChars and disallowedChars are reset to 0 and empty. 
#it also checks if the file has a line that contains only whitespaces

IFS=$'\n'
# To find the current working direcotry
currentDirectory=$(pwd)
# Lines array to store the contents in an array
declare -a lines
# Colour variables
red='\033[0;31m'
clear='\033[0m'
# Infinite loop 
while :
do
	printf "Enter the name of the candidate password file (including ext) [Enter -q to quit]: "
    # User input
    read -r input
    # Path varaible stores the file location
    path=$currentDirectory/$input
    # If the user enters -q the program stops
    if [[ $input =~ "-q" ]];then
        break
        # Check if the file exists or empty 
        
    elif ! test -f "$path" || ! grep -q '[^[:space:]]' "$path";then
        echo -e "${red}This file does not exist or is empty. Please try another file name.....${clear}"
    else
        #The array is unseted so that the previous values are cleared
        lines=()
        # While loop to read the file contents and store in an array
        while IFS= read -r line; do
            lines+=("$line")
        done < "$path"
        # i assigned with each index of lines array
        for i in "${lines[@]}";do
            # Stores the length of the password in len
            len=${#i}
            # counter variables to count allowed and disallowed
            allowedCount=0
            disallowedCount=0
            # stores the allowed and disallowed characters
            allowedChars=''
            disallowedChars=''
            # c-style loop decrement loop starts from the last character of the password
            for ((j="$len"; j>0; j--)); do
                # cuts the last character and stores in char 
                # starts with last character then 2nd last in the next iteration
                char=$(echo "$i" | cut -c $j)
                # Regex to check if the character is allowed
                if echo "$char" | grep -Eq '[AEIOU]|[2468]|[\&\#\!\$\-]'; 
                then
                    allowedCount=$((allowedCount+1))
                    allowedChars+=$char
                else
                    disallowedCount=$((disallowedCount+1))
                    disallowedChars+=$char
                fi
            done
            # print statement prints the data of the current password
            if [ "$len" != 0 ]; then
                echo -e "$i |T: $len| [A: $allowedChars ($allowedCount)] [D: ${red}$disallowedChars${clear}] ($disallowedCount)]"
            fi
        done
    fi
done
exit 0



