connect SYS/change_on_install as SYSDBA
set echo on
spool /opt/db01/app/oracle/admin/SID/create/CreateDB.log
startup nomount pfile="/opt/db01/app/oracle/admin/SID/pfile/init.ora";
CREATE DATABASE SID
CONTROLFILE REUSE
MAXDATAFILES 254
MAXINSTANCES 32
MAXLOGHISTORY 100
MAXLOGMEMBERS 5
MAXLOGFILES 64
DATAFILE '/dev/vx/rdsk/racdg/db_SID_system1' SIZE 500M REUSE AUTOEXTEND ON NEXT  10M MAXSIZE 1000M
UNDO TABLESPACE "UNDOTBS" DATAFILE '/dev/vx/rdsk/racdg/db_SID_undotbs1' SIZE 500M REUSE AUTOEXTEND ON NEXT  10M MAXSIZE 1000M
CHARACTER SET US7ASCII
NATIONAL CHARACTER SET AL16UTF16
LOGFILE GROUP 1 ('/dev/vx/rdsk/racdg/db_SID_redo1_11') REUSE,
GROUP 2 ('/dev/vx/rdsk/racdg/db_SID_redo1_21') REUSE,
GROUP 3 ('/dev/vx/rdsk/racdg/db_SID_redo1_31') REUSE,
GROUP 4 ('/dev/vx/rdsk/racdg/db_SID_redo1_41') REUSE;
spool off
exit;
