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
#
# Variables from stdout
DATE="$( date +%F )"                    # Date in form 2018-12-17
DATE_NOW="$(date +%Y/%m/%dT%H:%M:%S)"   # to seconds
YESTERDAY="$( date -d 'yesterday 00:00:00' '+%s%3N' )"
HOST="$( hostname )"                    # hostname
DIR="/home/user"                        # directory location
TEXT="${DIR}/List.txt"                  # txt file contain a list
LIST=$( cut -d' ' -f5 ${DIR}/${TEXT} | paste -d' ' -s )
ARRAY=( ${LIST} )                       # set an array from the list abov
#
# Echo variables:
echo "String"
echo 1
echo "$( date +%F )"
echo "[`date +%F--%H-%M`]"
echo $DATE                              # The DATE variable set above
#
# Colorize echos
echo -e "\e[92mToday is the $DATE"
echo -e "\e[94mThe directory you are looking for: \n$DIR"
echo -e "\e[97mThe elements in this array are: \n ${ARRAY[@]}"
# Special variables
Arg1="$1"                               # First parameter from terminal: $ script.sh firstParam
Arg2="$2"                               # Second parameter from terminal: $ script.sh firstParam secondParam
NumOfArguments="$#"                     # Special variable that show the number of arguments that passed to the script
ExitStatusOfLastCommand="$?"            # expands to the exit status of the most recently executed foreground pipeline.
PARAM4="$*" 
PARAM3="$!"            #   
#
# Conditional programming
if [[ condition ]]; then
  # statement
elif [[ condition ]]; then
  # statement
else
  # statement
fi
# If statement:
if [ ! -f $1 ]; then
    echo "$1 -- No such File!"
fi
# Another if statement:
/usr/bin/command
if [[ $? -gt 0 ]];then
 echo "Operation failed at [`date +%F_%H:%M:%S`]"
 exit 1
fi
echo "Operation succeed!"
exit 0
# If then else statement:


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

# Loops:
echo "Count until 10"
for (( i = 0; i < 10; i++ )); do
    echo $i
done

# The $@ will create an arrays from the parameters added to the script execution in terminal
> bash myArrayParams param1 param2 param2
#!/bin/bash
for i in "$@"
do
    echo "$i"
done
