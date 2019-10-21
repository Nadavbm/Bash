#!/bin/bash
#
##
###
#### GitLab cool script
###
##
#
# Create backups of the repositories as file and zip them all
#

OLD="set.gitlab.server.with.old.version"
NEW="set.gitlab.server.with.new.version"

function setSSHconfig {
	echo "# Old GitLab server (for cloning) \n
Host $OLD \n
  Hostname $OLD \n
  RSAAuthentication yes \n
  IdentityFile /root/.ssh/id_rsa \n
  User gitAdmin \n
  PreferredAuthentications publickey \n
\n
# New GitLab server (for pushing) \n
Host $NEW \n
  Hostname $NEW \n
  RSAAuthentication yes \n
  IdentityFile /root/.ssh/id_rsa \n
  User git \n
  PreferredAuthentications publickey \n
  IdentitiesOnly yes \n" >> /etc/sshd_config
}

function cloneRepositories {
	DATE=$( date +%F )
	ROOTDIR=/data/gitlab/repositories
	LOG=/data/gitlab/logs/CloneLog_${DATE}.txt
	REPOLIST=/data/gitlab/lists/RepoList.txt
	LIST=$( cut -d' ' -f5 ${REPOLIST} | paste -d' ' -s )
	PROJECT=( ${LIST} )
	for i in ${PROJECT[@]}; do
	  if [ -d "${ROOTDIR}/${i}" ]; then
	    echo "${i} directory is already exist" 3>&1 1>>${LOG} 2>&1
	  else
 	   mkdir -p ${ROOTDIR}/${i} 3>&1 1>>${LOG} 2>&1
 	   cd ${ROOTDIR}/${i} && cd .. && git clone git@${OLD}:${i}.git 3>&1 1>>${LOG} 2>&1
	  fi
	done
}

function backupAsFiles {
	DATE=$( date +%F )
	BACKUPDIR=/data/gitlab/backup
	ROOTDIR=/data/gitlab/repositories
	LOG=/data/gitlab/logs/BackupLog_${DATE}.txt

	find /data/gitlab/repositories/ -maxdepth 1 -mindepth 1 -type d -exec basename {} \; > /data/gitlab/lists/BackupList.txt
	BACKUPLIST=/date/gitlab/lists/BackupList.txt
	LIST=$( cut -d' ' -f5 ${BACKUPLIST} | paste -d' ' -s )
	PROJECT=( ${LIST} 
	
	for i in ${PROJECT[@]}; do
	  cp -rv ${ROOTDIR}/${i} ${BACKUPDIR}/${DATE}_backup/ 3>&1 1>>${LOG} 2>&1
	  cd ${BACKUPDIR}/${DATE}_backup/ && yes | gzip ${i} 3>&1 1>>${LOG} 2>&1
	done
	sleep 30
	cd ${BACKUPDIR} && tar zcvf ${DATE}_backup.tar.gz ${DATE}_backup/ 3>&1 1>>${LOG} 2>&1
	sleep 30
	rm -rf ${BACKUPDIR}/${DATE}_backup/
}

# Create namespaces automatically from a list in new gitLab server
function createNamespace {
	TOKEN="CreateAPItokenAndAdditHere"

	REPOLIST=/data/gitlab/lists/RepoList.txt
	LIST=$( cut -d' ' -f5 ${REPOLIST} | paste -d' ' -s )
	PROJECT=( ${LIST} )
	LOG=/data/gitlab/logs/NameSpace.txt

	for i in ${PROJECT[@]}; do
 	 GROUP=$( echo ${i} | cut -d'/' -f 1 )
 	 echo ${GROUP}
	  curl -k --header "PRIVATE-TOKEN: ${TOKEN}" -X POST --data "name=${GROUP}&path=${GROUP}&visibility=private&description=UseYourOldBackupsFromGitLabOtherVersion" https://${NEW}/api/v3/groups 3>&1 1>>${LOG} 2>&1
	  sleep 5
	  NAMESPACE=$( echo ${i} | cut -d'/' -f 2 )
	  OUTPUT=$( curl -k -L -H "PRIVATE-TOKEN: ${TOKEN}" https://${NEW}/api/v3/groups?search=${GROUP} )
	  ID=$( echo ${OUTPUT} | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[0]["id"]' )
 	 echo "The group name is: ${GROUP} and group id is: ${ID}"
 	 sleep 5
	  curl -k --request PUT --header "PRIVATE-TOKEN: ${TOKEN}" "https://${NEW}/api/v4/groups/${ID}?visibility=private" 3>&1 1>>${LOG} 2>&1
 	 sleep 5
 	 curl -k --header "PRIVATE-TOKEN: ${TOKEN}" -X POST "https://${NEW}/api/v3/projects?name=${NAMESPACE}&namespace_id=${ID}" 3>&1 1>>${LOG} 2>&1
	done
}
 
function pushRepositories {
	ROOTDIR=/data/gitlab/repositories
	REPOLIST=/data/gitlab/lists/RepoList.txt
	LIST=$( cut -d' ' -f5 ${REPOLIST} | paste -d' ' -s )
	PROJECT=( ${LIST} )

	DATE=$( date +%F )
	LOG=/storage/gitlab/logs/PushLog_${DATE}.txt

	for i in ${PROJECT[@]}; do
  		cd ${ROOTDIR}/${i} && git push origin --mirror ssh://git@${NEW}/${i}.git 3>&1 1>>${LOG} 2>&1
	done
}

# Perform the action by parameter of $1
if [ "_$1" = "_" ]; then
    help
else
    "$@"
fi

