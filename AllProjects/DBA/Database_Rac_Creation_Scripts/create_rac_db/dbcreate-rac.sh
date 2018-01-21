#!/usr/bin/ksh
#
# RAC Database Creation
#

# 
# Notes: 
# Assumptions:
# 	1. /etc/system files is configured with necessary shared memory & semaphores parameters for the support of this new database.
# 	2. Required Filesystem and Raw volumes are created, as part of Pre Database creation planning.
#									SI		SM
#		- /opt/db01/app/oracle/admin/<SID>		1024M		1024M
#			For Database scripts, creation log, pfiles, bdump, cudump, udump, network listener log
#		- db_<SID>_orapwd					5M		5M
#		- db_<SID>_spfile1				5M		5M
#		- db_<SID>_spfile2				5M		5M
#		- db_<SID>_control1				200M		200M
#		- db_<SID>_control2				200M		200M
#		- db_<SID>_redo1_11				100M		200M
#		- db_<SID>_redo1_21				100M		200M
#		- db_<SID>_redo1_31				100M		200M
#		- db_<SID>_redo1_41				100M		200M
#		- db_<SID>_redo2_51				100M		200M
#		- db_<SID>_redo2_61				100M		200M
#		- db_<SID>_redo2_71				100M		200M
#		- db_<SID>_redo2_81				100M		200M
#		- db_<SID>_system1				1024M		2048M
#		- db_<SID>_undotbs1				512M		1024M
#		- db_<SID>_undotbs2				512M		1024M
#		- db_<SID>_temp1					512M		1024M
#		- db_<SID>_users1					1024M		2048M
# 

Usage()
{
   echo "" >&2
   echo "Usage:  dbcreate-rac.sh <SUB_SYSTEM> <SID> <DOMAIN_NAME> <NODE1NAME> <NODE2NAME> <NODE1_LISTENER_IP> <NODE2_LISTENER_IP> <NODE2_IP>" >&2
   echo "" >&2
   echo "          <SUB_SYSTEM> - CCE SUBSYSTEM(Example: sm/si/billing)" >&2
   echo "          <SID> - Oracle SID (Example: sm01dbsp)" >&2
   echo "          <DOMAIN_NAME> - Oracle Domain Name (Example: leapstone.com)" >&2
   echo "          <NODE1_LISTENER_IP> - Oracle Listener IP Address on Node2 (Example: 192.168.1.1)" >&2
   echo "          <NODE2_LISTENER_IP> - Oracle Listener IP Address on Node2 (Example: 192.168.1.2)" >&2
   echo "          <NODE2_IP> - Cluster Node2 IP Address (Example: 10.10.34.49)" >&2
   echo "" >&2
   exit 1
}

