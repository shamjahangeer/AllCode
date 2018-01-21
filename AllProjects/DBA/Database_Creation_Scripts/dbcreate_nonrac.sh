
#
# Stand-alone Database Creation
#

# 
# Notes: 
# Assumptions:
# 	1. /etc/system files is configured with necessary shared memory & semaphores parameters for the support of this new database.

Usage()
{
   echo "" >&2
   echo "Usage:  dbcreate_nonrac.sh <SUB_SYSTEM> <SID> <DOMAIN_NAME> <LISTENER_IP>" >&2
   echo "" >&2
   echo "          <SID> - Oracle SID (Example: sm01dbsp)" >&2
   echo "          <DOMAIN_NAME> - Oracle Domain Name (Example: leapstone.com)" >&2
   echo "          <LISTENER_IP> - Oracle Listener IP Address on the Server (Example: 192.168.1.1)" >&2
   echo "" >&2
   exit 1
}

#
# check usage
#
if [ $# != "4" ];then
  Usage;exit 1
fi

SUB_SYSTEM=$1; export SUB_SYSTEM
SID=$2; export SID
DOMAIN_NAME=$3; export DOMAIN_NAME
LISTENER_IP=$4; export LISTENER_IP

LOGDIR=/tmp; export LOGDIR
LOGFILE=${LOGDIR}/dbcreate.${SID}.log; export LOGFILE

echo ""
echo "Stand-alone Database ${SID} Creation"
echo "Log will be written to ${LOGFILE}"
echo ""

### log file

exec >>${LOGFILE}
exec 2>&1

echo ""
echo "**** Start - Stand-alone Database ${SID} Creation at `date` ****"
echo "Command:  $0 $1 $2 $3 $4"
echo ""

mv SID.sh ${SID}.sh
mv initSID.ora init${SID}.ora
if [ $SUB_SYSTEM = "si" ] || [ $SUB_SYSTEM = "SI" ]
then
    mv si_init.ora init.ora
    mv CreateSIDB.sql CreateDB.sql
    mv CreateSITblspcFiles.sql CreateTblspcFiles.sql
elif [ $SUB_SYSTEM = "sc" ] || [ $SUB_SYSTEM = "SC" ]
then 
     mv sc_init.ora init.ora
fi

sed 's/SID/'${SID}'/g' CreateTblspcFiles.sql > CreateTblspcFiles.sql.tmp
sed 's/SID/'${SID}'/g' CreateDB.sql > CreateDB.sql.tmp
sed 's/SID/'${SID}'/g' CreateDBCatalog.sql > CreateDBCatalog.sql.tmp
sed 's/SID/'${SID}'/g' CreateDBFiles.sql > CreateDBFiles.sql.tmp
sed 's/SID/'${SID}'/g' JServer.sql > JServer.sql.tmp
sed 's/SID/'${SID}'/g' postDBCreation.sql > postDBCreation.sql.tmp
sed 's/SID/'${SID}'/g' ${SID}.sh > ${SID}.sh.tmp1
sed 's/'ORACLE_${SID}'/'ORACLE_SID'/g' ${SID}.sh.tmp1 > ${SID}.sh.tmp
rm ${SID}.sh.tmp1

sed 's/SID/'${SID}'/g' init.ora | sed 's/DOMAIN_NAME/'${DOMAIN_NAME}'/g' | sed 's/LISTENER_IP/'${LISTENER_IP}'/g' > init.ora.tmp
sed 's/SID/'${SID}'/g' init${SID}.ora > init${SID}.ora.tmp
sed 's/DBSID/'${SID}'/g' listener_block.ora > listener_block.ora.tmp
sed 's/DBSID/'${SID}'/g' listener.ora | sed 's/LISTENER_IP/'${LISTENER_IP}'/g' > listener.ora.tmp
sed 's/DBSID/'${SID}'/g' tnsnames.ora | sed 's/DOMAIN_NAME/'${DOMAIN_NAME}'/g' | sed 's/LISTENER_IP/'${LISTENER_IP}'/g' > tnsnames.ora.tmp

mv CreateTblspcFiles.sql.tmp CreateTblspcFiles.sql
mv CreateDB.sql.tmp CreateDB.sql
mv CreateDBCatalog.sql.tmp CreateDBCatalog.sql
mv CreateDBFiles.sql.tmp CreateDBFiles.sql
mv JServer.sql.tmp JServer.sql
mv postDBCreation.sql.tmp postDBCreation.sql
mv ${SID}.sh.tmp ${SID}.sh
mv init.ora.tmp init.ora
mv init${SID}.ora.tmp init${SID}.ora
mv listener_block.ora.tmp listener_block.ora
mv listener.ora.tmp listener.ora
mv tnsnames.ora.tmp tnsnames.ora

chmod u+x *sh

mkdir -p /oracle/oradata/admin/${SID}/scripts
cp -rp * /oracle/oradata/admin/${SID}/scripts

mkdir -p /u01/oradata/${SID}
mkdir -p /u02/oradata/${SID}
mkdir -p /u03/oradata/${SID}
mkdir -p /u04/oradata/${SID}
mkdir -p /u05/oradata/${SID}
mkdir -p /u06/oradata/${SID}
mkdir -p /u07/oradata/${SID}
mkdir -p /u08/oradata/${SID}
mkdir -p /u09/oradata/${SID}
mkdir -p /u10/oradata/${SID}
mkdir -p /u11/oradata/${SID}
mkdir -p /u12/oradata/${SID}
mkdir -p /u13/oradata/${SID}
mkdir -p /u14/oradata/${SID}
mkdir -p /u15/oradata/${SID}
mkdir -p /u16/oradata/${SID}
mkdir -p /u17/oradata/${SID}
mkdir -p /u18/oradata/${SID}
mkdir -p /u19/oradata/${SID}
mkdir -p /u20/oradata/arch/${SID}

### Create Stand-alone Database
sh /oracle/oradata/admin/${SID}/scripts/${SID}.sh

/oracle/ora9i/product/9iR2/bin/sqlplus /nolog @/oracle/oradata/admin/${SID}/scripts/CreateTblspcFiles.sql

### Configure Listener 
if [ -f /oracle/ora9i/product/9iR2/network/admin/listener.ora ]
then
   cp /oracle/ora9i/product/9iR2/network/admin/listener.ora listener.ora
fi

 ./insertBlock.sh
 mv listener.ora.out listener.ora
 cp -p listener.ora /oracle/ora9i/product/9iR2/network/admin/listener.ora

lsnrctl stop
lsnrctl start


echo ""
echo "**** End - Stand-alone Database ${SID} Creation at `date` ****"
echo ""
