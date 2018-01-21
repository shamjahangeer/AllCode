connect SYS/change_on_install as SYSDBA
set echo on
spool /oracle/oradata/admin/SID/create/CreateDBFiles.log
CREATE TABLESPACE "USERS" LOGGING DATAFILE '/u11/oradata/SID/users01.dbf' SIZE 100M REUSE AUTOEXTEND ON NEXT  10M MAXSIZE 2000M EXTENT MANAGEMENT LOCAL;
spool off
exit;
