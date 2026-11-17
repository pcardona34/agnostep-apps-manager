#!/bin/bash

####################################################
### AGNoStep  -  Apps Manager
### (c) 2026 Patrick Cardona
###
### Thanks for the GNUstep Developers Community
### This is Free and Open Source software.
### Read License in the root directory.
####################################################

################################
### Log
### Managing Agnostep Log
################################

LOG=/var/log/agnostep-apps.log
if [ ! -f $LOG ];then
	sudo touch $LOG
	sudo chown ${USER}:${USER} $LOG
fi

date >> $LOG

######################################
### is_log_ok
######################################

function is_log_ok
{
PART="$1"

STR="Checking $PART installation..."
subtitulo

local _COUNT=0

grep -v -e " (ignor" $LOG | grep -e " Error " &>/dev/null
if [ $? -eq 0 ];then
	_COUNT=$(( $_COUNT + 1 ))
fi
grep -v -e " error: nil" $LOG | grep -v -e " error: &" | grep -v -e "${EXCEPTION_DBUSKIT}" grep -e " error: " &>/dev/null
if [ $? -eq 0 ];then
	_COUNT=$(( $_COUNT + 1 ))
fi

if [ ${_COUNT} -ne 0 ];then
	alert "$PART installation has generated ${_COUNT} true error(s): check the logs."
	exit 1
else
	info "$PART installation was successful. You can go forward."
	sleep 4
fi
}


function clear_logs
{
for LOG in /var/log/agnostep-apps.log
do
	echo $LOG;truncate $LOG --size 0
done
printf "All the logs were truncated.\n"
}

function reset_log
{
echo "AGNoStep Apps Manager: init log" > $LOG
date >> $LOG

echo -e "\nLog has been reset.\n";sleep 2

}
