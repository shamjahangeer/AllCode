connect SYS/change_on_install as SYSDBA
set echo on
spool /oracle/oradata/admin/SID/create/CreateDBCatalog.log
@/oracle/ora9i/product/9iR2/rdbms/admin/catalog.sql;
@/oracle/ora9i/product/9iR2/rdbms/admin/catexp7.sql;
@/oracle/ora9i/product/9iR2/rdbms/admin/catblock.sql;
@/oracle/ora9i/product/9iR2/rdbms/admin/catproc.sql;
@/oracle/ora9i/product/9iR2/rdbms/admin/catoctk.sql;
@/oracle/ora9i/product/9iR2/rdbms/admin/catobtk.sql;
@/oracle/ora9i/product/9iR2/rdbms/admin/caths.sql;
@/oracle/ora9i/product/9iR2/rdbms/admin/owminst.plb;
connect SYSTEM/manager
@/oracle/ora9i/product/9iR2/sqlplus/admin/pupbld.sql;
spool off
spool /oracle/oradata/admin/SID/create/sqlPlusHelp.log
connect SYSTEM/manager
set echo on
@/oracle/ora9i/product/9iR2/sqlplus/admin/help/hlpbld.sql helpus.sql;
spool off
exit;
