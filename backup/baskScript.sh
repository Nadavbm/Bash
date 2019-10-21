#!/bin/sh
#
# Script parameter to execute the function
PARAM="$1"
# Date of backup
DATE="$( date +%F )"
# Local directory for the backups
LOCAL="/backup/jenkins"
# External directory for the backups
EXTERNAL="gs://gamigo-infrastructure/jenkins"
# Find the current backups files - if .tar .gz .lzop or.sql adjust the find command accordingly
BCKARRAY="$( find $LOCAL/*.tar.gz )"
# For jenkins backup
JNKDIR="/var/lib/jenkins"
JNKCFG="$JNKDIR/config.xml"
JNKXML="$( cd $JNKDIR && find . -name "*.xml" -maxdepth 1 -type f)"
JNKJOB="$( cd $JNKDIR && find jobs/ -type d -maxdepth 2 )"
JNKUSR="$JNKDIR/users/"
# Add MySQL databases to an array
SQLARRAY=( "dbName1" "dbName2" )
# Count local backup variable
BCKCOUNT="$( find $LOCAL/*_backup.tar -maxdepth 1 -type f | wc -l )"
#
function checkConfig {
        echo -e "\e[92mToday is the $DATE"
        echo -e "\e[90m######"
	echo -e "\e[92mYou choose to run $PARAM"
	echo -e "\e[90m######"
	echo -e "\e[93mYour backup dirctory on the server is $LOCAL"
	echo -e "\e[90m######"
	echo -e "\e[95mYou will copy the files to external resource at $EXTERNAL"
	echo -e "\e[90m######"
	echo -e "\e[96mThese are your current backup files - \n$BCKARRAY"
	echo -e "\e[90m######"
	echo -e "\e[91mThe number of backups available locally on the server $BCKCOUNT"
        echo -e "\e[90m######"
        echo -e "\e[94mJenkins directory set is $JNKDIR"
	echo -e "\e[94mAnd the config files for Jenkins are: \n$JNKXML"
        echo -e "\e[90m######"
	echo -e "\e[94mJenkins folder structure: \n$JNKJOB"
        echo -e "\e[90m######"
        echo -e "\e[97mMySQL Databases that set to backup are: ${SQLARRAY[@]}"
}

function jenkinsBackup {
	mkdir -p $LOCAL/$DATE_jenkins
	JNKLIST=$( cut -d' ' -f5 ${JNKXML} | paste -d' ' -s )
	JNKARR=( ${JNKLIST} )
	for i in ${JNKARR[@]}; do
		echo $i
	done
#	rsync -avz --include="*.xml" --exclude '*' $JNKDIR/ $LOCAL/$DATE_jenkins
#	cd $LOCAL && tar -zcvf $DATE_jenkins.tar.gz $DATE_jenkins/
}

function gitBackup {
	sudo gitlab-rake gitlab:backup:create STRATEGY=copy
}

function mysqlBackup {
	for i in "${SQLARRAY[@]}"; do
		mysqldump -h $HOST -v -u $USER -p $PASSWORD $i > $LOCAL/$i.sql
	done
}

function compressBackup {
	for i in "${BCKARRAY[@]}"; do
        	gzip $i
	done
}

function cleanBackup {
	if [ $BCKCOUNT -gt 2 ]
		then
			find ${LOCAL}/* -type f -ctime +3 -exec rm -rf {} \; &> $LOG
			echo "Cleaning older than 2 weeks backup from ${LOCAL}"
		else
			echo "There is no older than 3 days backup to delete"
	fi
}

function uploadBackup {
	for i in "${BCKARRAY[@]}"; do
                gsutil cp $i $EXTERNAL/
        done
}

function help() # Show a list of functions
{
    grep "^function" $0
}

#$ACTION

if [ "_$1" = "_" ]; then
    help
else
    "$@"
fi
