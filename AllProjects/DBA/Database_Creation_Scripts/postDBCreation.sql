connect SYS/change_on_install as SYSDBA
set echo on
spool /oracle/oradata/admin/SID/create/postDBCreation.log
create spfile='/oracle/ora9i/product/9iR2/dbs/spfileSID.ora' FROM pfile='/oracle/oradata/admin/SID/pfile/init.ora';

-- for Bug:1828996, while using export utility
GRANT EXECUTE ON sys.lt_export_pkg TO PUBLIC;

shutdown
connect SYS/change_on_install as SYSDBA
startup
exit
