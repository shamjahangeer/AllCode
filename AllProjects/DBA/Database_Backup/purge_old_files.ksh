#!/bin/ksh
USAGE="purge_old_files.ksh PURGE_DIR"

if (($#==1)) then
   export PURGE_DIR=$1
else
   print "$USAGE";
   exit 1;
fi

export SCRIPT_DIR=/usr2/opt/oracle_daily_backups/bin
export SCRIPT_NAME=purge.sh
export SCRIPT=$SCRIPT_DIR/$SCRIPT_NAME
export DAY_AFTER=30

find  $PURGE_DIR/* -mtime +$DAY_AFTER | awk '{print "/bin/rm " $1}' > $SCRIPT
chmod 700 $SCRIPT

set -x
$SCRIPT
/bin/rm $SCRIPT
