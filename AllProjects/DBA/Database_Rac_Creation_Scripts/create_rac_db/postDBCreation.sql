connect SYS/change_on_install as SYSDBA
set echo on
spool /opt/db01/app/oracle/admin/SID/create/postDBCreation.log
create spfile='/dev/vx/rdsk/racdg/db_SID_spfile1' FROM pfile='/opt/db01/app/oracle/admin/SID/pfile/init.ora';
create spfile='/dev/vx/rdsk/racdg/db_SID_spfile2' FROM pfile='/opt/db01/app/oracle/admin/SID/pfile/init.ora';

-- for Bug:1828996, while using export utility
GRANT EXECUTE ON sys.lt_export_pkg TO PUBLIC;

shutdown ;
connect SYS/change_on_install as SYSDBA
startup pfile="/opt/db01/app/oracle/admin/SID/pfile/init.ora";
ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 5 ('/dev/vx/rdsk/racdg/db_SID_redo2_51') REUSE,
 GROUP 6 ('/dev/vx/rdsk/racdg/db_SID_redo2_61') REUSE,
 GROUP 7 ('/dev/vx/rdsk/racdg/db_SID_redo2_71') REUSE,
 GROUP 8 ('/dev/vx/rdsk/racdg/db_SID_redo2_81') REUSE;
ALTER DATABASE ENABLE PUBLIC THREAD 2;
shutdown ;
exit
