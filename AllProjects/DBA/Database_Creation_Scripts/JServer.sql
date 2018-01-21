connect SYS/change_on_install as SYSDBA
set echo on
spool /oracle/oradata/admin/SID/create/JServer.log
@/oracle/ora9i/product/9iR2/javavm/install/initjvm.sql;
@/oracle/ora9i/product/9iR2/xdk/admin/initxml.sql;
@/oracle/ora9i/product/9iR2/xdk/admin/xmlja.sql;
@/oracle/ora9i/product/9iR2/rdbms/admin/catjava.sql;
spool off
exit;