#
# check usage
#
if [ $# != "8" ];then
  Usage;exit 1
fi

SUB_SYSTEM=$1; export SUB_SYSTEM
SID=$2; export SID
DOMAIN_NAME=$3; export DOMAIN_NAME
NODE1NAME=$4; export NODE1NAME
NODE2NAME=$5; export NODE2NAME
NODE1_LISTENER_IP=$6; export NODE1_LISTENER_IP
NODE2_LISTENER_IP=$7; export NODE2_LISTENER_IP
NODE2_IP=$8; export NODE2_IP

LOGDIR=/tmp; export LOGDIR
LOGFILE=${LOGDIR}/dbcreate-rac.${SID}.log; export LOGFILE

echo ""
echo "RAC Database ${SID} Creation"
echo "Log will be written to ${LOGFILE}"
echo ""

### log file

exec >>${LOGFILE}
exec 2>&1

echo ""
echo "**** Start - RAC Database ${SID} Creation at `date` ****"
echo "Command:  $0 $1 $2 $3 $4 $5 $6 $7 $8"
echo ""


mv SID1.sh ${SID}1.sh
mv SID2.sh ${SID}2.sh
mv initSID1.ora init${SID}1.ora
mv initSID2.ora init${SID}2.ora
if [ ${SUB_SYSTEM} = "si" ] || [ ${SUB_SYSTEM} = "SI" ]
then
   mv init_si.ora init.ora
   sed 's/SID/'${SID}'/g' CreateDBTblSpcsSI.sql > CreateDBTblSpcsSI.sql.tmp
   mv CreateDBTblSpcsSI.sql.tmp CreateDBTblSpcs.sql
elif [ ${SUB_SYSTEM} = "billing" ] || [ ${SUB_SYSTEM} = "BILLING" ]
then
   mv init_billing.ora init.ora
   sed 's/SID/'${SID}'/g' CreateDBTblSpcsBILLING.sql > CreateDBTblSpcsBILLING.sql.tmp
   mv CreateDBTblSpcsBILLING.sql.tmp CreateDBTblSpcs.sql
else
   #### assume it is sm
   sed 's/SID/'${SID}'/g' CreateDBTblSpcsSM.sql > CreateDBTblSpcsSM.sql.tmp
   mv CreateDBTblSpcsSM.sql.tmp CreateDBTblSpcs.sql
fi

sed 's/SID/'${SID}'/g' CreateClustDBViews.sql > CreateClustDBViews.sql.tmp
sed 's/SID/'${SID}'/g' CreateDB.sql > CreateDB.sql.tmp
sed 's/SID/'${SID}'/g' CreateDBCatalog.sql > CreateDBCatalog.sql.tmp
sed 's/SID/'${SID}'/g' CreateDBFiles.sql > CreateDBFiles.sql.tmp
sed 's/SID/'${SID}'/g' JServer.sql > JServer.sql.tmp
sed 's/SID/'${SID}'/g' orapw-config.sh > orapw-config.sh.tmp
sed 's/SID/'${SID}'/g' postDBCreation.sql > postDBCreation.sql.tmp
sed 's/SID/'${SID}'/g' ${SID}1.sh | sed 's/NODE2_IP/'${NODE2_IP}'/g' > ${SID}1.sh.tmp1
sed 's/'ORACLE_${SID}'/'ORACLE_SID'/g' ${SID}1.sh.tmp1 > ${SID}1.sh.tmp
rm ${SID}1.sh.tmp1
sed 's/SID/'${SID}'/g' ${SID}2.sh > ${SID}2.sh.tmp
sed 's/SID/'${SID}'/g' init.ora | sed 's/DOMAIN_NAME/'${DOMAIN_NAME}'/g' | sed 's/NODE1_LISTENER_IP/'${NODE1_LISTENER_IP}'/g' | sed 's/NODE2_LISTENER_IP/'${NODE2_LISTENER_IP}'/g' > init.ora.tmp
sed 's/SID/'${SID}'/g' init${SID}1.ora > init${SID}1.ora.tmp
sed 's/SID/'${SID}'/g' init${SID}2.ora > init${SID}2.ora.tmp
sed 's/DBSID/'${SID}'/g' listener1_block.ora | sed 's/NODE1_LISTENER_IP/'${NODE1_LISTENER_IP}'/g' > listener1_block.ora.tmp

#####sed 's/DBSID/'${SID}'/g' listener2.ora | sed 's/NODE2_LISTENER_IP/'${NODE2_LISTENER_IP}'/g' > listener2.ora.tmp

sed 's/SID/'${SID}'/g' tnsnames1.ora | sed 's/DOMAIN_NAME/'${DOMAIN_NAME}'/g' | sed 's/NODE1_LISTENER_IP/'${NODE1_LISTENER_IP}'/g' | sed 's/NODE2_LISTENER_IP/'${NODE2_LISTENER_IP}'/g' > tnsnames1.ora.tmp
sed 's/SID/'${SID}'/g' tnsnames2.ora | sed 's/DOMAIN_NAME/'${DOMAIN_NAME}'/g' | sed 's/NODE1_LISTENER_IP/'${NODE1_LISTENER_IP}'/g' | sed 's/NODE2_LISTENER_IP/'${NODE2_LISTENER_IP}'/g' > tnsnames2.ora.tmp

######sed 's/SID/'${SID}'/g' listener1.sh | sed 's/DOMAIN_NAME/'${DOMAIN_NAME}'/g' | sed 's/NODE1NAME/'${NODE1NAME}'/g' | sed 's/NODE2_LISTENER_IP/'${NODE2_LISTENER_IP}'/g' > listener1.sh.tmp
#######sed 's/SID/'${SID}'/g' listener2.sh | sed 's/DOMAIN_NAME/'${DOMAIN_NAME}'/g' | sed 's/NODE1NAME/'${NODE1NAME}'/g' | sed 's/NODE2_LISTENER_IP/'${NODE2_LISTENER_IP}'/g' > listener2.sh.tmp

mv CreateClustDBViews.sql.tmp CreateClustDBViews.sql
mv CreateDB.sql.tmp CreateDB.sql
mv CreateDBCatalog.sql.tmp CreateDBCatalog.sql
mv CreateDBFiles.sql.tmp CreateDBFiles.sql
mv JServer.sql.tmp JServer.sql
mv orapw-config.sh.tmp orapw-config.sh
mv postDBCreation.sql.tmp postDBCreation.sql
mv ${SID}1.sh.tmp ${SID}1.sh
mv ${SID}2.sh.tmp ${SID}2.sh
mv init.ora.tmp init.ora
mv init${SID}1.ora.tmp init${SID}1.ora
mv init${SID}2.ora.tmp init${SID}2.ora
mv listener1_block.ora.tmp listener1_block.ora
#######mv listener2.ora.tmp listener2.ora
mv tnsnames1.ora.tmp tnsnames1.ora
mv tnsnames2.ora.tmp tnsnames2.ora
####mv listener1.sh.tmp listener1.sh
####mv listener2.sh.tmp listener2.sh

if [ -f $ORACLE_HOME/network/admin/listener.ora ]
then
   cp $ORACLE_HOME/network/admin/listener.ora listener1.ora
fi

   ./insertBlock_1.sh
   mv listener1.ora.out listener1.ora
   cp -p listener1.ora $ORACLE_HOME/network/admin/listener.ora
   sed 's/'${NODE1_LISTENER_IP}'/'${NODE2_LISTENER_IP}'/g' listener1.ora > listener2.ora
   rcp -p listener2.ora  $NODE2_IP:$ORACLE_HOME/network/admin/listener.ora

chmod u+x *sh

mkdir -p /opt/db01/app/oracle/admin/${SID}/scripts
cp -rp ${PWD}/* /opt/db01/app/oracle/admin/${SID}/scripts

### Create RAC Database
sh /opt/db01/app/oracle/admin/${SID}/scripts/${SID}1.sh

######### config the srvctl utility for rac
srvctl add database -d ${SID} -o ${ORACLE_HOME}
srvctl add instance -d ${SID} -i ${SID}1 -n ${NODE1NAME}
srvctl add instance -d ${SID} -i ${SID}2 -n ${NODE2NAME}

srvctl start database -d ${SID}


echo ""
echo "**** End - RAC Database ${SID} Creation at `date` ****"
echo ""
