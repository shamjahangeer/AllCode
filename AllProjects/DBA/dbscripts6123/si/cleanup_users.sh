#!/bin/sh
CURRENT_DIR=`dirname $0`
if [ "$CURRENT_DIR" = "." ] ; then
   CURRENT_DIR=`pwd`
fi

. $CURRENT_DIR/../setEnv

$ORACLE_HOME/bin/sqlplus -s /nolog << EOF
  CONN sys/$SYS_PASSWD@$DATABASE as sysdba 
  set echo on
  
  SPOOL ${LOGDIR}/cleanup_users.lst
  
  @@eams_drop_users.sql
  @@eams_create_users.sql

  SPOOL off
EOF
