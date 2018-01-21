#!/bin/ksh
# =====================================================================
#
# Written By   : Andre Tan
# Written On   : November 09, 2009
#
# =====================================================================
#

USAGE="usage: exp_db.sh ORACLE_SID"

if (($#==1)) then
   export ORACLE_SID=$1
else
   print "$USAGE";
   exit 1;
fi 

export JAVA_HOME=/home/oracle/util/jre/jre1.6.0_17
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=/home/oracle/util/java/lib/mail.jar:/home/oracle/util/monitor/lib/util.jar
export THISDATE=`date '+%Y%m%d'`
export ORACLE_HOME=/usr2/opt/oracle/product/11.1.0/db_1
export PATH=$ORACLE_HOME/bin:$PATH:.
export BACKUP_ROOT_DIR=/usr2/opt/oracle_daily_backups
export BACKUP_DMP_DIR=$BACKUP_ROOT_DIR/dmp
export BACKUP_TMP_DIR=$BACKUP_ROOT_DIR/tmp
export BACKUP_LOG_DIR=$BACKUP_ROOT_DIR/log
export DMP_FILE=$BACKUP_DMP_DIR/full_${ORACLE_SID}_$THISDATE.dmp.gz
export LOG_FILE=$BACKUP_LOG_DIR/full_${ORACLE_SID}_$THISDATE.log
export USER=exp_user
export PWD=exp_user
export FYI=$BACKUP_LOG_DIR/fyi

export PIPE=$BACKUP_TMP_DIR/exp_tmp.dmp
ulimit unlimited

rm $PIPE
mknod $PIPE p

gzip < $PIPE > $DMP_FILE &
sleep 30
exp $USER/$ORACLE_SID full=y file=$PIPE log=$LOG_FILE statistics=none

export EXPORT_STATUS=`tail -1 $LOG_FILE`

if [[ ${EXPORT_STATUS} = "Export terminated successfully without warnings." ]] then
   echo "FYI" > $FYI
   # mail -s "Export $(hostname)-$ORACLE_SID $THISDATE Successfully" "xdpr38@motorola.com" < $FYI
   java com.motorola.cce.util.SendMail 10.177.8.55 xdpr38@motorola.com xdpr38@motorola.com "" "" "Export $(hostname)-$ORACLE_SID $THISDATE Successfully" "" "" $FYI 25
else
   # mail -s "Export $(hostname)-$ORACLE_SID $THISDATE with Warning" "xdpr38@motorola.com" < $LOG_FILE
   java com.motorola.cce.util.SendMail 10.177.8.55 xdpr38@motorola.com xdpr38@motorola.com "" "" "Export $(hostname)-$ORACLE_SID $THISDATE with Errors" "" "" $LOG_FILE 25
fi

exit;

