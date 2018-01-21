connect SYS/change_on_install as SYSDBA
set echo on
spool /opt/db01/app/oracle/admin/SID/create/CreateClustDBViews.log
@/opt/db01/app/oracle/product/9.2.0/rdbms/admin/catclust.sql;
spool off
exit;
