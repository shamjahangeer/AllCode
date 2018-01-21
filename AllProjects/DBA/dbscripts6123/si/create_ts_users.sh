#!/bin/sh
CURRENT_DIR=`dirname $0`
if [ "$CURRENT_DIR" = "." ] ; then
   CURRENT_DIR=`pwd`
fi

. $CURRENT_DIR/../setEnv

$ORACLE_HOME/bin/sqlplus -s /nolog << EOF
  CONN sys/$SYS_PASSWD@$DATABASE as sysdba
  set echo on
  
  SPOOL ${LOGDIR}/eams_ts_user_create.lst
  
  @@eams_create_ts.sql ${SI_TS_ROOT}
  @@eams_create_users.sql

  SPOOL off
EOF
