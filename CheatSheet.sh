#!/bin/bash
#
# This cheatsheet will be adjusted to Linux environment and Bash syntax
#
# Writing comments use # in the beginning of the line:
#
# One line comment
#
# Variables and data types:
STR="Sting variable"
INT=2
# Parameters to bash scripts within the script:
PARAM1="$1" # First parameter from terminal: $ script.sh firstParam
PARAM2="$2" # Second parameter from terminal: $ script.sh firstParam secondParam
# Useful terminal output variables:
DATE="$( date +%F )" # Date in form 2018-12-17
DATE_NOW="$(date +%Y/%m/%dT%H:%M:%S)" # to seconds
YESTERDAY="$( date -d 'yesterday 00:00:00' '+%s%3N' )"
HOST="$( hostname )" # VM hostname
DIR="/home/user" # Directory location
TEXT="${DIR}/List.txt" #TXT file contain a list
LIST=$( cut -d' ' -f5 ${DIR}/${TEXT} | paste -d' ' -s )
ARRAY=( ${LIST} )   # Set an array from the list above
# Echo variables:
echo "String"
echo 1
echo "$( date +%F )"
echo "[`date +%F--%H-%M`]"
echo $DATE # The DATE variable set above
# Functions:

function helloWorld () {
  echo "Hello World"
}
# Call this function by running in terminal: $ CheatSheet.sh echoDate
function echoDate() {
  echo "$( date +%F )"
}

# if statements:
if [[ ${DATE} == "12-12-2019" ]]; then
  echo "Today is the 12th of Dec 2019"
fi

# Error handling
if [[ $? -gt 0 ]];then
 echo "Operation failed at [`date +%F_%H:%M:%S`]"
 exit 1
fi

# if else statements:
if [[ $? -gt 0 ]]; then
  echo "We have an error"
  exit 1 
else
  echo "We don't have an error"
  exit 0
fi

# If, elif ele statements:
if [[ condition ]]; then
  #statements
elif [[ condition ]]; then
  #statements
else

fi

# Statements examples:
PACKAGE="$( rpm -qa | grep wget )" # Check if wget installed

if [ -z "$PACKAGE"  ]]; then
  yum install -y wget # If null - install wget
fi



# Arrays:


# Loops:
for (( i = 0; i < 10; i++ )); do
  #statements
done
