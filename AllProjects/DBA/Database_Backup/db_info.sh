#!/bin/ksh

USAGE="usage: db_info.sh ORACLE_SID"

if (($#==1)) then
   export ORACLE_SID=$1
else
   print "$USAGE";
   exit 1;
fi

sqlplus /nolog << EOF
SET lines 132
SET pages 50000
SET echo off

connect / as sysdba

COL GLOBAL_NAME FORMAT A20
COL BANNER FORMAT A40
COL LOG_SWITCHES FORMAT 999
COL MB_PER_LOG FORMAT 999
COL TOTAL_GB_DATA_FILES FORMAT 999

SELECT *
FROM   (SELECT * FROM GLOBAL_NAME) a,
       (SELECT * FROM v\$version WHERE banner LIKE 'Oracle Database%') b,
       (SELECT COUNT(*) log_switches
        FROM   v\$log_history
        WHERE  first_time > TO_DATE('20100101', 'yyyymmdd')) c,
       (SELECT AVG(bytes/1024/1024) mb_per_log FROM v\$log) d,
       (SELECT TRUNC(SUM(bytes)/1024/1024/1024) total_gb_data_files FROM v\$DATAFILE) e;
EOF