connect SYS/change_on_install as SYSDBA
set echo on
spool /opt/db01/app/oracle/admin/SID/create/JServer.log
@/opt/db01/app/oracle/product/9.2.0/javavm/install/initjvm.sql;
@/opt/db01/app/oracle/product/9.2.0/xdk/admin/initxml.sql;
@/opt/db01/app/oracle/product/9.2.0/xdk/admin/xmlja.sql;
@/opt/db01/app/oracle/product/9.2.0/rdbms/admin/catjava.sql;
spool off
exit;
