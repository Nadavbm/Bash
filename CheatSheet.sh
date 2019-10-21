#!/bin/bash
Bash cheatsheet
===============
# One line comment

Variables and data types
========================
STR="Sting variable"
INT=2
# Variables from stdout
DATE="$( date +%F )"                                                # Date in form 2018-12-17
DATE_NOW="$(date +%Y/%m/%dT%H:%M:%S)"                               # to seconds
YESTERDAY="$( date -d 'yesterday 00:00:00' '+%s%3N' )"
HOST="$( hostname )"                                                # hostname
DIR="/home/user"                                                    # directory location
TEXT="${DIR}/List.txt"                                              # txt file contain a list
LIST=$( cut -d' ' -f5 ${DIR}/${TEXT} | paste -d' ' -s )
ARRAY=( ${LIST} )                                                   # set an array from the list abov
# Data types after echo
echo "String"
echo 1
echo "$( date +%F )"
echo "[`date +%F--%H-%M`]"
echo $DATE                                                          # The DATE variable set above
# Colorize echos
echo -e "\e[92mToday is the $DATE"
echo -e "\e[94mThe directory you are looking for: \n$DIR"
echo -e "\e[97mThe elements in this array are: \n ${ARRAY[@]}"
# Special variables
Arg1="$1"                                                           # First parameter from terminal: $ script.sh firstParam
Arg2="$2"                                                           # Second parameter from terminal: $ script.sh firstParam secondParam
NumOfArguments="$#"                                                 # Special variable that show the number of arguments that passed to the script
ExitStatusOfLastCommand="$?"                                        # expands to the exit status of the most recently executed foreground pipeline.
PARAM4="$*"
PARAM3="$!"            #

Conditional Programming - if then else statements
=================================================
COUNT=5                                                             # If statement
if [[ $COUNT -gt 2 ]]; then
  echo "COUNT is more than 2"
fi

if [ ${DATE} == "12-12-2019" ]; then                                # If then else
  echo "Today is the 12th of Dec 2019"
else
  echo "This is not the 12th of Dec 2019"
fi

if [[ $COUNT -lt 4 ]]; then                                         # If, elif and else
  echo "COUNT is less than 4"
elif [[ $COUNT -gt 6 ]]; then
  echo "COUNT is greater than 6"
else
  echo "COUNT is 5"
fi

/usr/bin/command                                                    # Another example
if [[ $? -gt 0 ]];then
 echo "Operation failed at [`date +%F_%H:%M:%S`]"
 exit 1
fi
echo "Operation succeed!"
exit 0

Case statements
================
case "$1" in
  caseaa)   echo "do aa" ;;
  casebb)   cmd='/usr/bin/bb' ;;
  casecc)   echo "Are you sure?"
            read confirm
            if [ $confirm = 'y']; then
              cmd='/usr/bin/cc func'
            else
              exit 1
            fi ;;
   *)       echo "For any case output this - usually help file and exit"
esac

Loops - for, while, until
=========================
# For loops
for (( i = 0; i < 10; i++ )); do                                    # For loop that count until 10
    echo $i
done

$BACKUPARR="($ find /backup/dir/ -name '*.tar' )"                   # For loop using array
for i in "${BACKUPARR[@]}"; do
  gzip $i
done

SQLARRAY=( "dbName1" "dbName2" )                                    # Create array and for loop
USER='root'; PASSWORD='password'; HOST='10.10.10.10'
for i in "${SQLARRAY[@]}"; do
  mysqldump -h $HOST -v -u $USER -p $PASSWORD $i > /backup/path/$i.sql
done

# While loop
COUNT=0
while [ $COUNT -lt 10 ]; do
  echo "${COUNT}\n"
  COUNT=$[$COUNT+1]
done

# Until loop
COUNT=0
until [ $COUNT -gt 10 ]; do
  printf "$count\n"
  ((count++))
done

Functions:
==========
function helloWorld () {
  echo "Hello World"
}
# Call this function by running in terminal: $ CheatSheet.sh echoDate
function echoDate() {
  echo "$( date +%F )"
}

Bash Syntax
===========
# Commands syntax - pipelines:
[time [-p]] [!] command1 [ | or |& command2 ] …
‘;’, ‘&’, ‘&&’, or ‘||’                                               # Pipeline commands operators
cd /home && echo "Hello" $(whoami); df -h & lsblk                     # Precedence
command1 || command2                                                  # command2 is executed if, and only if, command1 returns a non-zero exit status.

# Syntax (ANSI-C qouting) use this in "" or '' - Strings:
\a                                                                    #alert (bell)
\b                                                                    #backspace
\e  \E                                                                #an escape character (not ANSI C)
\f                                                                    #form feed
\n                                                                    #newline
\r                                                                    #carriage return
\t                                                                    #horizontal tab
\v                                                                    #vertical tab
\\                                                                    #backslash
\'                                                                    #single quote
\"                                                                    #double quote
\?                                                                    #question mark
