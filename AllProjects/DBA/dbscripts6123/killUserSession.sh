#!/bin/ksh
set -x

CURRENT_DIR=`dirname $0`
if [ "$CURRENT_DIR" = "." ] ; then
   CURRENT_DIR=`pwd`
fi

export SCRIPT_DIR=$CURRENT_DIR
. ${SCRIPT_DIR}/setEnv

Usage()
{
   echo "" >&2
   echo "Usage:  killUserSession.sh <oracle_user>" >&2
   echo "" >&2
   exit 1
}

#
# check usage
#
if ! [ $# -eq 1 ];then
  Usage;exit 1
fi


export ORACLE_USER=$1
export LOGFILE=${LOGDIR}/killUserSession.${DATABASE}.log

echo ""
echo "Running killUserSession.sh"
echo "Log will be written to ${LOGFILE}"
echo ""

### log file

exec >>${LOGFILE}
exec 2>&1

echo ""
echo "**** Start - Running killUserSession.sh at `date` ****"
echo "Command:  $0 $*"
echo ""

# To run this script, login as Oracle 'system' user.
# Usage: @dropUserAccount.sql smadmin
sqlplus -s /nolog <<EOF
conn system/${SYSTEM_PASSWD}@${DATABASE}
show user
set echo off
set feedback off
rem set termout off
set linesize 100
set pagesize 0
alter user $ORACLE_USER account lock;
select 'alter system kill session '''||sid||','||serial#||''' immediate ;' from v\$session where username in (UPPER('$ORACLE_USER'));
spool /tmp/kill_sessions.sql
/
spool off
show user
spool /tmp/kill_sessions.log
set termout on
set feedback on
@/tmp/kill_sessions.sql
@@/tmp/kill_sessions.sql 
spool off
show user                                  
set serveroutput on                        
@$SCRIPT_DIR/kill_procedure.sql            
EOF

echo ""
echo "**** End - Running killUserSession.sh at `date` ****"
echo ""
