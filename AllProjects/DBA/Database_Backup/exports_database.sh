#!/bin/bash
#
# Exporting the database
#
#
# 
# Gururaj   01/Jan/2011  -  CREATION
#

function SendMail
{
/usr/sbin/sendmail -t <<EOF
From: $FROM_MAIL
To: $EMAIL
Cc: $LEADS_EMAIL,$GROUP_EMAIL
Subject: "Database Dump has taken successfully Please see the logs"
`cat alarm.mail`
EOF
}



function header
{
                echo "Dear EAMS Team,"
                echo " "

}

function footer
{
                echo " " 
                echo "Regards,"
                echo "Database Backup Monitoring Applications"
}

function display
{
                echo "Date              : `date` "
                echo "Hostname  : $HostName"

}
EMAIL=dnhk64@motorola.com
LEADS_EMAIL=fbkr46@motorola.com;sree@motorola.com
GROUP_EMAIL=eamsgrp@motorola.com
FROM_MAIL=dnhk64@motorola.com

touch alarm.mail
source /scripts/oracle/env/Oracle_Env_Files.sh

HOSTNAME=`hostname -i`

header >alarm.mail

# Check the access on backup directory

if [ ! -w "${DUMP_DIR}" ]
then
  echo "ERROR: Target backup directory is not accesible"
  echo ""
  echo "**** Backup ABORTED at `date` !!! ****"
  echo ""
  exit 1
fi

exp userid=system/manager full=y file=${DUMP_DIR}/full_${ORACLE_SID}_$THISDATE.dmp log=${LOG_DIR}/full_${ORACLE_SID}_$THISDATE.log STATISTICS=NONE

DUMP_NAME=${ORACLE_SID}_$THISDATE.dmp

EXITCODE=$?
export EXITCODE

if [ "$EXITCODE" -ne 0 ]
then
 echo "ERROR: SQL*Plus exit code: $EXITCODE"
 echo ""
 echo "**** Backup ABORTED at `date` !!! ****"
 echo "$DUMP_NAME from $HOSTNAME server has errors.Please see the error logs" >>alarm.mail
 echo " "
 footer >>alarm.mail
 SendMail;
exit 1;
else 
echo "Database ${ORACLE_SID}_$THISDATE.dmp has been taken successfully"
echo "$DUMP_NAME from $HOSTNAME server has been taken successfully" >>alarm.mail
footer >>alarm.mail
SendMail;
fi


rm alarm.mail

echo ""
echo "**** End - EXP Complete database backup of ${ORACLE_SID} at `date` ****"
echo ""

