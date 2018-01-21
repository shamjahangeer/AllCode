connect SYS/change_on_install as SYSDBA
set echo on
spool /opt/db01/app/oracle/admin/SID/create/CreateDBCatalog.log
@/opt/db01/app/oracle/product/9.2.0/rdbms/admin/catalog.sql;
@/opt/db01/app/oracle/product/9.2.0/rdbms/admin/catexp7.sql;
@/opt/db01/app/oracle/product/9.2.0/rdbms/admin/catblock.sql;
@/opt/db01/app/oracle/product/9.2.0/rdbms/admin/catproc.sql;
@/opt/db01/app/oracle/product/9.2.0/rdbms/admin/catoctk.sql;
@/opt/db01/app/oracle/product/9.2.0/rdbms/admin/catobtk.sql;
@/opt/db01/app/oracle/product/9.2.0/rdbms/admin/caths.sql;
@/opt/db01/app/oracle/product/9.2.0/rdbms/admin/owminst.plb;
connect SYSTEM/manager
@/opt/db01/app/oracle/product/9.2.0/sqlplus/admin/pupbld.sql;
spool off
spool /opt/db01/app/oracle/admin/SID/create/sqlPlusHelp.log
connect SYSTEM/manager
set echo on
@/opt/db01/app/oracle/product/9.2.0/sqlplus/admin/help/hlpbld.sql helpus.sql;
spool off
exit;
