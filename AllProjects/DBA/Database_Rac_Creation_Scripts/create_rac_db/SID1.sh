#!/usr/bin/sh

ORACLE_SID=SID1; export ORACLE_SID

#set ORACLE_SID=SID1
#Add this entry in the oratab: SID:/opt/db01/app/oracle/product/9.2.0:Y

mkdir -p /opt/db01/app/oracle/admin/SID/pfile
mkdir -p /opt/db01/app/oracle/admin/SID/bdump
mkdir -p /opt/db01/app/oracle/admin/SID/cdump
mkdir -p /opt/db01/app/oracle/admin/SID/udump
mkdir -p /opt/db01/app/oracle/admin/SID/create
rsh NODE2_IP mkdir -p /opt/db01/app/oracle/admin/SID/scripts
rsh NODE2_IP mkdir -p /opt/db01/app/oracle/admin/SID/pfile
rsh NODE2_IP mkdir -p /opt/db01/app/oracle/admin/SID/bdump
rsh NODE2_IP mkdir -p /opt/db01/app/oracle/admin/SID/cdump
rsh NODE2_IP mkdir -p /opt/db01/app/oracle/admin/SID/udump
rsh NODE2_IP mkdir -p /opt/db01/app/oracle/admin/SID/create

###lsnrctl stop
cat /opt/db01/app/oracle/admin/SID/scripts/tnsnames1.ora >> /opt/db01/app/oracle/product/9.2.0/network/admin/tnsnames.ora
rcp -p /opt/db01/app/oracle/admin/SID/scripts/tnsnames2.ora NODE2_IP:/tmp/node2_tnsnames.ora
rsh NODE2_IP cat /tmp/node2_tnsnames.ora ">>" /opt/db01/app/oracle/product/9.2.0/network/admin/tnsnames.ora
rsh NODE2_IP rm /tmp/node2_tnsnames.ora

echo "SID:/opt/db01/app/oracle/product/9.2.0:Y" >> /var/opt/oracle/oratab
cp -p /opt/db01/app/oracle/admin/SID/scripts/init.ora /opt/db01/app/oracle/admin/SID/pfile/
/opt/db01/app/oracle/admin/SID/scripts/orapw-config.sh
/opt/db01/app/oracle/product/9.2.0/bin/sqlplus /nolog @/opt/db01/app/oracle/admin/SID/scripts/CreateDB.sql
/opt/db01/app/oracle/product/9.2.0/bin/sqlplus /nolog @/opt/db01/app/oracle/admin/SID/scripts/CreateDBFiles.sql
/opt/db01/app/oracle/product/9.2.0/bin/sqlplus /nolog @/opt/db01/app/oracle/admin/SID/scripts/CreateDBCatalog.sql
/opt/db01/app/oracle/product/9.2.0/bin/sqlplus /nolog @/opt/db01/app/oracle/admin/SID/scripts/JServer.sql
/opt/db01/app/oracle/product/9.2.0/bin/sqlplus /nolog @/opt/db01/app/oracle/admin/SID/scripts/CreateClustDBViews.sql
/opt/db01/app/oracle/product/9.2.0/bin/sqlplus /nolog @/opt/db01/app/oracle/admin/SID/scripts/CreateDBTblSpcs.sql
/opt/db01/app/oracle/product/9.2.0/bin/sqlplus /nolog @/opt/db01/app/oracle/admin/SID/scripts/postDBCreation.sql
cp -p /opt/db01/app/oracle/admin/SID/scripts/initSID1.ora $ORACLE_HOME/dbs/
rcp -p /opt/db01/app/oracle/admin/SID/scripts/init.ora NODE2_IP:/opt/db01/app/oracle/admin/SID/pfile/
rcp -p /opt/db01/app/oracle/admin/SID/scripts/initSID2.ora NODE2_IP:$ORACLE_HOME/dbs/
rcp -p /opt/db01/app/oracle/admin/SID/scripts/* NODE2_IP:/opt/db01/app/oracle/admin/SID/scripts/
rsh NODE2_IP /opt/db01/app/oracle/admin/SID/scripts/SID2.sh
