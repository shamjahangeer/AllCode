#!/bin/sh

ORACLE_SID=SID; export ORACLE_SID

#set ORACLE_SID=SID
#Add this entry in the oratab: SID:/oracle/ora9i/product/9iR2:Y

mkdir -p /oracle/oradata/admin/SID/pfile
mkdir -p /oracle/oradata/admin/SID/bdump
mkdir -p /oracle/oradata/admin/SID/cdump
mkdir -p /oracle/oradata/admin/SID/udump
mkdir -p /oracle/oradata/admin/SID/create
mkdir -p /oracle/oradata/admin/SID/network/log
mkdir -p /opt/db02/oradata/SID

cat /oracle/oradata/admin/SID/scripts/tnsnames.ora >> /oracle/ora9i/product/9iR2/network/admin/tnsnames.ora

echo "SID:/oracle/ora9i/product/9iR2:Y" >> /var/opt/oracle/oratab

cp -p /oracle/oradata/admin/SID/scripts/init.ora /oracle/oradata/admin/SID/pfile/
orapwd file=/oracle/ora9i/product/9iR2/dbs/orapwSID password=change_on_install
/oracle/ora9i/product/9iR2/bin/sqlplus /nolog @/oracle/oradata/admin/SID/scripts/CreateDB.sql
/oracle/ora9i/product/9iR2/bin/sqlplus /nolog @/oracle/oradata/admin/SID/scripts/CreateDBFiles.sql
/oracle/ora9i/product/9iR2/bin/sqlplus /nolog @/oracle/oradata/admin/SID/scripts/CreateDBCatalog.sql
/oracle/ora9i/product/9iR2/bin/sqlplus /nolog @/oracle/oradata/admin/SID/scripts/JServer.sql
/oracle/ora9i/product/9iR2/bin/sqlplus /nolog @/oracle/oradata/admin/SID/scripts/postDBCreation.sql
cp -p /oracle/oradata/admin/SID/scripts/initSID.ora /oracle/ora9i/product/9iR2/dbs/
